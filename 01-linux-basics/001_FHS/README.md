## Linux Filesystem Notes

### FILE

- "everything in Linux is a file; if something is not a file, it is a process"
- A file is the fundamental abstraction used to represent nearly all system resources to manage and interact with data, processes, and hardware

---

### Linux/Unix File Types

| Character | Type | Description |
|-----------|------|-------------|
| `-` | Regular file | Contains data, such as text files, executable programs, or images |
| `d` | Directory | Contains a list of other files and directories, organizing the file system hierarchically |
| `l` | Symbolic link | Acts as a pointer or shortcut to another file or directory |
| `c` | Character device | Represents devices that handle data one character(byte) at a time (e.g., keyboards, serial ports) |
| `b` | Block device | Represents devices that manage data in fixed-size blocks (e.g., hard drives, SSDs) |
| `p` | Named pipe (FIFO) | Used for communication between processes in a first-in, first-out manner |
| `s` | Socket | Used for bidirectional inter-process or network communication between processes on the same or different machines |

---

## Core Filesystem Hierarchies

- Root (`/`) filesystem hierarchy  
- `/usr` hierarchy  
- `/var` hierarchy  

---

### Root (`/`) Directory

- Top-level directory of the filesystem hierarchy  
- Contains all essential components required to boot, restore, recover, and repair the system  

#### Key Directories

- `/bin`  
  Essential user binaries needed for system boot and repair in single-user mode (often symlinked to `/usr/bin`)

- `/boot`  
  Boot loader files  

- `/dev`  
  Device files representing hardware devices and system interfaces  
  eg: `/dev/sda`(hard disk), `/dev/tty`(terminals), `/dev/null`

- `/etc`  
  Configuration files (system-wide, host-specific)  
  Includes files and scripts used during system boot, contains (application configs, network settings, and user authentication)

- `/lib`  
  Essential shared libraries and kernel modules required to boot the system and run essential binaries in /bin and /sbin
  (often symlinked to `/usr/lib`)

- `/media`  
  Mount points for removable media (empty by default)

- `/mnt`  
  Temporary mount point for manual filesystem mounting

- `/opt`  
  Optional/add-on software packages (third-party or proprietary), each package installs in its own subdirectory

- `/run`  
  Runtime variable data since last boot (cleared on reboot)  
  Includes PID files, system logs, user sessions

- `/sbin`  
  System administration binaries for booting and system recovery used by root  
  eg: `fdisk`, `mkfs`, `init`, `ifconfig`

- `/srv`  
  Data served by system services, contains site-specific data served by the system services 
  eg: `/srv/www`, FTP data

- `/tmp`  
  Temporary files created by applications and users (often cleared on reboot)

- `/usr`  
  User programs, libraries, documentation (read-only, shareable across systems)

- `/var`  
  Variable data, change during system operation such as logs, spools, caches, databases, mail queues

---

### Additional Directories

- `/home`  
  User home directories (personal files, data for each user and configs)

- `/lib<qualifier>`  
  Alternate format libraries

- `/root`  
  Home directory for root user, not accessible by regular users

- `/lost+found`  
  Recovered files after filesystem checks

- `/proc`  
  Virtual filesystem providing process and kernel information

- `/sys`  
  Virtual filesystem exposing kernel objects and device info

- `/snap`  
  Snap package storage (Ubuntu)

---

### The `/usr` Hierarchy

- Secondary hierarchy with read-only, shareable data  
- Contains user utilities and applications not required for boot  

| Directory | Name/Purpose | Key Contents & Function |
|-----------|--------------|------------------------|
| `/usr/bin` | User Binaries | Common user commands and utilities (e.g., `gcc`, `python`, `vim`, `git`) |
| `/usr/lib` | Libraries | Libraries for `/usr/bin` and `/usr/sbin`, architecture-dependent data files |
| `/usr/local` | Local Software | Manually compiled/installed software (separate/outside from package manager) |
| `/usr/sbin` | System Binaries | Non-essential system administration binaries tools(daemons, network services) |
| `/usr/share` | Shared Data | Architecture-independent data files: Docs, man pages, icons, locale data, default configs |
| `/usr/src` | Source Code | Kernel source code files and headers |
| `/usr/include` | Header Files | C/C++ standard headers |

---

### The `/var` Hierarchy

- Contains variable data that changes during system operation  
- Writable during normal system use/operation  

| Directory | Name/Purpose | Key Contents & Function |
|-----------|--------------|------------------------|
| `/var/cache` | Application Cache | Cached data from applications (can be safely deleted) |
| `/var/lib` | State Information | Persistent app data, databases, Docker data, package manager state |
| `/var/log` | Log Files | System and application logs(eg. debug information, auth.log, kernel logs, application-specific logs |
| `/var/mail` | Mail Spool | User mailboxes, sometimes symlinked to /var/spool/mail |
| `/var/opt` | Data for `/opt` | Variable data for optional software installed in /opt |
| `/var/run` | Runtime Data | Often symlinked to `/run` |
| `/var/spool` | Spool Data | Queued jobs (print, mail, cron) |
| `/var/tmp` | Persistent Temp Files | Temporary files kept across reboots |

---

#### Additional Resources

- [Filesystem Hierarchy Standard](https://documentation.ubuntu.com/project/how-ubuntu-is-made/concepts/filesystem-hierarchy-standard/)
- [Linux Filesystem Hierarchy - TLDP](https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/)

#### Tip: use this command
- `man hier` — View the filesystem hierarchy directly in your terminal
