using 'main.bicep'

var env = 'dev'

param appName = 'paper-auto'
var escapedAppName = 'paperauto'

param suffix = '${env}-01'
var escapedSuffix = '${env}01'

param storageName = '${escapedAppName}storage${escapedSuffix}'
param paperShareName = '${appName}-st-share-${suffix}'
param cappEnvName = '${appName}-capp-env-${suffix}'
