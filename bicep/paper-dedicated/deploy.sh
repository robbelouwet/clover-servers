#!/bin/bash

rg=rg-robbelouwet-01

# az deployment group create --resource-group $rg --template-file hub/main.bicep --parameters hub/hub.dev.bicepparam

results=$(az deployment group create --resource-group $rg --template-file server/server.bicep --parameters server/server.dev.bicepparam)