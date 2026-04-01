### Package Management
#### Scenario:
- “You need to install and manage software safely on a production server.”

---
#### 1. Update package index (NOT upgrade: ```sudo apt update```)
```
erkdk@my-lab:~$ sudo apt update

Hit:1 http://archive.ubuntu.com/ubuntu noble InRelease
Get:2 http://security.ubuntu.com/ubuntu noble-security InRelease [126 kB]
...
Get:37 http://security.ubuntu.com/ubuntu noble-security/multiverse amd64 Components [208 B]
Fetched 15.4 MB in 6s (2640 kB/s)                                
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
16 packages can be upgraded. Run 'apt list --upgradable' to see them.
```
##### Understand: 
- This does NOT install anything
- It refreshes available package metadata

---
#### 2. Inspect upgradable packages (```apt list --upgradable```)
```
erkdk@my-lab:~$ apt list --upgradable

Listing... Done
cloud-init/noble-updates 25.3-0ubuntu1~24.04.1 all [upgradable from: 25.2-0ubuntu1~24.04.1]
coreutils/noble-updates 9.4-3ubuntu6.2 amd64 [upgradable from: 9.4-3ubuntu6.1]
fwupd/noble-updates 1.9.34-0ubuntu1~24.04.1 amd64 [upgradable from: 1.9.33-0ubuntu1~24.04.1ubuntu1]
libfwupd2/noble-updates 1.9.34-0ubuntu1~24.04.1 amd64 [upgradable from: 1.9.33-0ubuntu1~24.04.1ubuntu1]
libnftables1/noble-updates 1.0.9-1ubuntu0.1 amd64 [upgradable from: 1.0.9-1build1]
linux-base/noble-updates 4.5ubuntu9+24.04.2 all [upgradable from: 4.5ubuntu9+24.04.1]
nftables/noble-updates 1.0.9-1ubuntu0.1 amd64 [upgradable from: 1.0.9-1build1]
python3-software-properties/noble-updates 0.99.49.4 all [upgradable from: 0.99.49.3]
software-properties-common/noble-updates 0.99.49.4 all [upgradable from: 0.99.49.3]
sosreport/noble-updates 4.10.2-0ubuntu0~24.04.1 amd64 [upgradable from: 4.9.2-0ubuntu0~24.04.1]
systemd-hwe-hwdb/noble-updates 255.1.7 all [upgradable from: 255.1.6]
erkdk@my-lab:~$ 
```
- How many packages can be upgraded? : ``11``
- Which ones look critical (openssl, libc, etc.)? : 

---
#### 3. Install packages (Install ``htop`` and ``curl``: ```sudo apt install htop curl -y```)
```
erkdk@my-lab:~$ sudo apt install htop curl -y

Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
htop is already the newest version (3.3.0-4build1).
htop set to manually installed.
curl is already the newest version (8.5.0-2ubuntu10.8).
curl set to manually installed.
0 upgraded, 0 newly installed, 0 to remove and 12 not upgraded.
erkdk@my-lab:~$ 
```

---
#### 4. Verify installation (``which htop`` , ``which curl`` , ``htop curl --version``)
```
erkdk@my-lab:~$ which htop
/usr/bin/htop

erkdk@my-lab:~$ which curl
/usr/bin/curl

erkdk@my-lab:~$ htop --version
htop 3.3.0

erkdk@my-lab:~$ curl --version
curl 8.5.0 (x86_64-pc-linux-gnu) libcurl/8.5.0 OpenSSL/3.0.13 zlib/1.3 brotli/1.1.0 zstd/1.5.5 libidn2/2.3.7 libpsl/0.21.2 (+libidn2/2.3.7) libssh/0.10.6/openssl/zlib nghttp2/1.59.0 librtmp/2.3 OpenLDAP/2.6.10
Release-Date: 2023-12-06, security patched: 8.5.0-2ubuntu10.8
Protocols: dict file ftp ftps gopher gophers http https imap imaps ldap ldaps mqtt pop3 pop3s rtmp rtsp scp sftp smb smbs smtp smtps telnet tftp
Features: alt-svc AsynchDNS brotli GSS-API HSTS HTTP2 HTTPS-proxy IDN IPv6 Kerberos Largefile libz NTLM PSL SPNEGO SSL threadsafe TLS-SRP UnixSockets zstd
erkdk@my-lab:~$ 
```

##### Understand:
- Where binaries are installed : ``/usr/bin``
- Version info: ``3.3.0`` and ``8.5.0``

