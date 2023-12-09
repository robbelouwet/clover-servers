param affix string
param escapedAffix string
param workspaceName string
param storageName string
param vnetName string
param cappEnvSubnetName string
param paperShareName string

var location = resourceGroup().location

var defaultSubnet = '10.0.0.0/24'
var cappEnvSubnet = '10.0.2.0/23'
// var storageAccountPE = '10.0.0.1'

module vnetModule './ResourceModules/modules/network/virtual-network/main.bicep' = {
  name: '${affix}-vnet-deployment'
  params: {
    name: vnetName
    location: location
    addressPrefixes: [ '10.0.0.0/16' ]
  }
}

module cappEnvSubnetModule './ResourceModules/modules/network/virtual-network/subnet/main.bicep' = {
  name: '${affix}-capp-env-subnet-deployment'
  params: {
    name: cappEnvSubnetName
    addressPrefix: cappEnvSubnet
    virtualNetworkName: vnetModule.outputs.name
  }
  dependsOn: [ defaultSubnetModule ]
}

module defaultSubnetModule './ResourceModules/modules/network/virtual-network/subnet/main.bicep' = {
  name: '${affix}-default-subnet-deployment'
  params: {
    name: '${affix}-default-subnet'
    addressPrefix: defaultSubnet
    virtualNetworkName: vnetModule.outputs.name
  }
}

// module pdnsStorageAccModule './ResourceModules/modules/network/private-dns-zone/main.bicep' = {
//   name: '${affix}-storage-acc-pds-deployment'
//   params: {
//     name: 'privatelink.file.core.windows.net'
//     location: 'global'
//     virtualNetworkLinks: [
//       {
//         virtualNetworkResourceId: vnetModule.outputs.resourceId
//       }
//     ]
//   }
// }

resource workspaceResource 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: workspaceName
  location: location
}

// module storageModule './ResourceModules/modules/storage/storage-account/main.bicep' = {
//   name: '${affix}-storage-deployment'
//   params: {
//     name: storageName
//     location: location
//     supportsHttpsTrafficOnly: false
//     skuName: 'Premium_LRS'
//     kind: 'FileStorage'
//     fileServices: {
//       shares: [
//         // File share server data
//         {
//           enabledProtocols: 'SMB'
//           // rootSquash: 'NoRootSquash'
//           name: paperShareName
//           accessTier: 'Premium'
//         }
//       ]
//       // lock: {
//       //   kind: 'CanNotDelete'
//       //   name: 'lock-delete'
//       // }
//     }
//     privateEndpoints: [
//       {
//         name: '${affix}-pe-storage-acc'
//         service: 'file'
//         subnetResourceId: defaultSubnetModule.outputs.resourceId
//         privateDnsZoneResourceIds: [
//           pdnsStorageAccModule.outputs.resourceId
//         ]
//       }
//     ]
//   }
// }

module workspaceModule './ResourceModules/modules/operational-insights/workspace/main.bicep' = {
  name: '${workspaceName}-deployment'
  params: {
    name: workspaceName
    location: location
  }
}

// output defaultSUbnetId string = defaultSubnetModule.outputs.resourceId
