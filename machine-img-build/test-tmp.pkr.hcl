variable "build_directory" {
    default = "./build"
}

variable "boot_wait" {
    default = "10s"
}

variable "cpus" {
    default = 1
}

variable "disk_size" {
    default = 50000
}

variable "headless" {
    default = false
}

variable "http_directory" {
    default = "./http"
}

variable "iso_url" {
    type = string
}

variable "iso_checksum" {
    type = string
}

variable "kickstart_file" {
    type = string
}

variable "memory" {
    default = 1024
}

variable "template" {
    type = string
}

variable "username" {
    default = "vagrant"
}

variable "vm_name" {
    type = string
}

variable "provider_name" {
    default = "virtualbox"
}

variable "ssh_timeout" {
    default = "45m"
}

source "virtualbox-iso" "localhost-node" {

    boot_command = [
        "<up><tab><wait>",
        " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.kickstart_file}<enter>",
    ]

    boot_wait            = var.boot_wait
    cpus                 = var.cpus
    disk_size            = var.disk_size
    guest_os_type        = "ubuntu_2204"
    hard_drive_interface = "sata"
    headless             = var.headless
    http_directory       = var.http_directory
    iso_url              = var.iso_url
    iso_checksum         = var.iso_checksum
    memory               = var.memory
    output_directory     = "${var.build_directory}/packer-${var.template}-${var.provider_name}"
    shutdown_command     = "echo '${var.username}' | sudo -S shutdown -P now"
    ssh_timeout          = var.ssh_timeout
    ssh_username         = var.username
    ssh_password         = var.username
    vm_name              = var.vm_name
}

build {
    sources = ["sources.virtualbox-iso.fedora_server"]
}
