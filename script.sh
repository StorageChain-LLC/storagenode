curl -O https://dist.ipfs.tech/kubo/v0.19.0/kubo_v0.19.0_darwin-arm64.tar.gz
ls -la
tar -xvzf kubo_v0.19.0_darwin-arm64.tar.gz
cd kubo
bash install.sh
ipfs --version
ipfs init --profile server
ipfs bootstrap rm all
export LIBP2P_FORCE_PNET=1
ipfs bootstrap add /ip4/46.101.133.110/tcp/4001/p2p/12D3KooWQ74Dh8sYH8SkJGMTynbwzUfnPs6mgdPqXnZRuLsW1dfy
rm -rf ~/.ipfs/swarm.key
echo '/key/swarm/psk/1.0.0/' >> ~/.ipfs/swarm.key
echo '/base16/' >> ~/.ipfs/swarm.key
echo 'fdce9ceb8b991ff1005ee6bb1975f2a134f6cdbd554f90e58a8df07b7e9cfc37' >> ~/.ipfs/swarm.key
ipfs daemon