#!/bin/bash

#NODE_IP=$(self.private_ip)

#echo $NODE_IP

sudo DEBIAN_FRONTEND=noninteractive apt -y upgrade
ipfs --version

which ipfs

cat /etc/lsb-release

echo 'export GOPATH=$HOME/go' >> $HOME/.profile
source $HOME/.profile

echo 'export PATH=$PATH:$GOPATH/bin:/usr/local/bin/minio:$HOME/minio-binaries/' >> $HOME/.profile
source $HOME/.profile

# Installing IPFS cluster
git clone https://github.com/ipfs-cluster/ipfs-cluster.git $GOPATH/src/github.com/ipfs/ipfs-cluster
cd $GOPATH/src/github.com/ipfs/ipfs-cluster
make install

ipfs-cluster-service --version
ipfs-cluster-ctl --version

# Installing swarm key generator
go install github.com/Kubuxu/go-ipfs-swarm-key-gen/ipfs-swarm-key-gen@latest

# Initializing node
NODE_HASH=$(ipfs init)
echo $NODE_HASH

which ipfs-swarm-key-gen
# Copying key to the node:
ipfs-swarm-key-gen & > ~/.ipfs/swarm.key

# Enablinng ports for VNC and MinIO server
sudo ufw allow 5901

# Checking for the running node
ipfs bootstrap

# Installing GUI
sudo apt update
sudo apt install ubuntu-desktop
sudo apt install tightvncserver
sudo apt install gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal

# Starting VNC server
vncserver :1

echo "#!/bin/sh

export XKL_XMODMAP_DISABLE=1
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey

vncconfig -iconic &
gnome-panel &
gnome-settings-daemon &
metacity &
nautilus &
gnome-terminal &" > ~/.vnc/xstartup

# Killing existing server
vncserver -kill :1

# Reinitializing the server
vncserver :1