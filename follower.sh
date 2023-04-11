# echo "hosts: files dns" > /etc/nsswitch.conf
ipfs-cluster-follow cluster_follower init http://46.101.179.114:8080/ipfs/QmNj7guXKAo67nZwE6XtyfhgDnXsdpa8Xte3MVH7TjaUoM
ipfs-cluster-ctl --host /unix//root/.ipfs-cluster-follow/cluster_follower/api-socket
ipfs-cluster-follow cluster_follower run