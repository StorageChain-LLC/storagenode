# echo "hosts: files dns" > /etc/nsswitch.conf
ipfs-cluster-follow cluster_follower init http://46.101.179.114:8080/ipfs/QmTUxPJSSmkFzVHZj9GvWzaKSmAZ5i3Eye5sWY77vqMkJv
ipfs-cluster-ctl --host /unix//root/.ipfs-cluster-follow/cluster_follower/api-socket
ipfs-cluster-follow cluster_follower run