#!/bin/bash -xe

# This is a very basic script to install various tools, 
# dependecies for IPFS on Ubuntu 22.04. This can be improved to though.

# Writes the error to standard output
set -euxo pipefail

# Getting shell info
printenv

# CHecking for the variables already bee setup
set

whoami
pwd 
echo $(ls -la)

# To check which shell is beinng used
echo $0

#sudo chmod 777 /var/cache/debconf/
#sudo chmod 777 /var/cache/debconf/passwords.dat
#sudo echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Updating linux packages and dependencies
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y -qq > /dev/null
sudo apt-get upgrade -y -qq > /dev/null
sudo apt install net-tools -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y make build-essential
#usermod -aG sudo $(whoami)

# Installing Go
wget https://go.dev/dl/go1.19.6.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.19.6.linux-amd64.tar.gz

USER=$LOGGEDINUSER

# Adding PATHS for go executeables to the PATH env system-wide
#sudo echo 'export GOPATH=$HOME/go' >> /home/vagrant/.bash_profile
#source /home/vagrant/.bash_profile

sudo echo 'export GOPATH=$HOME/go' >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc

#sudo echo 'export PATH=$PATH:$GOPATH/bin' >> /home/vagrant/.bash_profile
#source /home/vagrant/.bash_profile

sudo echo 'export PATH=$PATH:$GOPATH/bin' >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc

#echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/vagrant/.bash_profile
#source /home/vagrant/.bash_profile

echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc

sudo echo 'export GOPATH=$HOME/go' >> /home/vagrant/.profile
source /home/vagrant/.profile

sudo echo 'export PATH=$PATH:$GOPATH/bin' >> /home/vagrant/.profile
source /home/vagrant/.profile

echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/vagrant/.profile
source /home/vagrant/.profile

cat /home/vagrant/.profile
go version
which go

# Removing downloaded dir after installing 
#rm go1.19.6.linux-amd64.tar.gz
#rm -rf go1.19.6.linux-amd64

# Setting up the GO workspace and system path
#sudo echo 'export GOPATH=$HOME/go' > /etc/profile.d/system_path_setter.sh
#sudo echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' > /etc/profile.d/system_path_setter.sh

# Installing IPFS cluster
git clone https://github.com/ipfs-cluster/ipfs-cluster.git $GOPATH/src/github.com/ipfs/ipfs-cluster
cd $GOPATH/src/github.com/ipfs/ipfs-cluster
make install

ipfs-cluster-service --version
ipfs-cluster-ctl --version

# Installing IPFS 
wget https://dist.ipfs.tech/kubo/v0.18.1/kubo_v0.18.1_linux-amd64.tar.gz
tar -xvzf kubo_v0.18.1_linux-amd64.tar.gz
sudo bash kubo/install.sh
ipfs --version
