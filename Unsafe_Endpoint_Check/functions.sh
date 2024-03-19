#!/bin/bash

source reportCreator.sh

#----------------------------
# Variables declaration

# Formatting
BOLD=$(tput bold)
GREEN_BOLD='\033[1;32m'
RED_BOLD='\033[1;31m'
YELLOW_BOLD='\033[1;33m'
GREY_BOLD='\033[1;90m'
RESET='\033[0m'

timestamp=$(date +"%Y%m%d_%H%M%S")
log_file="UnsafeEndpointCheck_Results_${timestamp}.html"

declare -A endpoints_status
messages=()

#----------------------------
# Functions declaration

check_curl_availability() {
    if ! command -v curl &>/dev/null; then
        echo "ERROR: 'curl' command not found. Please install curl to proceed." >&2
        exit 1
    fi
}

check_file_permissions() {
    local required_files=("Unsafe_Endpoint_Check/bypass_endpoints.json")  # Add other required files as needed
    
    for file in "${required_files[@]}"; do
        if [ ! -r "$file" ] || [ ! -w "$file" ]; then
            echo "ERROR: Insufficient permissions to read or write to the file: $file" >&2
            exit 1
        fi
    done
}

# Check if at least one file with listed extensions are found (except in the Unsafe_Endpoint_Check folder)
check_required_files_existence() {
    if ! find . \( -path "./Unsafe_Endpoint_Check" -prune \) -o \( -type f \( -name "*.java" -o -name "*.json" -o -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" -o -name "*.go" -o -name "*.js" -o -name "*.sql" -o -name "*.properties" \) \) -print -quit | grep -q "."; then
        echo "ERROR: No files found (.java, .json, .c, .cpp, .h, .hpp, .go, .js, .sql, .properties)" >&2
        exit 1
    fi
}

check_internet_connection() {
    if ! curl -s --head http://google.com/ 2>&1 >/dev/null; then
        echo "ERROR: No internet connection. Please check your internet connection and try again." >&2
        exit 1
    fi
}

# function that calls all prerequisite checking functions
check_prerequisites() {
    check_curl_availability
    check_file_permissions
    check_required_files_existence
    check_internet_connection
}

# Function to check endpoint authentication and accessibility
check_authentication() {
    local endpoint=$1
    local file=$2
    local message=""

    # Check if the endpoint is in the bypass list
    if grep -q "\"$endpoint\"" Unsafe_Endpoint_Check/bypass_endpoints.json && [[ "$file" != "Unsafe_Endpoint_Check/bypass_endpoints.json" ]]; then
        message="${YELLOW_BOLD}${BOLD}BYPASS:${RESET}${RESET} ${BOLD}Endpoint:${RESET} $endpoint - ${BOLD}File:${RESET} $file"
        endpoints_status["$endpoint"]="BYPASS"
    else
        # Check if the endpoint has been checked previously
        if [[ -n ${endpoints_status["$endpoint"]} ]]; then
            status=${endpoints_status["$endpoint"]}
            if [ "$status" == "SAFE" ]; then
                message="${GREEN_BOLD}${BOLD}SAFE:${RESET}${RESET} ${BOLD}Endpoint:${RESET} $endpoint - ${BOLD}File:${RESET} $file - ${BOLD}Response:${RESET} Already tested"
            elif [ "$status" == "UNSAFE" ]; then
                message="${RED_BOLD}${BOLD}UNSAFE:${RESET}${RESET} ${BOLD}Endpoint:${RESET} $endpoint - ${BOLD}File:${RESET} $file - ${BOLD}Response:${RESET} Already tested"
            else
                message="${GREY_BOLD}${BOLD}UNREACHABLE:${RESET}${RESET} ${BOLD}Endpoint:${RESET} $endpoint - ${BOLD}File:${RESET} $file - ${BOLD}Response:${RESET} Already tested"
            fi
        else
            # Check endpoint status with curl
            response=$(curl -s -o /dev/null -w "%{http_code}" "$endpoint")
            if [ "$response" -ge 100 ] && [ "$response" -lt 400 ]; then
                message="${RED_BOLD}${BOLD}UNSAFE:${RESET}${RESET} ${BOLD}Endpoint:${RESET} $endpoint - ${BOLD}File:${RESET} $file - ${BOLD}Response:${RESET} $response"
                endpoints_status["$endpoint"]="UNSAFE"  # Mark endpoint as unsafe
            elif [ "$response" -eq 000 ] || [ "$response" -eq 404 ] || [ "$response" -eq 504 ] || [ "$response" -eq 429 ]; then
                message="${GREY_BOLD}${BOLD}UNREACHABLE:${RESET}${RESET} ${BOLD}Endpoint:${RESET} $endpoint - ${BOLD}File:${RESET} $file - ${BOLD}Response:${RESET} $response"
                endpoints_status["$endpoint"]="UNREACHABLE"  # Mark endpoint as unreachable
            else
                message="${GREEN_BOLD}${BOLD}SAFE:${RESET}${RESET} ${BOLD}Endpoint:${RESET} $endpoint - ${BOLD}File:${RESET} $file - ${BOLD}Response:${RESET} $response"
                endpoints_status["$endpoint"]="SAFE"  # Mark endpoint as safe
            fi
        fi
    fi
    # Add message to messages array
    messages+=("$message")
}

# Function to display progress
print_progress() {
    local current=$1
    local total=$2
    local percentage=$((current * 100 / total))
    local spinner

    case $((current % 4)) in
        0) spinner="-";;
        1) spinner="\\";;
        2) spinner="|";;
        3) spinner="/";;
    esac
    echo -ne "\rProgress: $percentage% $spinner"
}

# Find endpoints in files
find_endpoints() {
    local files
    local total_files
    local current_file=0
    
    files=$(find . -type f \( -name "*.json" -o -name "*.java" -o -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" -o -name "*.go" -o -name "*.js"-o -name "*.sql" -o -name "*.properties" \) -not -name "bypass_endpoints.json")
    total_files=$(echo "$files" | wc -l)
    
    while IFS= read -r file; do
        ((current_file++))
        print_progress "$current_file" "$total_files"
        endpoints=$(grep -oE '"(http|https)://[^"]+"' "$file" | tr -d '"')
        for endpoint in $endpoints; do
            check_authentication "$endpoint" "$file"
        done
    done <<< "$files"
    echo
}

# Check status and quit
check_final_status() {
    # Sort final messages
    sorted_messages=$(printf '%s\n' "${messages[@]}" | sort -r)

    # Print final messages after processing
    echo -e "$sorted_messages"

    # Check if there are any insecure endpoints in the array
    for message in "${messages[@]}"; do
        if [[ $message == *"UNSAFE:"* ]]; then
            echo -e "\n${RED_BOLD}ERROR: Insecure endpoints found!${RESET}\n"

            # Call function to generate HTML report
            generate_html_report "$log_file"

            exit 1
        fi
    done

    # If there are no insecure endpoints, print a success message and exit with code 0
    echo -e "\n${GREEN_BOLD}SUCCESS: No insecure endpoints found.${RESET}\n"

    # Call function to generate HTML report
    generate_html_report "$log_file"

    exit 0
}
