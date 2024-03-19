#!/bin/bash

# Function to generate HTML report
generate_html_report() {
    local html_file="$1"
    local report_title="UNSAFE ENDPOINT CHECK - REPORT"
    local html_content="<html><head><title>$report_title</title><link href='https://fonts.googleapis.com/css2?family=Poppins&display=swap' rel='stylesheet'><script src='https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js'></script><style>body { font-family: 'Poppins', sans-serif; background-color: #f0f4f7; margin: 20px; } table { width: 100%; border-collapse: collapse; margin-bottom: 20px; } th, td { border: 1px solid #ddd; padding: 8px; text-align: left; } th { background-color: #f2f2f2; } td.safe { color: #008000; font-weight: bold; } td.unsafe { background-color: #ff0000; color: #ffffff; font-weight: bold; } td.bypass { color: #ffa500; font-weight: bold; } td.unreachable { color: #808080; font-weight: bold; } .summary { font-size: larger; } .summary p { margin: 5px 0; } .summary .SAFE { color: #008000; } .summary .UNSAFE { color: #ff0000; font-weight: bold; } .summary .BYPASS { color: #ffa500; } .summary .UNREACHABLE { color: #808080; } .chart-container { width: 350px; height: 350px; margin-right: 20px; } .endpoint-info { margin-top: 20px; } .legend-container { clear: both; font-size: smaller; }</style></head><body>"
    
    # Add title to HTML report
    html_content+="<h1>$report_title</h1>"

    # Add results section title
    html_content+="<h2>RESULTS</h2>"
    
    # Add table header to HTML report
    html_content+="<table><thead><tr><th>STATUS</th><th>ENDPOINT</th><th>FILE</th><th>RESPONSE</th></tr></thead><tbody>"
    
    # Initialize variables for summary of results
    local total_endpoints=0
    local safe_endpoints=0
    local unsafe_endpoints=0
    local bypassed_endpoints=0
    local unreachable_endpoints=0
    
    # Add messages to HTML report and calculate summary of results
    for message in "${messages[@]}"; do
        # Remove ANSI escape codes for formatting
        message_no_formatting=$(echo -e "$message" | sed 's/\x1B\[[0-9;]*[JKmsu]//g')
        
        # Separate the message into status, endpoint, file, and response
        status=$(echo "$message_no_formatting" | awk '{print $1}' | sed 's/://') # Remove colon
        endpoint=$(echo "$message_no_formatting" | awk -F 'Endpoint: ' '{print $2}' | awk -F ' - File:' '{print $1}')
        file=$(echo "$message_no_formatting" | awk -F 'File: ' '{print $2}' | awk -F ' - Response:' '{print $1}')
        response=$(echo "$message_no_formatting" | awk -F 'Response: ' '{print $2}')
        
        # Apply class based on status
        case $status in
            "SAFE")
                status_class="safe"
                ((safe_endpoints++))
                ;;
            "UNSAFE")
                status_class="unsafe"
                ((unsafe_endpoints++))
                ;;
            "BYPASS")
                status_class="bypass"
                ((bypassed_endpoints++))
                ;;
            "UNREACHABLE")
                status_class="unreachable"
                ((unreachable_endpoints++))
                ;;
            *)
                status_class=""
                ;;
        esac
        
        # Add table row to HTML report
        html_content+="<tr><td class='$status_class'>$status</td><td>$endpoint</td><td>$file</td><td>$response</td></tr>"
        
        ((total_endpoints++))
    done
    
    # Close HTML table
    html_content+="</tbody></table>"
    
    # Add endpoint information
    html_content+="<div class='endpoint-info'>"
    html_content+="<p><b>ENDPOINTS FOUND:</b> $total_endpoints</p>"
    html_content+="</div>"
    
    # Add pie chart for summary of results inside a container
    html_content+="<div class='chart-container'>"
    html_content+="<canvas id='summaryChart'></canvas>"
    html_content+="</div>"
    
    html_content+="<script>"
    html_content+="window.addEventListener('scroll', function() {"
    html_content+="var summaryChart = document.getElementById('summaryChart');"
    html_content+="var chartPosition = summaryChart.getBoundingClientRect().top;"
    html_content+="var screenPosition = window.innerHeight / 1.2;"
    html_content+="if (chartPosition < screenPosition) {"
    html_content+="var ctx = summaryChart.getContext('2d');"
    html_content+="var summaryChart = new Chart(ctx, {"
    html_content+="type: 'pie',"
    html_content+="data: {"
    html_content+="labels: ['Safe', 'Unsafe', 'Bypass', 'Unreachable'],"
    html_content+="datasets: [{"
    html_content+="label: 'Summary of Results',"
    html_content+="data: [$safe_endpoints, $unsafe_endpoints, $bypassed_endpoints, $unreachable_endpoints],"
    html_content+="backgroundColor: ['#008000', '#ff0000', '#ffa500', '#808080']"
    html_content+="}]"
    html_content+="},"
    html_content+="options: {"
    html_content+="legend: { display: true },"
    html_content+="title: { display: true, text: 'Summary of Results' },"
    html_content+="animation: { duration: 2000 }" # Adjust animation speed (default is 1000)
    html_content+="}"
    html_content+="});"
    html_content+="window.removeEventListener('scroll', this);"
    html_content+="}"
    html_content+="});"
    html_content+="</script>"
    
    # Add legend
    html_content+="<div class='legend-container'>"
    html_content+="<h3>LEGEND:</h3>"
    html_content+="<ul>"
    html_content+="<h4>COLUMNS:</h4>"
    html_content+="<li><b>STATUS:</b> The status of the endpoint check.</li>"
    html_content+="<li><b>ENDPOINT:</b> The URL of the endpoint.</li>"
    html_content+="<li><b>FILE:</b> The file associated with the endpoint.</li>"
    html_content+="<li><b>RESPONSE:</b> The response received from the endpoint.</li>"
    html_content+="<h4>STATUS:</h4>"
    html_content+="<li><b><span class='SAFE'>SAFE:</span></b> The server denied the connection because no authentication information was provided.</li>"
    html_content+="<li><b><span class='UNSAFE'>UNSAFE:</span></b> The server received the request and returned success, i.e., no authentication was requested.</li>"
    html_content+="<li><b><span class='BYPASS'>BYPASS:</span></b> The user configured the endpoint as bypass in the bypass_endpoints.json file.</li>"
    html_content+="<li><b><span class='UNREACHABLE'>UNREACHABLE:</span></b> The endpoint could not be reached.</li>"
    html_content+="</ul>"
    html_content+="</div>"
    
    # Add text about the risks of insecure authentication endpoints
    html_content+="<hr>"
    html_content+="<h2>RISKS OF INSECURE AUTHENTICATION ENDPOINTS:</h2>"
    html_content+="<p>An insecure authentication endpoint can lead to various security risks, including:</p>"
    html_content+="<ul>"
    html_content+="<li>Unauthorized access to sensitive data or functionalities.</li>"
    html_content+="<li>Session hijacking or impersonation attacks.</li>"
    html_content+="<li>Brute force attacks against user credentials.</li>"
    html_content+="</ul>"
    html_content+="<p>It's crucial to secure authentication endpoints to mitigate these risks and protect your application and users.</p>"
    html_content+="<p>More information about API Security can be found <a href='https://owasp.org/API-Security/editions/2023/en/0x00-header/'>here</a>.</p>"
    
    # Add text about the machine/system where the program was executed
    html_content+="<hr>"
    html_content+="<h2>EXECUTION ENVIRONMENT:</h2>"
    html_content+="<p>This report was generated on the following machine/system:</p>"
    html_content+="<ul>"
    html_content+="<li><b>Hostname:</b> $(hostname)</li>"
    html_content+="<li><b>Operating System:</b> $(uname -srm)</li>"
    html_content+="</ul>"
    
    # Add timestamp
    html_content+="<p>Generated on: $(date)</p>"
    
    # Close HTML body and HTML file
    html_content+="</body></html>"
    
    # Write HTML content to file
    echo "$html_content" > "$html_file"

    echo -e "${BOLD}HTML report generated: $html_file ${RESET}"
}
