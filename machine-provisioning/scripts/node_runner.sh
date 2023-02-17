#!/bin/bash

#NODE_IP=$(self.private_ip)

#echo $NODE_IP

sudo DEBIAN_FRONTEND=noninteractive apt -y upgrade
ipfs --version

which ipfs

cat /etc/lsb-release

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

# Enablinng port for VNC
sudo ufw allow 5901

# Copying key to the node:
ipfs-swarm-key-gen & > ~/.ipfs/swarm.key

# Initializing node
NODE_HASH=$(ipfs init)
echo $NODE_HASH

# Running MinIO server
mkdir ~/minio
minio server ~/minio --console-address :9090

# Checking for the running node
ipfs bootstrap
