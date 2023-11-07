#!/bin/bash
export CLUSTER_IPFSHTTP_NODEMULTIADDRESS=/dns4/node/tcp/5001
export CLUSTER_RESTAPI_HTTPLISTENMULTIADDRESS=/ip4/0.0.0.0/tcp/9094
export CLUSTER_MONITORINGINTERVAL=5s
export CLUSTER_CRDT_TRUSTEDPEERS="*" 
export CLUSTER_HOST_NAME=cluster-internal.io
export CLUSTER_PEERNAME=CLUSTER_NAME

 ./ipfs-cluster-follow cluster_follower init http://46.101.133.110:8080/ipns/k51qzi5uqu5dlh2h4gml3k5vik5mas2zos0pyf1shnfzj9d4nsg31lw4x7ujsk 