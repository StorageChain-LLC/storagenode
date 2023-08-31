#!/bin/bash



./script.sh > ./logs/script.log 2>&1 &
# tail -f script.log
sleep 10

cp ./swarm.key ./repos/ipfs/
sleep 2

./startup.sh > ./logs/cluster.log 2>&1 &
sleep 1
tail -f cluster.log
sleep 5

./start_file.sh > ./logs/fileServer.log 2>&1 &
# tail -f fileServer.log
sleep 5

# tail -f ./logs/cluster.log
