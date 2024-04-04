#!/bin/bash

ram=$(free --mega | grep "Mem" | awk '{print $2}')

# trick to do rounded floating point arithmetic in bash
minRAM=$(printf %.f $(echo $ram*0.05 | bc))
maxRAM=$(printf %.f $(echo $ram*0.95 | bc))

echo "available/min/max RAM (MB): ${ram} / ${minRAM} (5%) / ${maxRAM} (95%)"

# Set up server files if we're running for the first time
if [ ! -d "/data" ] || [ -z "$(ls -A /data)" ]; then
    echo "Setting up files!"
    
    # copy the template files
    cp -r /template-files/* /data

    echo "files copied!"
fi

cd /data

# Inject velocity secret
yq -i '.proxies.velocity.secret = strenv(VELOCITY_SECRET)' /data/config/paper-global.yml

# remove synced .lock files
rm -rf world*/session.lock

# Run the server
python3 /process_stdio_wrapper.py java -jar -Xms${minRAM}M -Xmx${maxRAM}M /*.jar --nogui