param appName string
param suffix string
param storageName string
param paperShareName string
param cappEnvName string

var cappStorageDefName = '${appName}-velocity-storage-def'
var cappEnvSubnetName = '${appName}-capp-env-sn-${suffix}'
var vnetName = '${appName}-vnet-${suffix}'
var workspaceName = '${appName}-workspace-${suffix}'

module networkModule 'infra.bicep' = {
  name: '${appName}-network-${suffix}-deployment'
  params: {
    appName: appName
    cappEnvSubnetName: cappEnvSubnetName
    storageName: storageName
    vnetName: vnetName
    workspaceName: workspaceName
  }
}

module appModule 'app.bicep' = {
  name: '${appName}-app-${suffix}-deployment'
  params: {
    appName: appName
    cappEnvName: cappEnvName
    cappEnvSubnetName: cappEnvSubnetName
    cappStorageDefName: cappStorageDefName
    paperShareName: paperShareName
    storageName: storageName
    suffix: suffix
    vnetName: vnetName
    workspaceName: workspaceName
  }
  dependsOn: [ networkModule ]
}
