#!/bin/bash

echo "Deploying the Azure resources..."

# Define resource group parameters
RG_NAME="rg-contoso-agent-workshop"
RG_LOCATION="westus"
MODEL_NAME="gpt-4o"
AI_HUB_NAME="agent-wksp"
AI_PROJECT_NAME="agent-workshop"
STORAGE_NAME="agentservicestorage"
AI_SERVICES_NAME="agent-workshop"
MODEL_CAPACITY=140

# Register the Bing Search resource provider
az provider register --namespace 'Microsoft.Bing'

# Create the resource group
az group create --name "$RG_NAME" --location "$RG_LOCATION"

# Deploy the Azure resources and save output to JSON
az deployment group create \
  --resource-group "$RG_NAME" \
  --template-file main.bicep \
  --parameters aiHubName="$AI_HUB_NAME" \
      aiProjectName="$AI_PROJECT_NAME" \
      storageName="$STORAGE_NAME" \
      aiServicesName="$AI_SERVICES_NAME" \
      modelName="$MODEL_NAME" \
      modelCapacity="$MODEL_CAPACITY" \
      modelLocation="$RG_LOCATION" > output.json

# Parse the JSON file manually using grep and sed
if [ -f output.json ]; then
  AI_PROJECT_NAME=$(grep -oP '"aiProjectName":\s*{\s*"value":\s*"\K[^"]*' output.json)
  RESOURCE_GROUP_NAME=$(grep -oP '"resourceGroupName":\s*{\s*"value":\s*"\K[^"]*' output.json)
  SUBSCRIPTION_ID=$(grep -oP '"subscriptionId":\s*{\s*"value":\s*"\K[^"]*' output.json)
  BING_GROUNDING_NAME=$(grep -oP '"bingGroundingName":\s*{\s*"value":\s*"\K[^"]*' output.json)

  # Run the Azure CLI command to get discovery_url
  DISCOVERY_URL=$(az ml workspace show -n "$AI_PROJECT_NAME" --resource-group "$RESOURCE_GROUP_NAME" --query discovery_url -o tsv)

  if [ -n "$DISCOVERY_URL" ]; then
    # Process the discovery_url to extract the HostName
    HOST_NAME=$(echo "$DISCOVERY_URL" | sed -e 's|^https://||' -e 's|/discovery$||')

    # Generate the PROJECT_CONNECTION_STRING
    PROJECT_CONNECTION_STRING="\"$HOST_NAME;$SUBSCRIPTION_ID;$RESOURCE_GROUP_NAME;$AI_PROJECT_NAME\""

    ENV_FILE_PATH=".env"

    # Delete the file if it exists
    [ -f "$ENV_FILE_PATH" ] && rm "$ENV_FILE_PATH"

    # Write to the .env file
    {
      echo "PROJECT_CONNECTION_STRING=$PROJECT_CONNECTION_STRING"
      echo "BING_CONNECTION_NAME=$BING_GROUNDING_NAME"
      echo "MODEL_DEPLOYMENT_NAME=$MODEL_NAME"
    } > "$ENV_FILE_PATH"

    # Delete the output.json file
    rm -f output.json
  else
    echo "Error: discovery_url not found."
  fi
else
  echo "Error: output.json not found."
fi