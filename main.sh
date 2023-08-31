#!/bin/bash

rm -rf ~/.ipfs*
sleep 5

./script.sh > ./logs/script.log 2>&1 &
# tail -f script.log
sleep 5

./cluster-config.sh > ./logs/cluster-config.log 2>&1 &
sleep 1

./startup.sh > ./logs/cluster.log 2>&1 &
tail -f ./logs/cluster.log
sleep 5

# ./start_file.sh > ./logs/fileServer.log 2>&1 &
# # tail -f fileServer.log
# sleep 5

# tail -f ./logs/cluster.log
