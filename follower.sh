echo "hosts: files dns" > /etc/nsswitch.conf
ipfs-cluster-follow cluster_follower init https://gist.githubusercontent.com/isheraz/cd68033ae37b6bf03578496442647a3b/raw/70e1ba54c0ce0fd838958c85d9cb794cb207d84d/follower.json
# ipfs-cluster-ctl --host /unix//root/.ipfs-cluster-follow/cluster_follower/api-socket
ipfs-cluster-follow cluster_follower run