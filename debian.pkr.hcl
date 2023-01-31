
variable "boot_wait" {
  type    = string
  default = "5s"
}

variable "disk_size" {
  type    = string
  default = "40960"
}

variable "iso_checksum" {
  type    = string
  default = "e482910626b30f9a7de9b0cc142c3d4a079fbfa96110083be1d0b473671ce08d"
}

variable "iso_url" {
  type    = string
  default = "https://cdimage.debian.org/cdimage/release/11.6.0/amd64/iso-cd/debian-11.6.0-amd64-netinst.iso"
}

variable "memsize" {
  type    = string
  default = "1024"
}

variable "numvcpus" {
  type    = string
  default = "1"
}

variable "ssh_password" {
  type    = string
  default = "packer"
}

variable "ssh_username" {
  type    = string
  default = "packer"
}

variable "vm_name" {
  type    = string
  default = "debian-11.0.0-amd64"
}

source "vmware-iso" "debian11" {
  boot_command     = ["<esc>auto preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"]
  boot_wait        = "${var.boot_wait}"
  disk_size        = "${var.disk_size}"
  disk_type_id     = "0"
  guest_os_type    = "debian10-64"
  headless         = false
  http_directory   = "http"
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.iso_url}"
  shutdown_command = "echo 'packer'|sudo -S shutdown -P now"
  ssh_password     = "${var.ssh_password}"
  ssh_port         = 22
  ssh_timeout      = "30m"
  ssh_username     = "${var.ssh_username}"
  vm_name          = "${var.vm_name}"
  vmx_data = {
    memsize             = "${var.memsize}"
    numvcpus            = "${var.numvcpus}"
    "virtualHW.version" = "14"
  }
}

build {
  sources = ["source.vmware-iso.debian11"]
}
