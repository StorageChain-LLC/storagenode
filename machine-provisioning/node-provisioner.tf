terraform {
  required_providers {
    virtualbox = {
      source = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

# There are currently no configuration options for the provider itself.

resource "virtualbox_vm" "node" {
  count     = "${var.number_of_vms}"
  name      = format("node-%02d", count.index + 1)
  image     = "../machine-img-build/output_dir/chain-node/package.box"
  cpus      = "${var.cpu}"
  memory    = "${var.memory}"


  connection {
    host     = virtualbox_vm.node.0.network_adapter.0.ipv4_address
    type     = "ssh"
    user     = "${var.host_admin_username}"
    password = "${var.host_admin_password}"
    agent    = "false"
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
      "/tmp/scripts/minio-installation-and-configuration.sh ${var.host_admin_password} ${var.host_admin_username} ${var.minio_admin_user} ${var.minio_admin_pass}",
    ]
  }

  network_adapter {
    type = "${var.vm_network}"
    host_interface = "${var.host_interface}"
  }
}

output "IPAddr" {
  value = element(virtualbox_vm.node.*.network_adapter.0.ipv4_address, 1)
}

output "IPAddr_2" {
  value = element(virtualbox_vm.node.*.network_adapter.0.ipv4_address, 2)
}