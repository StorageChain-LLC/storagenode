packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

variable "out_dir" {
    type = string
    default = "output_dir"
}

variable "name" {
    type = string
    default = "chain-node"
}

variable "user_to_login_with" {
    type = string
    default = "vagrant"
}

source "vagrant" "localhost-node" {
  communicator = "ssh"
  source_path  = "generic/ubuntu2204"
  provider     = "virtualbox"
  add_force    = true
  box_name = "generic/ubuntu2204"
  output_dir   = "${var.out_dir}/${var.name}"
  skip_add     = true
}

build {
    name = "localhost-node-provisioning"
    sources = ["source.vagrant.localhost-node"]

    provisioner "shell" {
        environment_vars = ["LOGGEDINUSER=${var.user_to_login_with}"]
        scripts = [
            "scripts/node_env_setup.sh",
        ]
    }
}