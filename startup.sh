#!/bin/bash

CLUSTER_NAME="node1"
EMAIL="esha.zafar@invozone.com"
PASSWORD="Esha1234@"
NODE_ID="64f046ceeca0af32236008f6"

sleep 3

./ipfs-cluster-follow cluster_follower init http://46.101.133.110:8080/ipns/k51qzi5uqu5dlh2h4gml3k5vik5mas2zos0pyf1shnfzj9d4nsg31lw4x7ujsk
./ipfs-cluster-follow cluster_follower run $EMAIL:$PASSWORD:$NODE_ID
