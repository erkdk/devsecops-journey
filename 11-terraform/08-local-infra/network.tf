resource "libvirt_network" "lab_network" {
  name      = "lab-network"
  autostart = true

  forward = {
    mode = "nat"
  }

  ips = [{
    address = "10.10.10.1"
    prefix  = "24"
    dhcp = {
      ranges = [{
        start = "10.10.10.80"
        end   = "10.10.10.100"
      }]
    }
  }]

  domain = {
    name = "mylab.local"
  }
}
