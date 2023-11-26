#!/bin/bash

RG=rg-robbelouwet-02
PARAMETERS_FILE=parameters.json

# az deployment group create --resource-group $RG --template-file ./infra.bicep --parameters $PARAMETERS_FILE

az deployment group create --resource-group $RG --template-file ./main.bicep --parameters $PARAMETERS_FILE