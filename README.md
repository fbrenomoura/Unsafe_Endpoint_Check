# Unsafe Endpoint Check

## Overview
`Unsafe Endpoint Check` is a security gate designed to assess the safety of endpoints within your application. Whether integrated into your pipeline (e.g., Jenkins, GitLab CI/CD, GitHub Actions, Atlassian Bamboo) or used manually, it provides a comprehensive evaluation of HTTP endpoints' security status. The script scans through Java, GO, JS, C/C++ (and more) project files files, identifies HTTP endpoints, verifies their authentication status, through HTTP response, and generates detailed HTML reports for analysis.
Also this gate helps to protect your code against API2:2023 - Broken Authentication from the OWASP API Top 10.

## Features
- **Endpoint Security Check**: Scan files (including .json, .java, .c, .cpp, .h, .hpp, .go, .js, .sql, .properties, .py) for HTTP endpoints and assess their security status.
- **Authentication Verification**: Verify if endpoints require authentication and assess their accessibility.
- **Bypass Configuration**: Support for bypassing specific endpoints via configuration.
- **HTML Report Generation**: Detailed HTML report generation summarizing endpoint statuses.

## Prerequisites
- `bash`: Ensure that your system supports Bash scripting. The `Unsafe Endpoint Check` relies on Bash scripts for execution.
- `curl`: Required for HTTP request handling.
- Read and write permissions.
- Internet connection.
- Ensure the `Unsafe_Endpoint_Check` folder is present in your application's root directory.

## Usage

### Manual Use
1. Clone or download the repository to your local machine.
2. Place the `Unsafe_Endpoint_Check` folder in the root directory of your application.
3. Run the `MainUnsafeEndpointCheck.sh`. The report will be generated in the root of the workspace with the title format "UnsafeEndpointCheck_Results_yyyymmdd_hhmmss.html". If an unsafe endpoint is detected, the process will be terminated with a failure.

### Integration with Automation Pipeline Servers (e.g., Jenkins)
1. Ensure the `Unsafe_Endpoint_Check` folder is present in your automation pipeline server's workspace.
2. Configure your automation pipeline to execute `MainUnsafeEndpointCheck.sh` as part of the security check process.
3. Follow the pipeline execution logs to monitor the progress of the security check.
4. Review the detailed HTML report generated upon completion for a comprehensive analysis of endpoint security status. The report will be generated in the root of the workspace with the title format "UnsafeEndpointCheck_Results_yyyymmdd_hhmmss.html". If an unsafe endpoint is detected, the pipeline process will be terminated with a failure.

## Report Structure
The HTML report includes the following sections:
- **Results**: Detailed table showcasing endpoint status, URL, associated file, and response.
  - **Status**: The status of the endpoint check (e.g., SAFE, UNSAFE, BYPASS, UNREACHABLE).
  - **Endpoint**: The URL of the endpoint being assessed.
  - **File**: The file associated with the endpoint where it was discovered.
  - **Response**: The HTTP response code received from the endpoint.
- **Summary of Results**: Pie chart summarizing safe, unsafe, bypassed, and unreachable endpoints.
- **Legend**: Explanation of status codes and their meanings.
- **Risks of Insecure Authentication Endpoints**: Information on security risks associated with insecure endpoints.
- **Execution Environment**: Details about the system where the script was executed, including hostname and operating system.
- **Timestamp**: Date and time of report generation.

## Bypassing Endpoints
If you need to bypass specific endpoints from being checked, you can configure the bypass list in the `bypass_endpoints.json` file located in the `Unsafe_Endpoint_Check` folder.

## Contribution
Contributions are welcome! If you encounter any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request.
If you found this project useful, maybe [buy me a coffee!](https://ko-fi.com/fbrenomoura) ☕️ and follow me for more [LinkedIn](https://linkedin.com/in/fbrenomoura/).

## License
This project is licensed under the MIT License.
