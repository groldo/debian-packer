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
  default = "sha512:9da6ae5b63a72161d0fd4480d0f090b250c4f6bf421474e4776e82eea5cb3143bf8936bf43244e438e74d581797fe87c7193bbefff19414e33932fe787b1400f"
}

variable "iso_url" {
  type    = string
  default = "https://cdimage.debian.org/cdimage/release/12.1.0/amd64/iso-cd/debian-12.1.0-amd64-netinst.iso"
}

variable "memsize" {
  type    = string
  default = "2048"
}

variable "numvcpus" {
  type    = string
  default = "1"
}

variable "username" {
  type    = string
  default = "packer"
}

variable "vm_name" {
  type    = string
  default = "debian-12-latest"
}

variable "output_directory" {
  type    = string
  default = "output"
}

source "vmware-iso" "debian" {
  boot_command     = ["<esc>auto preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"]
  boot_wait        = "${var.boot_wait}"
  disk_size        = "${var.disk_size}"
  disk_type_id     = "0"
  guest_os_type    = "debian10-64"
  headless         = false
  http_content     = {
    "/preseed.cfg"  = templatefile("${path.root}/http/preseed.cfg", {"user" = "${var.username}"})
  }
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.iso_url}"
  shutdown_command = "echo '${var.username}'|sudo -S shutdown -P now"
  ssh_username     = "${var.username}"
  ssh_password     = "${var.username}"
  ssh_port         = 22
  ssh_timeout      = "30m"
  vm_name          = "${var.vm_name}"
  memory           = "1024"
  cpus             = "1"
  vmx_data = {
    "virtualHW.version" = "14"
  }
  output_directory = "${var.output_directory}"
}

build {
  sources = ["source.vmware-iso.debian"]

  provisioner "shell" {
    execute_command = "echo '${var.username}' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/boundary_vault.sh"
  }

  provisioner "shell" {
    execute_command = "echo '${var.username}' | {{ .Vars }} sudo -S -E bash '{{ .Path }}' ${var.username}"
    script          = "scripts/docker.sh"
  }

  provisioner "shell" {
    execute_command = "echo '${var.username}' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/setup.sh"
  }
}
