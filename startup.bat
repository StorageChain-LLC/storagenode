@echo off

:: Set variables
set "CLUSTER_NAME=node1"
set "EMAIL=talha.demo2@yopmail.com"
set "PASSWORD=talha123@"
set "NODE_ID=64f184d9eca0af3223600ba2"

:: Sleep for 3 seconds
timeout /t 3 > nul

:: Run the ipfs-cluster-follow command
ipfs-cluster-follow.exe cluster_follower run %EMAIL%:%PASSWORD%:%NODE_ID%
