#!/usr/bin/env bash

# This is a very basic script to install various tools, 
# dependecies for IPFS on Ubuntu 22.04. This can be improved to though.

# Writes the error to standard output
set -euxo pipefail

# Updating linux packages and dependencies 
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y make build-essential

# Installing Go
wget https://go.dev/dl/go1.19.6.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.19.6.linux-amd64.tar.gz
# Adding go to the PATH env
export PATH=$PATH:/usr/local/go/bin
source $HOME/.profile
go version

# Removing downloaded dir after installing 
#rm go1.19.6.linux-amd64.tar.gz
#rm -rf go1.19.6.linux-amd64

#sudo DEBIAN_FRONTEND=noninteractive apt install golang -y

# Installing IPFS 
wget https://dist.ipfs.tech/kubo/v0.18.1/kubo_v0.18.1_linux-amd64.tar.gz
tar -xvzf kubo_v0.18.1_linux-amd64.tar.gz
cd kubo && sudo bash install.sh

ipfs --version

#rm -rf kubo

# Creating private network
go install github.com/Kubuxu/go-ipfs-swarm-key-gen/ipfs-swarm-key-gen@latest

export GOPATH="$HOME/go"

# Installing IPFS cluster
git clone https://github.com/ipfs/ipfs-cluster.git $GOPATH/src/github.com/ipfs/ipfs-cluster
cd $GOPATH/src/github.com/ipfs/ipfs-cluster
make install

#ipfs-cluster-service --version
#ipfs-cluster-ctl --version

# Installing VNC as a GUI to the ubuntu
sudo apt install ubuntu-desktop -y
sudo apt install tightvncserver
sudo apt install gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal

# Installing MinIO server
wget https://dl.min.io/server/minio/release/linux-amd64/archive/minio_20230210184839.0.0_amd64.deb -O minio.deb
sudo dpkg -i minio.deb
