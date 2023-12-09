#!/bin/bash

RG=rg-robbelouwet-01
PARAMETERS_FILE=$(dirname -- $0)/parameters.json

az deployment group create --resource-group $RG --template-file $(dirname -- $0)/infra.bicep --parameters $PARAMETERS_FILE

az deployment group create --resource-group $RG --template-file $(dirname -- $0)/main.bicep --parameters $PARAMETERS_FILE