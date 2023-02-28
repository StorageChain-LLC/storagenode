### We will be using Packer to build machine image (Vagrant box) that will provide a fully configured runtime environment for VM to be run on local vitualbox.

#### Pre-requisites
Install these tools on a host machine to be used to build machine images/vagrant bixes
`Packer`  (1.8.3)
`Vagrant` (2.3.4)


#### Base Box
`generic/ubuntu2204` is being used as a base (source)box. 

I have written Packer template in HCL to use `Vagrant` builder for Packer to use `generic/ubuntu2204` as a source box and spin up a VM on `virtualbox` to install further tools/utilities/softwares on it through shell script and then package it as a box and output it in a described directory. That packaged box will be used later to spin-up the actual virtual machine on `Virtualbox` with a complete IPFS node installation and configuration.


### Build Steps

To initiate the directory and to install the required plugins, move to the directory contains the packer template ad run:

`packer init -upgrade`

Once plugins installed we can start the build process by running:

`packer build {TEMPLATE-NAME without braces}`
