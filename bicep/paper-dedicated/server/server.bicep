param servername string
param appName string
param storageName string
param cappEnvName string

var location = resourceGroup().location
var fileShareName = 'fs-${servername}'

resource cappEnvironment 'Microsoft.App/managedEnvironments@2023-05-01' existing = {
  name: cappEnvName
}

resource storageAccResource 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageName
}

module fileShareModule '../../ResourceModules/modules/storage/storage-account/file-service/share/main.bicep' = {
  name: 'fs-${servername}-deployment'
  params: {
    name: fileShareName
    storageAccountName: storageAccResource.name
    fileServicesName: 'default' //'${storageAccResource.name}-fs'
    accessTier: 'Hot'
    enabledProtocols: 'SMB'
  }
}

resource storageDef 'Microsoft.App/managedEnvironments/storages@2023-05-01' = {
  name: 'st-def-${servername}'
  parent: cappEnvironment
  properties: {
    azureFile: {
      accessMode: 'ReadWrite'
      accountKey: storageAccResource.listKeys().keys[0].value
      accountName: storageName
      shareName: fileShareModule.outputs.name
    }
  }
}

resource paperCAPP 'Microsoft.App/containerapps@2023-05-02-preview' = {
  name: '${appName}-server'
  location: location
  // identity: {
  //   type: 'UserAssigned'
  //   userAssignedIdentities: {
  //     '${idPaperServer.id}': {}
  //   }
  // }
  properties: {
    managedEnvironmentId: cappEnvironment.id
    configuration: {
      ingress: {
        external: true
        targetPort: 25565
        exposedPort: 25565
        transport: 'Tcp'
        traffic: [
          {
            weight: 100
            latestRevision: true
          }
        ]
      }
    }
    template: {
      containers: [
        {
          image: 'robbelouwet/paper-dedicated:latest'
          name: 'server-container'
          env: [
            {
              name: 'VELOCITY_SECRET'
              value: ''
            }
            {
              name: 'JVM_ARGS'
              value: '-Xms1G -Xmx2G'
            }
          ]
          resources: {
            cpu: json('1.5')
            memory: '3Gi'
          }
          probes: []
          volumeMounts: [
            {
              volumeName: fileShareName
              mountPath: '/data'
            }
          ]
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 1
      }
      volumes: [
        {
          name: fileShareName
          storageType: 'AzureFile'
          storageName: storageDef.name
        }
      ]
    }
  }
}
