#!/bin/bash

# rm -rf ~/.ipfs*
pm2 flush all
sleep 2
echo "starting ipfs"
./ipfs init --profile server
# tail -f script.log
sleep 5
echo "cluster configuration"
./cluster-config.sh 2>&1 &
sleep 5
echo "sarting cluster"
pm2 start ./service-runner.json
# tail -f ./logs/cluster.log
