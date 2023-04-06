# How to start
Put your ipfs swarm.key on the root directory and run the following commands

`mkdir ipfs-node cluster`
`tee ipfs-node/swarm.key <  swarm.key`
`docker-compose up -d ipfs-node --remove-orphans`
`docker-compose up -d cluster --remove-orphans`