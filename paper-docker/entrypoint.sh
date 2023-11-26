#!/bin/bash

cd /data
echo "JVM_ARGS: ${JVM_ARGS}"

# Set up server files if we're running for the first time
if [ -z "$(ls -A /data)" ]; then
    echo "Setting up files!"
    
    # pull the template server files
    GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git clone https://github.com/robbelouwet/paper-template.git /data
fi

# Inject velocity secret
yq -i '.proxies.velocity.secret = strenv(VELOCITY_SECRET)' /data/config/paper-global.yml

# Run the server
java -jar $JVM_ARGS /*.jar