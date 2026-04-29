# Provisioning a Local Virtualization Infrastructure with Terraform and libvirt

### Overview:
I provisioned a local virtualization infrastructure using Terraform and libvirt.
The outcome is a functional foundation consisting of a virtual network, a storage pool,
and a base operating system volume - all defined as code and reproducible on any compatible Linux host.

#### What I build:
1. A NAT-based virtual network with DHCP and DNS
2. A directory-backed storage pool for VM disk images
3. A QCOW2 (QEMU Copy On Write version 2) volume backed by an Ubuntu 24.04 cloud image

### Understanding Underlying  Components:
1. KVM (Kernel-based Virtual Machine)
KVM is a Linux kernel module that turns operating machine into a hypervisor. It loads via kvm.ko or any
architecture-specific modules (eg. ```kvm-intel.ko```). Once loaded, it exposes ```/dev/kvm```, which userspace programs use to create and run virtual machines with hardware acceleration.
Each VM appears as a normal process on the host as shown below:
```hcl
aadarkdk@pop-os:~$ ps aux | grep qemu
aadarkdk  101685  0.0  0.0  18892  2684 pts/0    S+   10:58   0:00 grep --color=auto qemu
aadarkdk@pop-os:~$ 
```
![How these components work together](https://github.com/erkdk/devsecops-journey/blob/main/11-terraform/08-local-infra/screenshots/qemu.png)


2. QEMU ( Quick Emulator)
QEMU is the userspace program that creates the virtual hardware environment. It emulates disk 
controllers, network cards, and other devices. When KVM is available, QEMU uses it for CPU execution while handling I/O in userspace.

We rarely invoke QEMU directly because libvirt generates the appropriate QEMU command lines
based on configuration.

3. libvirt
libvirt is a management daemon and API that abstracts hypervisor operations. It provides:
- ``` libvirtd ``` ( The background service)
- ``` virsh ``` ( Command-line management tool )
- XML-based definitions for domains (VMs), networks, and storage

The connection URI ``` qemu:///system ``` connects to the privileged system daemon.

4. Terraform libvirt Provider
The ``` dmacvicar/libvirt``` provider translates HCL configuration files into libvirt API calls. 
Version 0.9.x maps resources directly to libvirt XML elements.

How these components work together?
![How these components work together](https://github.com/erkdk/devsecops-journey/blob/main/11-terraform/08-local-infra/screenshots/how_these_work.png)


### Why Terraform for Local Infrastructure ?
  When we follow the imperative approach ( without terraform ), managing libvirt manually requires
  sequential commands such as:
  ```hcl
  virsh net-define network.xml
  virsh net-start lab-network
  virsh pool-define-as lab-storage dir --target /path
  virsh pool-start lab-storage
  ```
This has several drawbacks like:
- Commands must be executed in correct order
- No preview of changes before execution
- Configuration is not self-documenting
- Reproducing the setup on another machine requires repeating all steps

### The Declarative Approach ( With Terraform )
Terraform lets us describe the desired state in configuration files, like:
```hcl

resource "libvirt_network" "mylab_network" {

  name = "mylab-network"
  
  # desired properties declared here
}
```
Then a single command handles everything.

```
terraform apply
```
Terraform determines the correct creation order, shows a preview of changes before applying them,
and maintains a state file that tracks what exists. The configuration files serve as both documentation and executable specification. Easily reproducible in future.


Prerequisites and Initial Setup

1. Install the virtualization stack as per your device.
Most Linux distros already have KVM kernel modules and userspace tools available through their packaging systems. If you want to use specific versions of KVM kernel modules and supporting userspace, you can download the latest version by visiting.
[Downloads here](https://www.linux-kvm.org/page/Downloads)

2. Install Terraform: [link](https://developer.hashicorp.com/terraform/install)

3. Verify:
```hcl
aadarkdk@pop-os:~$ kvm-ok
INFO: /dev/kvm exists
KVM acceleration can be used

aadarkdk@pop-os:~$ virsh version
Compiled against library: libvirt 8.0.0
Using library: libvirt 8.0.0
Using API: QEMU 8.0.0
Running hypervisor: QEMU 6.2.0

aadarkdk@pop-os:~$ terraform version
Terraform v1.14.9
on linux_amd64
aadarkdk@pop-os:~$ 

```

4. Download Base Cloud Image that will serve as VM template.
```hcl
sudo mkdir -p /var/lib/libvirt/images

sudo wget -O /var/lib/libvirt/images/noble-server-cloudimg-amd64.img \
  https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img

# Check the image properties
aadarkdk@pop-os:~$ qemu-img info /var/lib/libvirt/images/noble-server-cloudimg-amd64.img

image: /var/lib/libvirt/images/noble-server-cloudimg-amd64.img
file format: qcow2
virtual size: 3.5 GiB (3758096384 bytes)
disk size: 599 MiB
cluster_size: 65536
Format specific information:
    compat: 1.1
    compression type: zlib
    lazy refcounts: false
    refcount bits: 16
    corrupt: false
    extended l2: false
aadarkdk@pop-os:~$ 
```

![check the image properties](https://github.com/erkdk/devsecops-journey/blob/main/11-terraform/08-local-infra/screenshots/check-image-info.png)


5. Create a working directory
 (ss here) 
 
6. Create ``` main.tf ``` : Provider and pool definition
```hcl
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

```

7. Initialize terraform: 

![Initialize terraform](https://github.com/erkdk/devsecops-journey/blob/main/11-terraform/08-local-infra/screenshots/terraform_init_provider_plugin.png)

- This downloads the provider plugin and create the lock file.

8. Virtual Network Configuration: Create ``` network.tf ``` to define network.
```
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

```

#### When this resource is applied, libvirt automatically does followings:
 - Creates a bridge interface (e.g. ``` virb1 ```)
 - Assigns the gateway address ( ``` 10.10.10.1 ```)
 - Starts a ``` dnsmasq ``` process for DHCP and DNS
 - Adds ``` iptables ``` rules for NAT masquerading


9. Base Volume Configuration:

Before writing the volume configuration, it is important to understand how QCOW2 backing files work.
A QCOW2 volume can reference a backing file. The backing file acts as a read-only base image. 
The new volume only stores the differences (deltas) from the base:

- Why this matters:
Ten VMs from the same backing file consume roughly 2 MB total initially instead of 35 GB.
Each VM only stores its own changes.

So, Create ``` storage.tf ```:
```
resource "libvirt_volume" "base_image" {
  name     = "ubuntu-noble"
  pool     = libvirt_pool.lab.name
  capacity = 3758096384

  target {
    format {
      type = "qcow2"
    }
  }

  backing_store {
    path = "/var/lib/libvirt/images/noble-server-cloudimg-amd64.img"
    format {
      type = "qcow2"
    }
  }
}

```

10. Validation and Verification
- Apply the configuration
```
terraform apply
```

- Verifying with Terraform
```
terraform state list
```

- Verifying with libvirt Tools
![Initialize terraform](https://github.com/erkdk/devsecops-journey/blob/main/11-terraform/08-local-infra/screenshots/verify_state_list.png)

<i> This configuration was developed and tested on Pop!_OS 22.04 with Terraform v1.14.9 and libvirt provider v0.9.7. <i>





  