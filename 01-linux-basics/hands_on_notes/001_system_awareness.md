### System Awareness
#### Scenario: 
- “Just got SSH access to a production server. Don't know anything about it.”
---

1. What OS is this?
```
erkdk@my-lab:~$ cat /etc/os-release 

PRETTY_NAME="Ubuntu 24.04.4 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.4 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
```
✔ Ans: Ubuntu 24.04.4 LTS (Noble Numbat)

---

2. Kernel version?
```
erkdk@my-lab:~$ uname -a

Linux my-lab 6.8.0-100-generic #100-Ubuntu SMP PREEMPT_DYNAMIC Tue Jan 13 16:40:06 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
```
✔ Ans: 6.8.0-100-generic (Ubuntu build)

---

3. CPU & memory?
- CPU
```
erkdk@my-lab:~$ lscpu

erkdk@my-lab:~$ lscpu | grep "Model name"
Model name:                              11th Gen Intel(R) Core(TM) i5-1135G7 @ 2.40GHz
```
✔ Ans: Intel(R) Core(TM) i5-1135G7

- memory(RAM)(unit: GiB)
```
erkdk@my-lab:~$ free -h

               total        used        free      shared  buff/cache   available
Mem:           2.8Gi       419Mi       1.8Gi       1.1Mi       833Mi       2.4Gi
Swap:             0B          0B          0B
```
✔ Ans: (total): 2.8Gi and (Available): 1.8Gi

---

4. Disk size and usage?
```
erkdk@my-lab:~$ df -h

Filesystem      Size  Used Avail Use% Mounted on
tmpfs           291M  1.1M  290M   1% /run
/dev/vda1        19G  2.1G   17G  12% /
tmpfs           1.5G     0  1.5G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/vda16      881M   64M  756M   8% /boot
/dev/vda15      105M  6.2M   99M   6% /boot/efi
tmpfs           291M   12K  291M   1% /run/user/1000
```
✔ Ans: Total Size =  19G, Used = 2.2G(12%) and Available = 17G 

unit: Gi
```
erkdk@my-lab:~$ df -h /

Filesystem      Size  Used Avail Use% Mounted on
/dev/vda1        19G  2.2G   17G  12% /
```

unit: GB
```
erkdk@my-lab:~$ df -H /
Filesystem      Size  Used Avail Use% Mounted on
/dev/vda1        20G  2.3G   18G  12% /

```

---	
5. Current logged-in user?
```
erkdk@my-lab:~$ whoami

erkdk
```

---
6. Hostname?
```
erkdk@my-lab:~$ hostname

my-lab
```
---
7. All users(system/services, normal, root) present in the system?\
To list all users: system, service, and human users:
```
erkdk@my-lab:~$ cat /etc/passwd
```
```
(output format):

username : password : UID : GID : comment : home : shell
```
#
- UID = 	0 	    -->  root
- UID < 	1000	-->  system users
- UID >=	1000	-->  normal users 

---
8. How long has the system been running?
```
erkdk@my-lab:~$ uptime

 04:51:41 up 56 min,  1 user,  load average: 0.00, 0.00, 0.00
```
---

9. What processes started at boot?\
--> The system uses systemd as the init system (PID 1), which is responsible for starting all other services during boot.\
--> All background services (SSH, networking, etc) are managed by it.
```
erkdk@my-lab:~$ ps -p 1 -o comm=

systemd
```
---
10. Who else is logged in (if any)?
```
erkdk@my-lab:~$ who

erkdk    pts/0        2026-03-18 03:56 (192.168.100.1)
```
- User: ``erkdk``
- Terminal: ``pts/0``       SSH session ( pseudo-terminal)
- Source IP: ``192.168.100.1``

```
erkdk@my-lab:~$ w

 04:54:35 up 59 min,  1 user,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU  WHAT
erkdk             192.168.100.1    03:56   59:13   0.00s  0.08s sshd: erkdk [priv]
```
---
11. What shell using right now?
```
erkdk@my-lab:~$ echo $SHELL

/bin/bash
```
---
