#!/bin/bash

CLUSTER_NAME="node1"
EMAIL="maham.basharat@invozone.com"
PASSWORD="mahamali8@"
NODE_ID="64de2493367a58925b5b4482"

docker-compose  --env-file ./.env up -d

sleep 5

ipfs-cluster-follow cluster_follower init http://46.101.133.110:8080/ipns/k51qzi5uqu5dlh2h4gml3k5vik5mas2zos0pyf1shnfzj9d4nsg31lw4x7ujsk
ipfs-cluster-follow cluster_follower run $EMAIL:$PASSWORD:$NODE_ID