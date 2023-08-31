# How to start
## PORTS to forward
 - 4001
 - 5001
 - 8080
 - 9094
 - 9095
 - 9096
 - 3008
## Create a .env file in the folder you wish to keep the storage items
see .env.example and set the variables

 ## Install Docker
 https://docs.docker.com/engine/install/

## Run the following command from docker

npm install --legacy-peer-deps

docker-compose  --env-file ./.env up -d


export IPFS_PATH=./repos/ipfs
export CLUSTER_PATH=./repos/cluster/data
export IPFS_CLUSTER_PATH=./repos/ipfs-cluster
export IPFS_CLUSTER_MONITOR_PATH=./repos/monitor
export IPFS_CLUSTER_LOG_PATH=./repos/logs
export IPFS_CLUSTER_CFG_PATH=./repos/cfg
export IBP2P_FORCE_PNET=1
export IPFS_LOGGING=debug
export MONITORINGINTERVAL="5s"


export CLUSTER_IPFSHTTP_NODEMULTIADDRESS= '/dns4/node/tcp/5001'
export CLUSTER_RESTAPI_HTTPLISTENMULTIADDRESS= '/ip4/0.0.0.0/tcp/9094' 
export CLUSTER_MONITORINGINTERVAL= "5s"
export CLUSTER_PEERNAME= $CLUSTER_NAME
export CLUSTER_CRDT_TRUSTEDPEERS= "*"
export CLUSTER_HOST_NAME= 'cluster-internal.io'
export CLUSTER_EMAIL= $EMAIL
export CLUSTER_PASSWORD= $PASSWORD
export CLUSTER_NODE_ID= $NODE_ID