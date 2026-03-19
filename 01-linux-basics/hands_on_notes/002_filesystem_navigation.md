### Filesystem Navigation
#### Scenario:
- “You are debugging a production issue. Logs and configs are somewhere in the system.”

---
1. Explore system structure

```
/
 /home
 /var
 /etc
```
- What type of data is stored here?
Answer:

- /
	--> root of the entire filesystem (everything starts here)

- /home
	--> user data, user home directories (eg. /home/erkdk) 

- /var
	--> runtime, variable data (changes frequently), contains: logs(/var/logs), packages(/var/lib), cache(/var/cache)

- /etc
	--> system-wide configuration files

---
2. Find SSH-related files in ``/etc``
```
erkdk@my-lab:/$ find /etc/ -iname "*ssh*"
```

---
3. Disk usage investigation: Find top 3 largest directories inside ``/var``
```
erkdk@my-lab:/$ sudo du -h /var | sort -h | tail -3

231M	/var/lib/apt/lists
275M	/var/lib
554M	/var

erkdk@my-lab:~$ sudo du -sh /var/* sort -h
```
---
4. Create:  ~/lab1/test.txt  &  Write something into it	 &  Copy it to: /var/tmp/  &  Verify it exists there
```
erkdk@my-lab:~$ mkdir -p lab1 && touch lab1/test.txt		(create)

erkdk@my-lab:~$ cd lab1/
erkdk@my-lab:~/lab1$ ls
test.txt

erkdk@my-lab:~/lab1$ echo "I am learning DevOps." > test.txt	(write)
erkdk@my-lab:~/lab1$ cat test.txt
I am learning DevOps.

erkdk@my-lab:~/lab1$ cp test.txt /var/tmp/	(copy)

erkdk@my-lab:~$ ls -la /var/tmp/
-rw-rw-r--  1 erkdk erkdk   22 Mar 18 11:58 test.txt         (verify)
erkdk@my-lab:~$ 
```

---
5. Find your(test.txt) file from root (/) without knowing location
```
erkdk@my-lab:~$ sudo find / -name "test.txt" 2>/dev/null	(search)

/home/erkdk/lab1/test.txt
/var/tmp/test.txt
```

---
6. Find all .log files in /var/log
```
erkdk@my-lab:~$ sudo find /var/log -name "*.log"

/var/log/auth.log
/var/log/cloud-init.log
/var/log/cloud-init-output.log
/var/log/apport.log
/var/log/landscape/sysinfo.log
/var/log/unattended-upgrades/unattended-upgrades.log
/var/log/unattended-upgrades/unattended-upgrades-dpkg.log
/var/log/unattended-upgrades/unattended-upgrades-shutdown.log
/var/log/apt/history.log
/var/log/apt/term.log
/var/log/dpkg.log
/var/log/kern.log
/var/log/alternatives.log

erkdk@my-lab:~$ sudo find /var/log -maxdepth 1 -name "*.log"

/var/log/auth.log
/var/log/cloud-init.log
/var/log/cloud-init-output.log
/var/log/apport.log
/var/log/dpkg.log
/var/log/kern.log
/var/log/alternatives.log

```

---
7. Find files larger than 50MB in /var
```
erkdk@my-lab:~$ sudo find /var -size +50M			(files and directories)

/var/lib/apt/lists/archive.ubuntu.com_ubuntu_dists_noble_universe_binary-amd64_Packages
/var/cache/apt/pkgcache.bin
/var/cache/apt/srcpkgcache.bin

erkdk@my-lab:~$ sudo find -type f -size +50M			(only files)
```

---
8. Find all files owned by your user
```
erkdk@my-lab:~$ sudo find / -type f -user $USER

erkdk@my-lab:~$ find /home /var/tmp/ -type f -user $USER
```

---
