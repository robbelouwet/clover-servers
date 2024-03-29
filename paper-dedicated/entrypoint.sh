#!/bin/bash

echo "JVM_ARGS: ${JVM_ARGS}"

# Set up server files if we're running for the first time
if [ ! -d "/data" ] || [ -z "$(ls -A /data)" ]; then
    echo "Setting up files!"
    
    # copy the template files
    cp -r /template-files/* /data

    echo "files copied!"
fi

cd /data

# Inject velocity secret
#yq -i '.proxies.velocity.secret = strenv(VELOCITY_SECRET)' /data/config/paper-global.yml

# remove synced .lock files
#rm -rf world*/session.lock

# Run the server
python3 /process_stdio_wrapper.py java -jar $JVM_ARGS /*.jar --nogui