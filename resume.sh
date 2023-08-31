

./ipfs daemon &
sleep 5
rm -rf ~/.ipfs-cluster-follow/*
sleep 1
./cluster-config.sh > ./logs/cluster-config.log 2>&1 &
sleep 2
./startup.sh > ./logs/cluster.log 2>&1 &
tail -f ./logs/cluster.log