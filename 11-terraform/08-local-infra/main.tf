terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.9.0"
    }
  }
  required_version = ">= 1.0"
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "lab" {
  name = "lab-storage"
  type = "dir"

  target = {
    path = "/home/aadarkdk/Desktop/terraform-lab/pool"
  }
}
