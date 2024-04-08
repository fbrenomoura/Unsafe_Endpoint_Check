### [EN]
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

### [PT-BR]
# Unsafe Endpoint Check

## Visão Geral
`Unsafe Endpoint Check` é um portão de segurança projetado para avaliar a segurança dos endpoints dentro da sua aplicação. Seja integrado ao seu pipeline (por exemplo, Jenkins, GitLab CI/CD, GitHub Actions, Atlassian Bamboo) ou usado manualmente, ele fornece uma avaliação abrangente do status de segurança dos endpoints HTTP. O script percorre arquivos de projetos Java, GO, JS, C/C++ (e mais), identifica endpoints HTTP, verifica seu status de autenticação por meio da resposta HTTP e gera relatórios HTML detalhados para análise. Além disso, esse portão ajuda a proteger seu código contra a API2:2023 - Autenticação Quebrada do OWASP API Top 10.

## Recursos
- **Verificação de Segurança de Endpoints**: Escaneie arquivos (incluindo .json, .java, .c, .cpp, .h, .hpp, .go, .js, .sql, .properties, .py) para endpoints HTTP e avalie seu status de segurança.
- **Verificação de Autenticação**: Verifique se os endpoints exigem autenticação e avalie sua acessibilidade.
- **Configuração de Bypass**: Suporte para realizar bypass em endpoints específicos através de configuração.
- **Geração de Relatório HTML**: Geração de relatório HTML detalhado que resume os status dos endpoints.

## Pré-requisitos
- `bash`: Garanta que o seu sistema suporta scripting Bash. O `Unsafe Endpoint Check` depende de scripts Bash para execução.
- `curl`: Necessário para manipulação de solicitações HTTP.
- Permissões de leitura e escrita.
- Conexão com a Internet.
- Certifique-se de que a pasta `Unsafe_Endpoint_Check` está presente no diretório raiz da sua aplicação.

## Uso

### Uso Manual
1. Clone ou baixe o repositório para a sua máquina local.
2. Coloque a pasta `Unsafe_Endpoint_Check` no diretório raiz da sua aplicação.
3. Execute o `MainUnsafeEndpointCheck.sh`. O relatório será gerado no diretório raiz do espaço de trabalho com o formato de título "UnsafeEndpointCheck_Results_yyyymmdd_hhmmss.html". Se um endpoints inseguro for detectado, o processo será encerrado com falha.

### Integração com Servidores de Automação de Pipeline (por exemplo, Jenkins)
1. Garanta que a pasta `Unsafe_Endpoint_Check` esteja presente no espaço de trabalho do seu servidor de automação de pipeline.
2. Configure o seu pipeline de automação para executar `MainUnsafeEndpointCheck.sh` como parte do processo de verificação de segurança.
3. Siga os logs de execução do pipeline para monitorar o progresso da verificação de segurança.
4. Analise o relatório HTML detalhado gerado ao término para uma análise abrangente do status de segurança dos endpoints. O relatório será gerado no diretório raiz do espaço de trabalho com o formato de título "UnsafeEndpointCheck_Results_yyyymmdd_hhmmss.html". Se um endpoint inseguro for detectado, o processo do pipeline será encerrado com falha.

## Estrutura do Relatório
O relatório HTML inclui as seguintes seções:
- **Resultados**: Tabela detalhada que mostra o status do endpoint, URL, arquivo associado e resposta.
  - **Status**: O status da verificação do endpoint (por exemplo, SEGURO, INSEGURO, BYPASS, INALCANÇÁVEL).
  - **Endpoints**: A URL do endpoint sendo avaliado.
  - **Arquivo**: O arquivo associado ao endpoint onde foi descoberto.
  - **Resposta**: O código de resposta HTTP recebido do endpoint.
- **Resumo dos Resultados**: Gráfico de pizza que resume os endpoints seguros, inseguros, "bypassados" e inalcançáveis.
- **Legenda**: Explicação dos códigos de status e seus significados.
- **Riscos de Endpoints com Autenticação Insegura**: Informações sobre os riscos de segurança associados aos endpoints inseguros.
- **Ambiente de Execução**: Detalhes sobre o sistema onde o script foi executado, incluindo nome do host e sistema operacional.
- **Timestamp**: Data e hora da geração do relatório.

## Bypass de Endpoints
Se você precisar realizar o bypass de endpoints específicos de serem verificados, pode configurar a lista de bypass no arquivo `bypass_endpoints.json` localizado na pasta `Unsafe_Endpoint_Check`.

## Contribuição
Contribuições são bem-vindas! Se você encontrar algum problema ou tiver sugestões de melhorias, sinta-se à vontade para abrir um problema ou enviar um pull request.
Se achou este projeto útil, talvez queira [me comprar um café!](https://ko-fi.com/fbrenomoura) ☕️ e me seguir para mais [LinkedIn](https://linkedin.com/in/fbrenomoura/).

## Licença
Este projeto está licenciado sob a Licença MIT.
