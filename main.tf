terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_network" "vm_network" {
  name      = "vm_network"
  mode      = "nat"
  domain    = "vm.local"
  addresses = ["192.168.123.0/24"]  # Use a different subnet
}

resource "libvirt_pool" "vm_pool" {
  name = "vm_pool"
  type = "dir"
  target {
    path = "/var/lib/libvirt/terraform-images"  # Use a different directory
  }
}

resource "libvirt_volume" "vm_disk" {
  name   = "vm_disk.qcow2"
  pool   = libvirt_pool.vm_pool.name
  format = "qcow2"
  size   = 10737418240  # 10 GB
}

resource "libvirt_domain" "vm" {
  name   = "terraform-vm"
  memory = "1024"
  vcpu   = 1

  network_interface {
    network_name = libvirt_network.vm_network.name
  }

  disk {
    volume_id = libvirt_volume.vm_disk.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}