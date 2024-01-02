#!/bin/bash

echo "JVM_ARGS: ${JVM_ARGS}"

# Set up server files if we're running for the first time
if [ -z "$(ls -A /data)" ]; then    
    echo "Setting up files!"

    mkdir /data
    
    # Pull the template server files
    GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git clone https://github.com/robbelouwet/velocity-template.git /data
fi

cd /data

# Inject hostnames of backed server instances
perl -i -pe 's/(paper1\s*=\s*")[^"]*(")/\1$ENV{"PAPER1_HOST"}\2/' /data/velocity.toml
perl -i -pe 's/(paper2\s*=\s*")[^"]*(")/\1$ENV{"PAPER2_HOST"}\2/' /data/velocity.toml

# Inject velocity secret
echo "$VELOCITY_SECRET" > /data/forwarding.secret

# Run the server
java $JVM_ARGS -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 -jar /velocity*.jar