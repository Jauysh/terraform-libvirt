terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  # Configuration options
  uri = "qemu:///system"

}


resource "libvirt_domain" "terraform_test" {
  name = "terraform_test"
}