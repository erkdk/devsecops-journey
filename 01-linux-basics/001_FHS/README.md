### FILE
- "everything in Linux is a file; if something is not a file, it is a process"
-  is the fundamental abstraction used to represent nearly all system resources to manage and interact with data, processes and hardware

#### Linux/Unix File Types

| Character | Type | Description |
|-----------|------|-------------|
| `-` | Regular file | Contains data, such as text files, executable programs, or images. |
| `d` | Directory | A file that contains a list of other files and directories, organizing the file system hierarchically. |
| `l` | Symbolic link | A file that acts as a pointer or shortcut to another file or directory elsewhere in the system. |
| `c` | Character device | Represents hardware devices that handle data one character (byte) at a time, such as keyboards or serial ports. |
| `b` | Block device | Represents hardware devices that manage data in fixed-size blocks, such as hard drives and SSDs. |
| `p` | Named pipe (FIFO) | A special file used for communication between processes on a first-in, first-out basis. |
| `s` | Socket | Used for bi-directional inter-process or network communication, allowing data exchange between processes on the same or different machines. |

#### Core filesystem hierarchies
- the root (/) filesystem hierarchy
- the /usr hierarchy
- the /var hierarchy

##### root (/)
- top-level directory of the filesystem hierarchy
- contains all essential components needed to boot, restore, recover and repair the system

- Directories:
    > /bin   (essential user binaries needed for system boot and repair in single-user mode, often symlinked to `/usr/bin` on modern systems)  
    > /boot  (boot loader files)  
    > /dev   (device files that represent hardware devices and system interfaces(eg. `/dev/sda`(hard disk), `/dev/tty`(terminals), `/dev/null`))
    > /etc   (configuration files: host-specific system-wide configuration files and shell scripts used during system boot, contains (application configs, network settings and user auth))
    > /lib   (contain essential shared libraries, kernel modules needed to boot the system and run essential binaries in `/bin` and `/sbin`. often symlinked to `/usr/lib` on modern systems)
    > /media (mount points for temporarily mountiing filesystems, removeable media, empty by default)
    > /mnt   (temporary mount point for filesystems intended for manual use)
    > /opt   (holds optional software packages, add-on application packages, third-party or proprietary software and each package installs in its own subdirectory)
    > /run   (stores runtime variable data for system processes since last boot cleared on boot (includes process IDs (PID files), system logs, and user sessions))
    > /sbin  (system administration binaries for booting and system recovery, used by root eg: (`fdisk`, `mkfs`, `init`, `ifconfig`))
    > /srv   (contains site-specific data served by the system services eg: (`/srv/www`), FTP data)
    > /tmp   (holds temporary files created by by applications and users, often cleared on system reboot)
    > /usr   (user programs: read-only user utilities, applications, libraries, documentation, shared across systems)
    > /var   (variable data that change during system operation: logs, spools, caches, databases, email queues)

Additional directories that may be present:
    >>  `/home` ( user home directories, personal files, configurations, data for each user)
    >>  `/lib<qualifier>` (for alternate format libraries)
    >>  `root`  (home directory for root user, not accessible by regular users)
    >>  `/lost+found` (recovered files after filesystem check)
    >>  `/proc` (virtual filesystem providing process and kernel info)
    >>  `/sys`  (virtual filesystem exposing kernel objects and device information)
    >>  `/snap` (snap packages mount point and storage (ubuntu))

##### The /usr hierarchy
- Secondary hierarchy with read-only, shareable data
- Contains user utilities and applications that are not essential for system boot

| Directory | Name/Purpose | Key Contents & Function |
|-----------|--------------|------------------------|
| `/usr/bin` | User Binaries | Contains most user commands and utilities (non-essential for boot). Examples: `gcc`, `python`, `vim`, `git`. |
| `/usr/lib` | Libraries | Contains libraries for binaries in `/usr/bin` and `/usr/sbin`, as well as architecture-dependent data files. |
| `/usr/local` | Local Software | Tertiary hierarchy for locally installed software, separate from system package manager. Typically contains manually compiled/installed applications. |
| `/usr/sbin` | System Binaries | Contains non-essential system administration binaries (daemons, network services) not needed for system boot. |
| `/usr/share` | Shared Data | Architecture-independent data files: documentation, man pages, icons, locale data, default configurations. |
| `/usr/src` | Source Code | Contains source code files, typically the Linux kernel source and headers. |
| `/usr/include` | Header Files | Contains standard include headers for C/C++ programming. |

##### The /var hierarchy
- Contains variable data files that change during system operation
- Intended to be writable during normal system operation

| Directory | Name/Purpose | Key Contents & Function |
|-----------|--------------|------------------------|
| `/var/cache` | Application Cache | Cached data from applications (package manager cache, font cache, web proxy cache). Can be safely deleted without loss of essential data. |
| `/var/lib` | Variable State Information | State information that persists between sessions. Contains databases, package manager state, Docker containers, and application data. |
| `/var/log` | Log Files | System logs, application logs, and debug information. Contains syslog, auth.log, kernel logs, and application-specific logs. |
| `/var/mail` | Mail Spool | User mailbox files. Sometimes symlinked to `/var/spool/mail`. Contains incoming emails for local users. |
| `/var/opt` | Variable Data for `/opt` | Variable data for software installed in `/opt`. Each package maintains its own subdirectory. |
| `/var/run` | Runtime Data | Run-time variable data. Often symlinked to `/run` on modern systems. |
| `/var/spool` | Spool Data | Data waiting for processing: print jobs, mail queues, cron and at jobs. |
| `/var/tmp` | Temporary Files Preserved | Temporary files that should be preserved between system reboots. Less frequently cleared than `/tmp`. |

#### See more resources
- [Filesystem Hierarchy Standard](https://documentation.ubuntu.com/project/how-ubuntu-is-made/concepts/filesystem-hierarchy-standard/)
- [Linux Filesystem Hierarchy - The Linux Documentation Project](https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/)
- `man hier` - Manual page for filesystem hierarchy
