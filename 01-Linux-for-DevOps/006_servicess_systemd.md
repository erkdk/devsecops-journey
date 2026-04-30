### Services & systemd
- Scenario:
  “A critical service is down. Users cannot access the application.”<br>
  “If this breaks in production, how do I debug?”

---
1. List all services (``systemctl list-units --type=service``)
```
erkdk@my-lab:~$ systemctl list-units --type=service

  UNIT                                           LOAD   ACTIVE SUB     DESCRIPTION                                                                  
  apparmor.service                               loaded active exited  Load AppArmor profiles
  apport.service                                 loaded active exited  automatic crash report generation
  blk-availability.service                       loaded active exited  Availability of block devices
  cloud-config.service                           loaded active exited  Cloud-init: Config Stage
  cloud-final.service                            loaded active exited  Cloud-init: Final Stage
  cloud-init-local.service                       loaded active exited  Cloud-init: Local Stage (pre-network)
  cloud-init.service                             loaded active exited  Cloud-init: Network Stage
  console-setup.service                          loaded active exited  Set console font and keymap
  cron.service                                   loaded active running Regular background program processing daemon
  dbus.service                                   loaded active running D-Bus System Message Bus
  finalrd.service                                loaded active exited  Create final runtime dir for shutdown pivot root
  getty@tty1.service                             loaded active running Getty on tty1
  keyboard-setup.service                         loaded active exited  Set the console keyboard layout
  kmod-static-nodes.service                      loaded active exited  Create List of Static Device Nodes
  lvm2-monitor.service                           loaded active exited  Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling
  ... 						 ...
  sysstat.service                                loaded active exited  Resets System Activity Logs
  systemd-binfmt.service                         loaded active exited  Set Up Additional Binary Formats
  systemd-fsck@dev-disk-by\x2dlabel-BOOT.service loaded active exited  File System Check on /dev/disk/by-label/BOOT
  systemd-fsck@dev-disk-by\x2dlabel-UEFI.service loaded active exited  File System Check on /dev/disk/by-label/UEFI
  systemd-journal-flush.service                  loaded active exited  Flush Journal to Persistent Storage
  systemd-journald.service                       loaded active running Journal Service
  systemd-logind.service                         loaded active running User Login Management
  systemd-modules-load.service                   loaded active exited  Load Kernel Modules
  systemd-networkd-wait-online.service           loaded active exited  Wait for Network to be Configured
  systemd-networkd.service                       loaded active running Network Configuration
  systemd-random-seed.service                    loaded active exited  Load/Save OS Random Seed
  systemd-remount-fs.service                     loaded active exited  Remount Root and Kernel File Systems
  systemd-resolved.service                       loaded active running Network Name Resolution
  systemd-sysctl.service                         loaded active exited  Apply Kernel Variables
  systemd-timesyncd.service                      loaded active running Network Time Synchronization
  systemd-tmpfiles-setup-dev-early.service       loaded active exited  Create Static Device Nodes in /dev gracefully
  systemd-tmpfiles-setup-dev.service             loaded active exited  Create Static Device Nodes in /dev
lines 1-48
```
- Which services are running?
  --> services with ``SUB``: ``running`` are running
  --> services with ``SUB``: ``exited`` completed performing tasks
- Which are failed?
  --> none. ``ACTIVE`` column has no ``failed``.

---
2. Check SSH service (critical service: ``systemctl status ssh``)
```
erkdk@my-lab:~$ systemctl status ssh

● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/usr/lib/systemd/system/ssh.service; disabled; preset: enabled)
     Active: active (running) since Tue 2026-03-24 14:03:09 UTC; 15min ago
TriggeredBy: ● ssh.socket
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 5957 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 5965 (sshd)
      Tasks: 1 (limit: 3443)
     Memory: 1.2M (peak: 1.5M)
        CPU: 21ms
     CGroup: /system.slice/ssh.service
             └─5965 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Mar 24 14:03:09 my-lab systemd[1]: Starting ssh.service - OpenBSD Secure Shell server...
Mar 24 14:03:09 my-lab sshd[5965]: Server listening on 0.0.0.0 port 22.
Mar 24 14:03:09 my-lab sshd[5965]: Server listening on :: port 22.
Mar 24 14:03:09 my-lab systemd[1]: Started ssh.service - OpenBSD Secure Shell server.
erkdk@my-lab:~$ 
```
- Active state : ``active (running)``
- PID : ``5965``
- Logs section: daemon is listening on ``port 22`` for both IPv4: ``0.0.0.0`` and IPv6: ``::``

