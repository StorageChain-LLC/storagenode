#!/bin/bash
export LOGGEDIN_USER=${whoami}


sudo -i
usermod -aG sudo $1
# Creating Linux system group the MinIO daemonn will run as
groupadd -r minio-user

# Adding Linux system user the MinIO will run as
# Prevented the home directory creation this is a service
# Added to the MioIO systtem group
useradd -M -r -g minio-user minio-user

# Exiting from root
exit

pwd 

# Logging in as the deployer minio-user
su minio-user
whoami
mkdir -p /home/minio-user/.minio/certs
exit

# Creating directory where we are goinng to keep our MinIO ata
if [[ ! -d "/mnt/data"]]
then
mkdir /mnt/data
chown minio-user:minio-user /mnt/data
fi



# Installing MinIO server and configuring with SystemD manually
# Fetching MinIO binary from upstream
wget https://dl.min.io/server/minio/release/linux-amd64/minio
chmod +x minio
mv minio /usr/local/bin/

# Creatinng SystemD service file MinIO at runtime
if [[ ! -f "/etc/systemd/system/minio.service" ]]
then
sudo echo '[Unit]
Description=MinIO
Documentation=https://docs.min.io
Wants=network-online.target
After=network-online.target
AssertFileIsExecutable=/usr/local/bin/minio

[Service]
WorkingDirectory=/usr/local

User=minio-user
Group=minio-user
ProtectProc=invisible

EnvironmentFile=-/etc/default/minio
ExecStartPre=/bin/bash -c "if [ -z \"${MINIO_VOLUMES}\" ]; then echo \"Variable MINIO_VOLUMES not set in /etc/default/minio\"; exit 1; fi"
ExecStart=/usr/local/bin/minio server $MINIO_OPTS $MINIO_VOLUMES

# Let systemd restart this service always
Restart=always

# Specifies the maximum file descriptor number that can be opened by this process
LimitNOFILE=65536

# Specifies the maximum number of threads this process can create
TasksMax=infinity

# Disable timeout logic and wait until process is stopped
TimeoutStopSec=infinity
SendSIGKILL=no

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/minio.service
fi

#echo 'export PATH=$PATH:/usr/local/bin/minio' >> $HOME/.profile
#source $HOME/.profile

# Updating the environment service file
if [[ ! -f "/etc/default/minio" ]]
then
echo '# Set the hosts and volumes MinIO uses at startup

# The command uses MinIO expansion notation {x...y} to denote a

# sequential series.

#

# The following example covers four MinIO hosts

# with 4 drives each at the specified hostname and drive locations.

# The command includes the port that each MinIO server listens on

# (default 9000)


MINIO_VOLUMES="https://minio1.example.com:9000/mnt/data/disk{1...4}/minio"


# Set all MinIO server options

#

# The following explicitly sets the MinIO Console listen address to

# port 9001 on all network interfaces. The default behavior is dynamic

# port selection.


MINIO_OPTS="--console-address :9001"


# Set the root username. This user has unrestricted permissions to

# perform S3 and administrative API operations on any resource in the

# deployment.

#

# Defer to your organizations requirements for superadmin user name.


MINIO_ROOT_USER=minioadmin


# Set the root password

#

# Use a long, random, unique string that meets your organizations

# requirements for passwords.


MINIO_ROOT_PASSWORD=minioadmin


# Set to the URL of the load balancer for the MinIO deployment

# This value *must* match across all MinIO servers. If you do

# not have a load balancer, set this value to to any *one* of the

# MinIO hosts in the deployment as a temporary measure.

MINIO_SERVER_URL="http://127.0.0.1:9000"' > /etc/default/minio
fi

# Chaning ownership to minio-user
chown minio-user:minio-user /etc/default/minio

# Opening ports for MinIO service
sudo ufw allow 9090
sudo ufw allow 9000
sudo ufw allow 9001

# Enabling  and starting the earlier defiend service
systemctl enable minio.service
systemctl start minio.service

#Installing MinIO client
curl https://dl.min.io/client/mc/release/linux-amd64/mc \
  --create-dirs \
  -o $HOME/minio-binaries/mc

chmod +x $HOME/minio-binaries/mc
mc --version

# Creating MinIO alias for local deployment
mc alias set local http://127.0.0.1:9000 minioadmin minioadmin
# Testing connenction
mc admin info local