---
#### 5. Inspect package details (```apt show htop```)
```
erkdk@my-lab:~$ apt show htop 
Package: htop
Version: 3.3.0-4build1
Priority: optional
Section: utils
Origin: Ubuntu
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Original-Maintainer: Daniel Lange <DLange@debian.org>
Bugs: https://bugs.launchpad.net/ubuntu/+filebug
Installed-Size: 434 kB
Depends: libc6 (>= 2.38), libncursesw6 (>= 6), libnl-3-200 (>= 3.2.7), libnl-genl-3-200 (>= 3.2.7), libtinfo6 (>= 6)
Suggests: lm-sensors, lsof, strace
Homepage: https://htop.dev/
Task: cloud-image, cloud-image, server, ubuntu-server-raspi, lubuntu-desktop, ubuntu-mate-core, ubuntu-mate-desktop, ubuntu-budgie-desktop-minimal, ubuntu-budgie-desktop, ubuntu-budgie-desktop-raspi
Download-Size: 171 kB
APT-Manual-Installed: yes
APT-Sources: http://archive.ubuntu.com/ubuntu noble/main amd64 Packages
Description: interactive processes viewer
 Htop is an ncursed-based process viewer similar to top, but it
 allows one to scroll the list vertically and horizontally to see
 all processes and their full command lines.
 .
 Tasks related to processes (killing, renicing) can be done without
 entering their PIDs.

erkdk@my-lab:~$ 
```
##### Look for:
- Dependencies: libc6, libncursesw6, libnl, libnl-genl, libtinfo6
- Description:	interactive processes viewer
- Maintainer:	Ubuntu Developers

---
#### 6. See dependency tree (```apt depends htop```)
```
erkdk@my-lab:~$ apt depends htop
htop
  Depends: libc6 (>= 2.38)
  Depends: libncursesw6 (>= 6)
  Depends: libnl-3-200 (>= 3.2.7)
  Depends: libnl-genl-3-200 (>= 3.2.7)
  Depends: libtinfo6 (>= 6)
  Suggests: lm-sensors
  Suggests: lsof
  Suggests: strace
erkdk@my-lab:~$ 
```

---
#### 7. Remove a package (``sudo apt remove htop`` and  verify: ``which htop``)
```
erkdk@my-lab:~$ sudo apt remove htop
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages will be REMOVED:
  htop ubuntu-server
0 upgraded, 0 newly installed, 2 to remove and 12 not upgraded.
After this operation, 452 kB disk space will be freed.
Do you want to continue? [Y/n] y
(Reading database ... 106852 files and directories currently installed.)
Removing ubuntu-server (1.539.2) ...
Removing htop (3.3.0-4build1) ...
Processing triggers for man-db (2.12.0-4build2) ...

erkdk@my-lab:~$ which htop
erkdk@my-lab:~$ 
```

---
#### 8. Purge (deep removal : ``sudo apt purge htop``)
```
erkdk@my-lab:~$ sudo apt purge htop
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages will be REMOVED:
  htop*
0 upgraded, 0 newly installed, 1 to remove and 12 not upgraded.
After this operation, 434 kB disk space will be freed.
Do you want to continue? [Y/n] y
(Reading database ... 106849 files and directories currently installed.)
Removing htop (3.3.0-4build1) ...
Processing triggers for man-db (2.12.0-4build2) ...
erkdk@my-lab:~$ 
```
##### Difference:
- remove → keeps config files
- purge → removes everything

---
#### 9. Clean unused dependencies (``sudo apt autoremove``)
```
erkdk@my-lab:~$ sudo apt autoremove
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
0 upgraded, 0 newly installed, 0 to remove and 12 not upgraded.
erkdk@my-lab:~$ 
```
##### This prevents:
- bloated systems
- unnecessary attack surface

---
#### 10. Package files location (IMPORTANT: ``dpkg -L curl``)
```
erkdk@my-lab:~$ dpkg -L curl
/.
/usr
/usr/bin
/usr/bin/curl
/usr/share
/usr/share/doc
/usr/share/doc/curl
/usr/share/doc/curl/README.Debian
/usr/share/doc/curl/copyright
/usr/share/man
/usr/share/man/man1
/usr/share/man/man1/curl.1.gz
/usr/share/zsh
/usr/share/zsh/vendor-completions
/usr/share/zsh/vendor-completions/_curl
/usr/share/doc/curl/changelog.Debian.gz
erkdk@my-lab:~$ 
```

##### Shows:
- where files are installed: 

