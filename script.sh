ipfs init --profile server
ipfs bootstrap rm --all
ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001
ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]'
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "POST"]'
ipfs bootstrap add /ip4/46.101.179.114/tcp/4001/p2p/12D3KooWQcT1db4e1XiWc2HqvCwrMeTANr3QeQquynJ3WHTB4ucV
ipfs daemon