### Users & Permissions (Security Base)
#### Scenario:
- “You are onboarding a developer into a production system. You must ensure secure access.”

---
1. Create a new user: ``devuser`` and with requirements: (Has home directory, Uses /bin/bash)
```
erkdk@my-lab:~$ sudo useradd -m -s /bin/bash devuser

-m (or --create-home)
-s /bin/bash (or --shell)

erkdk@my-lab:~$ sudo adduser devuser  		(by default allow to create password and creates home directory)

erkdk@my-lab:~$ sudo userdel -r devuser
```

---
2. Set password for ``devuser``
```
erkdk@my-lab:~$ sudo passwd devuser
New password: 
Retype new password: 
passwd: password updated successfully
```

---
3. Verify user (Check: UID,Home directory, Shell)
```
erkdk@my-lab:~$ grep devuser /etc/passwd	
devuser:x:1001:1001::/home/devuser:/bin/bash

erkdk@my-lab:~$ ls -ld /home/devuser/					(check home directory)
drwxr-x--- 2 devuser devuser 4096 Mar 19 08:28 /home/devuser/
```

---
4. Create secure file (Create: ``/home/devuser/secret.txt`` and Write: ``production-password=password123``
```
erkdk@my-lab:~$ sudo touch /home/devuser/secret.txt    (by default root creates it, not applicable in production)

erkdk@my-lab:~$ sudo ls -la /home/devuser/
total 20
drwxr-x--- 2 devuser devuser 4096 Mar 19 08:47 .
drwxr-xr-x 4 root    root    4096 Mar 19 08:28 ..
-rw-r--r-- 1 devuser devuser  220 Mar 31  2024 .bash_logout
-rw-r--r-- 1 devuser devuser 3771 Mar 31  2024 .bashrc
-rw-r--r-- 1 devuser devuser  807 Mar 31  2024 .profile
-rw-r--r-- 1 root    root       0 Mar 19 08:47 secret.txt
erkdk@my-lab:~$ 

OR

erkdk@my-lab:~$ sudo -u devuser touch /home/devuser/secret.txt			(production acceptable)

erkdk@my-lab:~$ sudo ls -la /home/devuser/secret.txt
-rw-rw-r-- 1 devuser devuser 0 Mar 19 09:44 /home/devuser/secret.txt

erkdk@my-lab:~$ sudo -u devuser bash -c 'echo "production-password=password123" > /home/devuser/secret.txt'
erkdk@my-lab:~$ sudo cat /home/devuser/secret.txt
production-password=password123

erkdk@my-lab:~$ echo "password-password=password123" | sudo tee /home/devuser/secret.txt > /dev/null
```

---
5. Enforce strict permissions (CRITICAL! with Rules: Only devuser can read/write, No access for others)

```
erkdk@my-lab:~$ sudo ls -la /home/devuser/secret.txt
-rw------- 1 root root 30 Mar 19 08:58 /home/devuser/secret.txt

erkdk@my-lab:~$ sudo chown devuser:devuser /home/devuser/secret.txt

erkdk@my-lab:~$ sudo ls -la /home/devuser/secret.txt
-rw-rw-r-- 1 devuser devuser 32 Mar 19 09:47 /home/devuser/secret.txt

erkdk@my-lab:~$ sudo chmod 600 /home/devuser/secret.txt
```

---
6. Validate security (Check: File permissions, Owner)
```
erkdk@my-lab:~$ sudo ls -la /home/devuser/secret.txt
-rw------- 1 devuser devuser 30 Mar 19 08:58 /home/devuser/secret.txt
```

---
7. Try to read that file as your current user (erkdk)
```
erkdk@my-lab:~$ echo $USER
erkdk
erkdk@my-lab:~$ cat /home/devuser/secret.txt
cat: /home/devuser/secret.txt: Permission denied

erkdk@my-lab:~$ sudo -u devuser cat /home/devuser/secret.txt
password-password=password123
```

---
8. Shared access: (create group: ``devteam``) & (add: ``erkdk`` and ``devteam``)  & (create: ``/shared/project.txt``) & (permission: both users can read/write, others cannot access)
```
erkdk@my-lab:~$ sudo groupadd devteam

erkdk@my-lab:~$ sudo usermod -aG devteam devuser
erkdk@my-lab:~$ sudo usermod -aG devteam erkdk

erkdk@my-lab:~$ grep devteam /etc/group
devteam:x:1002:devuser,erkdk

erkdk@my-lab:~$ sudo mkdir /shared

erkdk@my-lab:~$ sudo chown :devteam /shared

erkdk@my-lab:~$ sudo chmod 770 /shared

(imp)note: Shared directory missing setgid bit:  chmod 2770 /shared (With setgid: New files → inherit devteam group)

erkdk@my-lab:~$ ls -la /shared
total 8
drwxrwx---  2 root devteam 4096 Mar 19 11:20 .
drwxr-xr-x 23 root root    4096 Mar 19 11:20 ..

erkdk@my-lab:~$ chmod 770 /shared/project.txt

erkdk@my-lab:~$ ls -l /shared/project.txt 
-rwxrwx--- 1 erkdk devteam 0 Mar 19 11:39 /shared/project.txt
```

---
9. Dangerous permission : (create: ``/tmp/open.txt`` & set: ``chmod 777``)
```
erkdk@my-lab:~$ sudo touch /tmp/open.txt
erkdk@my-lab:~$ sudo ls -l /tmp/open.txt 
-rw-r--r-- 1 root root 0 Mar 20 05:07 /tmp/open.txt

erkdk@my-lab:~$ sudo chmod 777 /tmp/open.txt
erkdk@my-lab:~$ sudo ls -l /tmp/open.txt
-rwxrwxrwx 1 root root 0 Mar 20 05:07 /tmp/open.txt
```

- ``/tmp`` is world-writable → this is a common attack surface

##### Real risks of 777

- Privilege escalation
---> attacker modifies scripts run by root

- Data tampering
---> logs, configs can be altered

- Symlink attacks (IMPORTANT)
---> attacker tricks root process to overwrite critical files

---
10. Sudo privilege check: What commands can your user run as root?
```
erkdk@my-lab:~$ sudo -l
Matching Defaults entries for erkdk on my-lab:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin, use_pty

User erkdk may run the following commands on my-lab:
    (ALL : ALL) ALL
    (ALL) NOPASSWD: ALL
erkdk@my-lab:~$ 
```

user can: ```run ANY command as root WITHOUT password```  i.e Full root access without authentication. (critical misconfiguration, equivalent to root login)

