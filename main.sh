#!/bin/bash

# rm -rf ~/.ipfs*

export IBP2P_FORCE_PNET=1
export IPFS_LOGGING=debug
export     MONITORINGINTERVAL="5s"
export CLUSTER_IPFSHTTP_NODEMULTIADDRESS=/dns4/node/tcp/5001
export  CLUSTER_RESTAPI_HTTPLISTENMULTIADDRESS=/ip4/0.0.0.0/tcp/9094 # Expose API
export    CLUSTER_MONITORINGINTERVAL=5s
export   CLUSTER_CRDT_TRUSTEDPEERS="*" # Trust all peers in Cluster
export    CLUSTER_HOST_NAME=cluster-internal.io
# sleep 5

# ./script.sh > ./logs/script.log 2>&1 &
# # tail -f script.log
# sleep 5

# ./cluster-config.sh > ./logs/cluster-config.log 2>&1 &
# sleep 1

# ./startup.sh > ./logs/cluster.log 2>&1 &
# tail -f ./logs/cluster.log
# sleep 5

# ./start_file.sh > ./logs/fileServer.log 2>&1 &
# # tail -f fileServer.log
# sleep 5

# tail -f ./logs/cluster.log
