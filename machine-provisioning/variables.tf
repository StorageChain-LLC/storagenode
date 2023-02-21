variable "number_of_vms"{
    type = strig
    default = "2"
}

variable "admin_username" {
    type = string
    default = "vagrant"
}

variable "admin_password" {
    type = string
    default = "vagrant"
}

variable "vm_network" {
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
