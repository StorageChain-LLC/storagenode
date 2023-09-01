@echo off

:: Remove IPFS data and logs
rmdir /s /q "%userprofile%\.ipfs"
rmdir /s /q "%userprofile%\.ipfs-cluster-follow"