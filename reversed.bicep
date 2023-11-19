param storageAccounts_storageeeeeeeee_name string = 'storageeeeeeeee'

resource storageAccounts_storageeeeeeeee_name_resource 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccounts_storageeeeeeeee_name
  location: 'westeurope'
  sku: {
    name: 'Premium_LRS'
    tier: 'Premium'
  }
  kind: 'FileStorage'
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Disabled'
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    largeFileSharesState: 'Enabled'
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: false
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

resource storageAccounts_storageeeeeeeee_name_default 'Microsoft.Storage/storageAccounts/fileServices@2023-01-01' = {
  parent: storageAccounts_storageeeeeeeee_name_resource
  name: 'default'
  sku: {
    name: 'Premium_LRS'
    tier: 'Premium'
  }
  properties: {
    protocolSettings: {
      smb: {
        multichannel: {
          enabled: false
        }
      }
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: false
      days: 0
    }
  }
}

resource storageAccounts_storageeeeeeeee_name_storageAccounts_storageeeeeeeee_name_7e083ffd_bcfe_4843_a68e_c3a6123bf8d6 'Microsoft.Storage/storageAccounts/privateEndpointConnections@2023-01-01' = {
  parent: storageAccounts_storageeeeeeeee_name_resource
  name: '${storageAccounts_storageeeeeeeee_name}.7e083ffd-bcfe-4843-a68e-c3a6123bf8d6'
  properties: {
    provisioningState: 'Succeeded'
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'Auto-Approved'
      actionRequired: 'None'
    }
  }
}

resource storageAccounts_storageeeeeeeee_name_default_test_share 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  parent: storageAccounts_storageeeeeeeee_name_default
  name: 'test-share'
  properties: {
    accessTier: 'Premium'
    shareQuota: 1024
    enabledProtocols: 'NFS'
    rootSquash: 'NoRootSquash'
  }
  dependsOn: [

    storageAccounts_storageeeeeeeee_name_resource
  ]
}
