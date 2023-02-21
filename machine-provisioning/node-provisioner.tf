terraform {
  required_providers {
    virtualbox = {
      source = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

# There are currently no configuration options for the provider itself.
# It will spinup two VMs with ipfs node connfigured.
resource "virtualbox_vm" "node" {
  count     = length(var.number_of_vms)
  name      = format("node-%02d", count.index + 1)
  image     = "../machine-img-build/output_dir/chain-node/package.box"
  cpus      = "${var.cpu}"
  memory    = "${var.memory}"


  connection {
    host     = virtualbox_vm.node.0.network_adapter.0.ipv4_address
    type     = "ssh"
    user     = "${var.admin_username}"
    password = "${var.admin_password}"
    agent    = "false"
    #We will provide our own to the image, this is just for testing
    private_key = file("./vagrant")
  }

  provisioner "file" {
    source      = "./scripts"
    destination = "/tmp"
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/scripts/node_runner.sh",
      "/tmp/scripts/node_runner.sh",
      "chmod +x /tmp/scripts/minio-installation-and-configuration.sh",
      "/tmp/scripts/minio-installation-and-configuration.sh ${var.admin_username}",
    ]
  }
  
  network_adapter {
    type = "${var.vm_network}"
    host_interface="en0"
  }
}

output "IPAddr" {
  value = element(virtualbox_vm.node.*.network_adapter.0.ipv4_address, 1)
}

output "IPAddr_2" {
  value = element(virtualbox_vm.node.*.network_adapter.0.ipv4_address, 2)
}
