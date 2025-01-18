# Deployment (Optional)

If you’re running this workshop on your own, you'll need to deploy the workshop resources to your Azure subscription. Follow the instructions to deploy the workshop resources.

## Prerequisites

1. An Azure subscription. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/){:target="_blank"} before you begin.
2. Install the [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli){:target="_blank"}.
3. Install [Powershell (supported on Windows, macOS, and Linux)](https://learn.microsoft.com/powershell/scripting/install/installing-powershell){:target="_blank"}.
4. Open a terminal window.
5. Clone the workshop repo by running the following command:

    ```bash
    git clone https://github.com/gloveboxes/build-your-first-agent-with-azure-ai-agent-service-lab.git
    ```

6. Navigate to the workshop `infra` folder for the repository you cloned in the previous step.

    ```bash
    pwsh deploy.ps1
    ```

7. Follow the prompts to deploy the workshop resources to your Azure subscription.

## Run the workshop

Once the deployment is complete, follow the steps in the [Lab Introduction](./lab_introduction.md) to run the workshop.
