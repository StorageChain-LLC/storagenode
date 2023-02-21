#!/bin/bash

#sudo -k -S usermod -aG sudo ${USER}

# Creating Linux system group the MinIO daemonn will run as
#echo $1 | sudo -S groupadd -r minio-user

# Adding Linux system user the MinIO will run as
# Prevented the home directory creation this is a service
# Added to the MioIO systtem group
#echo $1 | sudo -S useradd -M -r -g minio-user minio-user

# Logging in as the deployer minio-user
#su minio-user
#whoami
#mkdir -p /home/minio-user/.minio/certs
#exit

echo "Pass: $1"
echo "User: $2"
echo "MinIO_User: $3"
echo "MinIO_Pass: $4"
VM_PUBLIC_IP=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com)
echo "ip for vm: $VM_PUBLIC_IP"

MOUNT_DIR="/mnt/data"
# Creating directory where we are going to keep our MinIO ata
if [ ! -d "$MOUNT_DIR" ]; then
sudo mkdir $MOUNT_DIR
sudo chown $2:$2 /mnt/data
#chown minio-user:minio-user /mnt/data
fi

# Installing MinIO server and configuring with SystemD manually
# Fetching MinIO binary from upstream
wget https://dl.min.io/server/minio/release/linux-amd64/minio
chmod +x minio
sudo mv minio /usr/local/bin/

minio --version

# Setting up paths for systemd dir and local service configuration script 
MINIO_SYSTEMD_FILE_ON_NODE="/etc/systemd/system/minio.service"

# Creatinng SystemD service file MinIO at runtime
if [[ ! -f "$MINIO_SYSTEMD_FILE_ON_NODE" ]]; then
sudo cp /tmp/scripts/minio-resource-config/minio.service /etc/systemd/system/
fi

#echo 'export PATH=$PATH:/usr/local/bin/minio' >> $HOME/.profile
#source $HOME/.profile

MINIO_ENV_SVC_FILE_LOC="/etc/default/minio"
# Updating the environment service file
if [[ ! -f "$MINIO_ENV_SVC_FILE_LOC" ]]; then
sudo cp /tmp/scripts/minio-resource-config/minio /etc/default/
fi

# Chaning ownership to minio-user
#chown minio-user:minio-user /etc/default/minio

# Opening ports for MinIO service
sudo ufw allow 9090
sudo ufw allow 9000
sudo ufw allow 9001

# Enabling and starting the earlier defiend service
sudo systemctl enable minio.service
sudo systemctl start minio.service

#Installing MinIO client
curl https://dl.min.io/client/mc/release/linux-amd64/mc \
  --create-dirs \
  -o $HOME/minio-binaries/mc

chmod +x $HOME/minio-binaries/mc
echo 'export PATH=$PATH:$HOME/minio-binaries/' >> $HOME/.profile
source $HOME/.profile

mc --version

# Creating MinIO alias for local deployment
mc alias set local http://127.0.0.1:9000 $3 $4
# Testing connenction
mc admin info local