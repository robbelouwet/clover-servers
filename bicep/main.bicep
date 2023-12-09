param affix string
param escapedAffix string
param workspaceName string
param storageName string
param vnetName string
param cappEnvSubnetName string
param paperShareName string

var location = resourceGroup().location
var cappStorageDefName = '${affix}-velocity-storage-def'

resource workspaceResource 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: workspaceName
}

resource cappEnvironment 'Microsoft.App/managedEnvironments@2022-10-01' = {
  name: '${affix}-container-env'
  location: location
  sku: { name: 'Consumption' }
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: workspaceResource.properties.customerId
        sharedKey: workspaceResource.listKeys().primarySharedKey
      }
    }
    vnetConfiguration: {
      internal: false
      infrastructureSubnetId: az.resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, cappEnvSubnetName)
      dockerBridgeCidr: '10.2.0.1/16'
      platformReservedCidr: '10.1.0.0/16'
      platformReservedDnsIP: '10.1.0.2'
    }
  }
  dependsOn: [ workspaceResource ]
}

// resource storageAccResource 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
//   name: storageName
// }

// resource velocityStorageDefModule 'Microsoft.App/managedEnvironments/storages@2023-05-01' = {
//   name: cappStorageDefName
//   parent: cappEnvironment
//   properties: {
//     azureFile: {
//       accessMode: 'ReadWrite'
//       accountKey: storageAccResource.listKeys().keys[0].value
//       accountName: storageName
//       shareName: paperShareName
//     }
//   }
//   dependsOn: [ storageAccResource ]
// }

// resource cappEnvironment 'Microsoft.App/managedEnvironments@2023-05-01' existing = {
//   name: '${affix}-container-env'
// }

resource velocityCAPP 'Microsoft.App/containerapps@2023-05-02-preview' = {
  name: '${affix}-velocity'
  location: location
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
          image: 'robbelouwet/velocity:latest'
          name: 'velocity-container'
          env: [
            {
              name: 'VELOCITY_SECRET'
              value: 'supersecret1234'
            }
            {
              name: 'PAPER1_HOST'
              value: '${paperCAPP.properties.configuration.ingress.fqdn}:25566'
            }
            {
              name: 'PAPER2_HOST'
              value: '${paperCAPP.properties.configuration.ingress.fqdn}:25566'
            }
          ]
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 10
      }
    }
  }
  dependsOn: [ cappEnvironment ]
}

resource paperCAPP 'Microsoft.App/containerapps@2023-05-02-preview' = {
  name: '${affix}-server'
  location: location
  properties: {
    managedEnvironmentId: cappEnvironment.id
    configuration: {
      ingress: {
        external: true
        targetPort: 25565
        exposedPort: 25566
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
          image: 'robbelouwet/papermc:latest'
          name: 'server-container'
          env: [
            {
              name: 'VELOCITY_SECRET'
              value: 'supersecret1234'
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
          // volumeMounts: [
          //   {
          //     volumeName: paperShareName
          //     mountPath: '/data'
          //   }
          // ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
      // volumes: [
      //   {
      //     name: paperShareName
      //     storageType: 'AzureFile'
      //     storageName: cappStorageDefName
      //   }
      // ]
    }
  }
  dependsOn: [ cappEnvironment ]
}

// resource ubuntuCAPP 'Microsoft.App/containerapps@2023-05-02-preview' = {
//   name: '${affix}-ubuntu'
//   location: location
//   properties: {
//     managedEnvironmentId: cappEnvironment.id
//     // environmentId: managedEnvironments_managedEnvironment_rgrobbelouwet02_a45e_name_resource.id
//     configuration: {

//       // activeRevisionsMode: 'Single'
//       ingress: {
//         external: true
//         targetPort: 22
//         exposedPort: 22
//         transport: 'Tcp'
//         traffic: [
//           {
//             weight: 100
//             latestRevision: true
//           }
//         ]
//         // allowInsecure: false
//         // stickySessions: {
//         //   affinity: 'none'
//         // }
//       }
//     }
//     template: {
//       containers: [
//         {
//           image: 'takeyamajp/ubuntu-sshd'
//           name: 'ubuntu-container'
//           env: [
//             {
//               name: 'ROOT_PASSWORD'
//               value: 'root'
//             }
//           ]
//           resources: {
//             cpu: json('1')
//             memory: '2Gi'
//           }
//           volumeMounts: [
//             {
//               volumeName: paperShareName
//               mountPath: '/appelbanaan'
//             }
//           ]
//         }
//       ]
//       scale: {
//         minReplicas: 1
//         maxReplicas: 1
//       }
//       volumes: [
//         {
//           name: paperShareName
//           storageType: 'AzureFile'
//           storageName: cappStorageDefName
//         }
//       ]
//     }
//   }
// }

// output storageAccountAccessKey string = storageAccResource.listKeys().keys[0].value

// output workspacePrimaryKey string = workspaceResource.listKeys().primarySharedKey
