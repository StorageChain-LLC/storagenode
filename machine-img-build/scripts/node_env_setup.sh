#!/bin/bash

# This is a very basic script to install various tools, 
# dependecies for IPFS on Ubuntu 22.04. This can be improved to though.

# Writes the error to standard output
set -euxo pipefail

# Updating linux packages and dependencies
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y build-essential make
sudo apt install net-tools -y

# Installing Go
wget https://go.dev/dl/go1.19.6.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.19.6.linux-amd64.tar.gz

# Adding PATHS for go executeables to the PATH env system-wide
echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.profile
source $HOME/.profile
go version
which go

# Removing downloaded dir after installing 
#rm go1.19.6.linux-amd64.tar.gz
#rm -rf go1.19.6.linux-amd64

# Installing IPFS 
wget https://dist.ipfs.tech/kubo/v0.18.1/kubo_v0.18.1_linux-amd64.tar.gz
tar -xvzf kubo_v0.18.1_linux-amd64.tar.gz
sudo bash kubo/install.sh
ipfs --version