---
3. Restart a service(``sudo systemctl restart ssh`` & verify: ``systemctl status ssh``)
```
erkdk@my-lab:~$ sudo systemctl restart ssh
erkdk@my-lab:~$ systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/usr/lib/systemd/system/ssh.service; disabled; preset: enabled)
     Active: active (running) since Tue 2026-03-24 14:53:33 UTC; 13s ago
TriggeredBy: ● ssh.socket
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 6375 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 6378 (sshd)
      Tasks: 1 (limit: 3443)
     Memory: 1.2M (peak: 1.4M)
        CPU: 32ms
     CGroup: /system.slice/ssh.service
             └─6378 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Mar 24 14:53:33 my-lab systemd[1]: Starting ssh.service - OpenBSD Secure Shell server...
Mar 24 14:53:33 my-lab sshd[6378]: Server listening on 0.0.0.0 port 22.
Mar 24 14:53:33 my-lab sshd[6378]: Server listening on :: port 22.
Mar 24 14:53:33 my-lab systemd[1]: Started ssh.service - OpenBSD Secure Shell server.
erkdk@my-lab:~$ 
```

---
4. Stop & Start (simulate outage: ``sudo systemctl stop ssh``)

- this is real

- SSH session will still stay alive
- BUT new connections will fail

Now:
sudo systemctl start ssh

---
5. Enable / Disable service at boot (``systemctl is-enabled ssh``)
```
erkdk@my-lab:~$ sudo systemctl enable ssh

Synchronizing state of ssh.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install enable ssh
Created symlink /etc/systemd/system/sshd.service → /usr/lib/systemd/system/ssh.service.
Created symlink /etc/systemd/system/multi-user.target.wants/ssh.service → /usr/lib/systemd/system/ssh.service.

erkdk@my-lab:~$ systemctl is-enabled ssh
enabled
```
```
erkdk@my-lab:~$ sudo systemctl disable ssh

Synchronizing state of ssh.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install disable ssh
Removed "/etc/systemd/system/sshd.service".
Removed "/etc/systemd/system/multi-user.target.wants/ssh.service".
Disabling 'ssh.service', but its triggering units are still active:
ssh.socket
```

