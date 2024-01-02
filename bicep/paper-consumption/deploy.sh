#!/bin/bash

rg=rg-robbelouwet-02

# az deployment group create --resource-group $rg --template-file hub/main.bicep --parameters hub/hub.dev.bicepparam

results=$(az deployment group create --resource-group $rg --template-file server/server.bicep --parameters server/server.dev.bicepparam)

container_hostname=$(echo $results | jq -r '.properties.outputs.hostname.value')

az containerapp update --resource-group $rg -n 'paper-auto-velocity' --set-env-vars "PAPER1_HOST=$container_hostname:25566" "PAPER2_HOST=${container_hostname}:25566"