---
#### 11. Which package owns a file (``dpkg -S /usr/bin/curl``)
```
erkdk@my-lab:~$ dpkg -S /usr/bin/curl

curl: /usr/bin/curl
erkdk@my-lab:~$ 
```
- ``curl`` package owns file ``/usr/bin/curl``

---
#### 12. Simulate upgrade (PRODUCTION-SKILL: ``sudo apt upgrade --dry-run``)
```
erkdk@my-lab:~$ sudo apt upgrade --dry-run
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Calculating upgrade... Done
The following upgrades have been deferred due to phasing:
  fwupd libfwupd2
The following packages will be upgraded:
  cloud-init coreutils libnftables1 linux-base nftables pollinate python3-software-properties software-properties-common sosreport systemd-hwe-hwdb
10 upgraded, 0 newly installed, 0 to remove and 2 not upgraded.
1 standard LTS security update
Inst coreutils [9.4-3ubuntu6.1] (9.4-3ubuntu6.2 Ubuntu:24.04/noble-updates [amd64])
Conf coreutils (9.4-3ubuntu6.2 Ubuntu:24.04/noble-updates [amd64])
Inst systemd-hwe-hwdb [255.1.6] (255.1.7 Ubuntu:24.04/noble-updates [all])
Inst nftables [1.0.9-1build1] (1.0.9-1ubuntu0.1 Ubuntu:24.04/noble-updates [amd64]) []
Inst libnftables1 [1.0.9-1build1] (1.0.9-1ubuntu0.1 Ubuntu:24.04/noble-updates [amd64])
Inst linux-base [4.5ubuntu9+24.04.1] (4.5ubuntu9+24.04.2 Ubuntu:24.04/noble-updates [all])
Inst pollinate [4.33-3.1ubuntu1.1] (4.33-3.1ubuntu1.3 Ubuntu:24.04/noble-security [all])
Inst software-properties-common [0.99.49.3] (0.99.49.4 Ubuntu:24.04/noble-updates [all]) []
Inst python3-software-properties [0.99.49.3] (0.99.49.4 Ubuntu:24.04/noble-updates [all])
Inst sosreport [4.9.2-0ubuntu0~24.04.1] (4.10.2-0ubuntu0~24.04.1 Ubuntu:24.04/noble-updates [amd64])
Inst cloud-init [25.2-0ubuntu1~24.04.1] (25.3-0ubuntu1~24.04.1 Ubuntu:24.04/noble-updates [all])
Conf systemd-hwe-hwdb (255.1.7 Ubuntu:24.04/noble-updates [all])
Conf nftables (1.0.9-1ubuntu0.1 Ubuntu:24.04/noble-updates [amd64])
Conf libnftables1 (1.0.9-1ubuntu0.1 Ubuntu:24.04/noble-updates [amd64])
Conf linux-base (4.5ubuntu9+24.04.2 Ubuntu:24.04/noble-updates [all])
Conf pollinate (4.33-3.1ubuntu1.3 Ubuntu:24.04/noble-security [all])
Conf software-properties-common (0.99.49.4 Ubuntu:24.04/noble-updates [all])
Conf python3-software-properties (0.99.49.4 Ubuntu:24.04/noble-updates [all])
Conf sosreport (4.10.2-0ubuntu0~24.04.1 Ubuntu:24.04/noble-updates [amd64])
Conf cloud-init (25.3-0ubuntu1~24.04.1 Ubuntu:24.04/noble-updates [all])
erkdk@my-lab:~$ 
```

---
#### REAL-WORLD DEBUG FLOW
- When something breaks after install:
```
apt list --installed | grep <package>
dpkg -l | grep <package>
journalctl -xe
```
##### Common mistakes (avoid)
- Running apt upgrade blindly ❌
- Installing without checking dependencies ❌
- Leaving unused packages ❌
- Ignoring security updates ❌

---
##### RULES (in production)
- Never blindly run apt upgrade in production
- Always verify what will change
- Understand dependencies before installing

---
##### Best Practices for Production
- Dry Runs: 
  Before committing, use ``sudo apt upgrade --dry-run`` 
  This simulates the installation so you can see if any services will be restarted or if large amounts of disk space will be consumed.

- Logs: 
  Always remember that every action is logged in ``/var/log/apt/history.log`` 
  If an upgrade breaks a service, this is the first place to look to see exactly what changed.

- Snapshotting:
  If on a Virtual Machine (VM) or Cloud Instance, take a snapshot before upgrading critical packages like libc or the linux-image (kernel).

---
