#!/bin/bash

CLUSTER_NAME="storage-chain-cluster"
EMAIL="your-email-address"
PASSWORD="your-password"
NODE_ID="your-node-id"


export CLUSTER_IPFSHTTP_NODEMULTIADDRESS=/ip4/0.0.0.0/tcp/5001
export CLUSTER_RESTAPI_HTTPLISTENMULTIADDRESS=/ip4/0.0.0.0/tcp/9094
export CLUSTER_MONITORINGINTERVAL=5s
export CLUSTER_CRDT_TRUSTEDPEERS="*" 
export CLUSTER_HOST_NAME=cluster-internal.io
export CLUSTER_PEERNAME=CLUSTER_NAME


sleep 3

./ipfs-cluster-follow cluster_follower run $EMAIL:$PASSWORD:$NODE_ID

