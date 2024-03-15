#!/bin/bash

echo "JVM_ARGS: ${JVM_ARGS}"

# Set up server files if we're running for the first time
if [ ! -d "/data" ] || [ -z "$(ls -A /data)" ]; then
    echo "Setting up files!"

    mkdir /data
    
    # pull the template server files
    GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git clone https://github.com/robbelouwet/paper-template.git /data
fi

cd /data

# Inject velocity secret
yq -i '.proxies.velocity.secret = strenv(VELOCITY_SECRET)' /data/config/paper-global.yml

# remove synced .lock files
rm -rf world*/session.lock

# Run the server
java -jar $JVM_ARGS /*.jar