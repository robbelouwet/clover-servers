using 'main.bicep'

var env = 'dev'

param appName = 'paper'
var escapedAppName = 'paper'

param suffix = '${env}-01'
var escapedSuffix = '${env}01'

param storageName = '${escapedAppName}storage${escapedSuffix}'
param paperShareName = '${appName}-st-share-${suffix}'
param cappEnvName = '${appName}-capp-env-${suffix}'
