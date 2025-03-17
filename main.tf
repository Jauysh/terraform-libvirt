terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"  # or specify the connection string to your libvirt host
}

# Use the existing default storage pool
data "libvirt_pool" "default" {
  name = "default"
}

# Create a volume from an existing QCOW2 image
resource "libvirt_volume" "ubuntu-qcow2" {
  name   = "ubuntu-22.04.qcow2"
  pool   = data.libvirt_pool.default.name
  source = "/var/lib/libvirt/images/ubuntu-22.04.qcow2"
  format = "qcow2"
}

# Define the virtual machine
resource "libvirt_domain" "ubuntu_vm" {
  name   = "ubuntu-vm"
  memory = 2048    # 2GB RAM
  vcpu   = 2       # 2 vCPUs

  disk {
    volume_id = libvirt_volume.ubuntu-qcow2.id
  }

  network_interface {
    network_name = "default"
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "vnc"
    listen_type = "address"
    autoport = true
  }
}