---
6. Find failed services(``systemctl --failed``)
```
erkdk@my-lab:~$ systemctl --failed
  UNIT LOAD ACTIVE SUB DESCRIPTION

0 loaded units listed.
erkdk@my-lab:~$ 
```
---
7. Logs (critical skill: ``journalctl -xe`` (filter: ``journalctl -u ssh``  & ``journalctl -u ssh --since "10 minutes ago"``)
```
erkdk@my-lab:~$ journalctl -xe

erkdk@my-lab:~$ journalctl -u ssh
-- Boot c5cbc16790b14482ab94aa58f192e1d5 --
Mar 28 04:56:59 my-lab systemd[1]: Starting ssh.service - OpenBSD Secure Shell server...
Mar 28 04:57:00 my-lab sshd[986]: Server listening on 0.0.0.0 port 22.
Mar 28 04:57:00 my-lab sshd[986]: Server listening on :: port 22.
Mar 28 04:57:00 my-lab systemd[1]: Started ssh.service - OpenBSD Secure Shell server.
Mar 28 04:57:44 my-lab sshd[1041]: Accepted password for erkdk from 192.168.110.12 port 54400 ssh2
Mar 28 04:57:44 my-lab sshd[1041]: pam_unix(sshd:session): session opened for user erkdk(uid=1000) by erkdk(uid=0)
lines 158-205/205 (END)
```
```
erkdk@my-lab:~$ journalctl -u ssh --since "24 hours ago"
```
```
erkdk@my-lab:~$ journalctl -u ssh -n 8
Mar 24 14:53:33 my-lab systemd[1]: Started ssh.service - OpenBSD Secure Shell server.
Mar 24 16:00:56 my-lab sshd[6378]: Received signal 15; terminating.
-- Boot c5cbc16790b14482ab94aa58f192e1d5 --
Mar 28 04:56:59 my-lab systemd[1]: Starting ssh.service - OpenBSD Secure Shell server...
Mar 28 04:57:00 my-lab sshd[986]: Server listening on 0.0.0.0 port 22.
Mar 28 04:57:00 my-lab sshd[986]: Server listening on :: port 22.
Mar 28 04:57:00 my-lab systemd[1]: Started ssh.service - OpenBSD Secure Shell server.
Mar 28 04:57:44 my-lab sshd[1041]: Accepted password for erkdk from 192.168.100.1 port 54400 ssh2
Mar 28 04:57:44 my-lab sshd[1041]: pam_unix(sshd:session): session opened for user erkdk(uid=1000) by erkdk(uid=0)
erkdk@my-lab:~$ 
```
---
8. Simulate failure (real debugging: Stop SSH: ``sudo systemctl stop ssh`` & check: ``systemctl status ssh`` & ``journalctl -u ssh``)
```
erkdk@my-lab:~$ sudo systemctl status ssh

erkdk@my-lab:~$ sudo systemctl stop ssh
Stopping 'ssh.service', but its triggering units are still active:
ssh.socket
erkdk@my-lab:~$ systemctl status ssh

erkdk@my-lab:~$ systemctl status ssh
○ ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/usr/lib/systemd/system/ssh.service; enabled; preset: enabled)
     Active: inactive (dead) since Sat 2026-03-28 07:00:58 UTC; 17s ago
   Duration: 2h 3min 58.300s
TriggeredBy: ● ssh.socket
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 979 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
    Process: 986 ExecStart=/usr/sbin/sshd -D $SSHD_OPTS (code=exited, status=0/SUCCESS)
   Main PID: 986 (code=exited, status=0/SUCCESS)
        CPU: 134ms

Mar 28 04:56:59 my-lab systemd[1]: Starting ssh.service - OpenBSD Secure Shell server...
Mar 28 04:57:00 my-lab sshd[986]: Server listening on 0.0.0.0 port 22.
Mar 28 04:57:00 my-lab sshd[986]: Server listening on :: port 22.
Mar 28 04:57:00 my-lab systemd[1]: Started ssh.service - OpenBSD Secure Shell server.
Mar 28 04:57:44 my-lab sshd[1041]: Accepted password for erkdk from 192.168.100.1 port 54400 ssh2
Mar 28 04:57:44 my-lab sshd[1041]: pam_unix(sshd:session): session opened for user erkdk(uid=1000) by erkdk(uid=0)
Mar 28 07:00:58 my-lab systemd[1]: Stopping ssh.service - OpenBSD Secure Shell server...
Mar 28 07:00:58 my-lab systemd[1]: ssh.service: Deactivated successfully.
Mar 28 07:00:58 my-lab systemd[1]: Stopped ssh.service - OpenBSD Secure Shell server.
erkdk@my-lab:~$
```
```
erkdk@my-lab:~$ journalctl -u ssh
-- Boot c5cbc16790b14482ab94aa58f192e1d5 --
Mar 28 04:56:59 my-lab systemd[1]: Starting ssh.service - OpenBSD Secure Shell server...
Mar 28 04:57:00 my-lab sshd[986]: Server listening on 0.0.0.0 port 22.
Mar 28 04:57:00 my-lab sshd[986]: Server listening on :: port 22.
Mar 28 04:57:00 my-lab systemd[1]: Started ssh.service - OpenBSD Secure Shell server.
Mar 28 04:57:44 my-lab sshd[1041]: Accepted password for erkdk from 192.168.100.1 port 54400 ssh2
Mar 28 04:57:44 my-lab sshd[1041]: pam_unix(sshd:session): session opened for user erkdk(uid=1000) by erkdk(uid=0)
Mar 28 07:00:58 my-lab systemd[1]: Stopping ssh.service - OpenBSD Secure Shell server...
Mar 28 07:00:58 my-lab systemd[1]: ssh.service: Deactivated successfully.
Mar 28 07:00:58 my-lab systemd[1]: Stopped ssh.service - OpenBSD Secure Shell server.
lines 161-208/208 (END)

```

Understand:

What changed?
What logs say?

---
9. Analyze boot services(``systemctl list-unit-files --type=service``)
```
erkdk@my-lab:~$ systemctl list-unit-files --type=service

UNIT FILE                                    STATE           PRESET  
apparmor.service                             enabled         enabled 
apport-autoreport.service                    static          -       
apport-coredump-hook@.service                static          -       
apport-forward@.service                      static          -       
apport.service                               enabled         enabled 
...					     ...	     ...
debug-shell.service                          disabled        disabled
```
Understand:
- STATE (current configuration status of unit on disk)
- PRESET (factory setting: system's default policy)
- enabled (service starts automatically at boot)
- disabled (service will not stop at boot)
- static (service cannot be enabled or disabled by the user)

---
10. Find what runs at boot (deep insight: ``systemctl get-default`` && ``systemctl list-dependencies multi-user.target``
```
erkdk@my-lab:~$ systemctl get-default

graphical.target
```
```
erkdk@my-lab:~$ systemctl list-dependencies multi-user.target

multi-user.target
● ├─apport.service
● ├─console-setup.service
● ├─cron.service
● ├─dbus.service
○ ├─dmesg.service
○ ├─e2scrub_reap.service
○ ├─grub-common.service
○ ├─grub-initrd-fallback.service
● ├─lxd-installer.socket
  ......................
● ├─cloud-init.target
● │ ├─cloud-config.service
● │ ├─cloud-final.service
● │ ├─cloud-init-local.service
● │ └─cloud-init.service
● ├─getty.target
○ │ ├─getty-static.service
● │ ├─getty@tty1.service
● │ └─serial-getty@ttyS0.service
● └─remote-fs.target
```

---
##### REAL-WORLD DEBUG FLOW (when service is down:)
- ``systemctl status <service>``
- ``journalctl -u <service>``
- ``ss -tulnp | grep <port>``
- ``ps aux | grep <service>``

---
