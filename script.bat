@echo off

:: Set IPFS_PATH environment variable
set IPFS_PATH=%userprofile%\.ipfs

:: Create the .ipfs directory
mkdir %IPFS_PATH%

:: Copy swarm.key to the .ipfs directory
copy swarm.key %IPFS_PATH%

:: Initialize IPFS with the "server" profile
ipfs init --profile=server

:: Remove all bootstrap peers
ipfs bootstrap rm --all

:: Configure IPFS API address
ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001

:: Configure IPFS Gateway address
ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080

:: Configure Access-Control-Allow-Origin header
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]'

:: Configure Access-Control-Allow-Methods header
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "POST"]'

:: Add a bootstrap peer
ipfs bootstrap add /ip4/46.101.133.110/tcp/4001/p2p/12D3KooWQ74Dh8sYH8SkJGMTynbwzUfnPs6mgdPqXnZRuLsW1dfy

:: Start the IPFS daemon
ipfs daemon
