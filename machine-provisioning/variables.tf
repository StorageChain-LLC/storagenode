variable "number_of_vms" {
    type = string
    default = "2"
}
variable "host_admin_username" {
    type = string
    default = "vagrant"
}

variable "host_admin_password" {
    type = string
    default = "vagrant"
}

variable "vm_network_type" {
    type = string
    default = "bridged"
}

variable "cpu" {
    type = string
    default = "2"
}

variable "memory" {
    type = string
    default = "3 gb"
}

variable "minio_admin_user" {
    type = string
    default = "minioadmin"
}

variable "minio_admin_pass" {
    type = string
    default = "minioadmin"
}

variable "host_interface" {
    type = string
    default = "en0"
}