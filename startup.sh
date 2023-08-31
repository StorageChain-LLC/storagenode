#!/bin/bash

CLUSTER_NAME="node1"
EMAIL="esha.zafar@invozone.com"
PASSWORD="Esha1234@"
NODE_ID="64f046ceeca0af32236008f6"

# export CLUSTER_PATH=./repos/cluster
# export CLUSTER_IPFSHTTP_NODEMULTIADDRESS="/dns4/node/tcp/5001"
# export CLUSTER_RESTAPI_HTTPLISTENMULTIADDRESS="/ip4/0.0.0.0/tcp/9094"
# export CLUSTER_MONITORINGINTERVAL="5s"
# export CLUSTER_PEERNAME="$CLUSTER_NAME"
# export CLUSTER_CRDT_TRUSTEDPEERS="*"
# export CLUSTER_HOST_NAME="cluster-internal.io"
# export CLUSTER_EMAIL="$EMAIL"
# export CLUSTER_PASSWORD="$PASSWORD"
# export CLUSTER_NODE_ID="$NODE_ID"

sleep 3

# export IPFS_CLUSTER_PATH=./repos/ipfs-cluster
#  ./ipfs-cluster-follow cluster_follower init http://46.101.133.110:8080/ipns/k51qzi5uqu5dlh2h4gml3k5vik5mas2zos0pyf1shnfzj9d4nsg31lw4x7ujsk 
./ipfs-cluster-follow cluster_follower run $EMAIL:$PASSWORD:$NODE_ID

# ./ipfs-cluster-follow cluster_follower run esha.zafar@invozone.com:Esha1234@:64f046ceeca0af32236008f6
