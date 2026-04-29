resource "libvirt_volume" "base_image" {
  name     = "ubuntu-noble"
  pool     = libvirt_pool.lab.name
  capacity = 3758096384

  target = {
    format = {
      type = "qcow2"
    }
  }

  backing_store = {
    path = "/var/lib/libvirt/images/noble-server-cloudimg-amd64.img"
    format = {
      type = "qcow2"
    }
  }
}
