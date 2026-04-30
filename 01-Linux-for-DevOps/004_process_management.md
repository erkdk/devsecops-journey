### Process Management (REAL SYSTEM DEBUGGING)

- Scenario:
“A production server is slow. You must find and fix the issue.”

1. Create background processes: (sleep 1100 &, sleep 900 &, sleep 400 &)
```
erkdk@my-lab:~$ sleep 1100 &
[1] 2201
erkdk@my-lab:~$ sleep 900 &
[2] 2202
erkdk@my-lab:~$ sleep 400 &
[3] 2203
erkdk@my-lab:~$ 
```

---
2. Process inspection (find: All running processes, PID of your sleep processes, Parent process (PPID))
```
erkdk@my-lab:~$ ps -ef
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 05:02 ?        00:00:01 /sbin/init
...		
```
```
erkdk@my-lab:~$ ps -ef | grep sleep
erkdk       2300    1022  0 10:45 pts/0    00:00:00 grep --color=auto sleep
```

---
3. Resource monitoring (identify: Top CPU-consuming process, Top memory-consuming process)
```
erkdk@my-lab:~$ ps aux --sort=-%cpu | head -n 5
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         387  0.0  0.9 288952 27292 ?        SLsl 05:03   0:01 /sbin/multipathd -d -s
root           1  0.0  0.4  22260 13460 ?        Ss   05:02   0:01 /sbin/init
root        2293  0.0  0.0      0     0 ?        I    10:40   0:00 [kworker/u6:0-events_unbound]
erkdk       1019  0.0  0.2  15124  7196 ?        S    05:03   0:00 sshd: erkdk@pts/0

erkdk@my-lab:~$ ps aux --sort=-%mem | head -n 5
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root        2319  0.2  1.4 552188 42012 ?        Ssl  10:58   0:00 /usr/libexec/fwupd/fwupd
root         387  0.0  0.9 288952 27292 ?        SLsl 05:03   0:02 /sbin/multipathd -d -s
root         754  0.0  0.7 110012 23124 ?        Ssl  05:03   0:00 /usr/bin/python3 /usr/share/unattended-upgrades/unattended-upgrade-shutdown --wait-for-signal
root         339  0.0  0.5  66764 17632 ?        S<s  05:03   0:00 /usr/lib/systemd/systemd-journald
erkdk@my-lab:~$ 
```

--- 
4. Process tree (visualize: Which process started what)
```
erkdk@my-lab:~$ pstree -p
systemd(1)─┬─ModemManager(783)─┬─{ModemManager}(806)
           │                   ├─{ModemManager}(810)
           │                   └─{ModemManager}(815)
           ├─agetty(788)
           ├─agetty(826)
           ├─cron(695)
           ├─dbus-daemon(696)
           ├─multipathd(383)─┬─{multipathd}(398)
           │                 ├─{multipathd}(399)
           │                 ├─{multipathd}(400)
           │                 ├─{multipathd}(401)
           │                 ├─{multipathd}(402)
           │                 └─{multipathd}(403)
           ├─polkitd(706)─┬─{polkitd}(765)
           │              ├─{polkitd}(766)
           │              └─{polkitd}(767)
           ├─rsyslogd(756)─┬─{rsyslogd}(820)
           │               ├─{rsyslogd}(821)
           │               └─{rsyslogd}(822)
           ├─sshd(904)───sshd(906)───sshd(1026)───bash(1027)───pstree(1069)
           ├─systemd(917)───(sd-pam)(918)
           ├─systemd-journal(338)
           ├─systemd-logind(713)
           ├─systemd-network(646)
           ├─systemd-resolve(536)
           ├─systemd-timesyn(543)───{systemd-timesyn}(579)
           ├─systemd-udevd(397)
           ├─udisksd(726)─┬─{udisksd}(729)
           │              ├─{udisksd}(732)
           │              ├─{udisksd}(735)
           │              ├─{udisksd}(781)
           │              └─{udisksd}(791)
           └─unattended-upgr(800)───{unattended-upgr}(856)
```

---
5. Kill process safely (Kill: one sleep process)
```
erkdk@my-lab:~$ ps
    PID TTY          TIME CMD
   1022 pts/0    00:00:00 bash
   2201 pts/0    00:00:00 sleep
   2202 pts/0    00:00:00 sleep
   2218 pts/0    00:00:00 ps
[3]+  Done                    sleep 400

erkdk@my-lab:~$ kill 2201				(i.e. SIGTERM (15) --> graceful shutdown)

erkdk@my-lab:~$ ps
    PID TTY          TIME CMD
   1022 pts/0    00:00:00 bash
   2202 pts/0    00:00:00 sleep
   2219 pts/0    00:00:00 ps
[1]-  Terminated              sleep 1100
erkdk@my-lab:~$ 
```

---
6. Force kill (simulate stuck process) (Kill another using: stronger signal)
```
erkdk@my-lab:~$ ps
    PID TTY          TIME CMD
   1022 pts/0    00:00:00 bash
   2202 pts/0    00:00:00 sleep
   2225 pts/0    00:00:00 sleep
   2227 pts/0    00:00:00 ps
   
erkdk@my-lab:~$ kill -9 2225				(SIGKILL (9)  --> force kill, can corrupt data)
[2]-  Done                    sleep 900

erkdk@my-lab:~$ ps
    PID TTY          TIME CMD
   1022 pts/0    00:00:00 bash
   2228 pts/0    00:00:00 ps
[3]+  Killed                  sleep 300
erkdk@my-lab:~$ 
```

---
7. Real-world debugging (find: SSH process handling your session)
```
erkdk@my-lab:~$ ps -ef | grep sshd
root         904       1  0 05:00 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root         906     904  0 05:00 ?        00:00:00 sshd: erkdk [priv]
erkdk       1026     906  0 05:00 ?        00:00:00 sshd: erkdk@pts/0
erkdk       1071    1027  0 05:13 pts/0    00:00:00 grep --color=auto sshd

erkdk@my-lab:~$ pstree -p | grep sshd
           |-sshd(904)---sshd(906)---sshd(1026)---bash(1027)-+-grep(1074)

erkdk@my-lab:~$ echo $$
1027

erkdk@my-lab:~$ ps -p 1027 -o ppid
   PPID
   1026

erkdk@my-lab:~$ pstree -p $$
bash(1027)───pstree(1170)
```
- 904 	--> 	main SSH daemon [listener]
- 906 	--> 	auth process [priv]
- 1026 	--> 	user session 
- 1027  --> 	shell
- 1170  -->	command

---
---
8. Simulate high CPU (Then: Find it, Kill it safely)
```
erkdk@my-lab:~$ yes > /dev/null &
[1] 1215

erkdk@my-lab:~$ ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
....	    .... ...   ...   ...   ...  ...      ...  ...     ...  ... 
erkdk       1215 99.7  0.0   6112  1912 pts/0    R    06:10   0:08 yes
erkdk       1217  0.0  0.1  11320  4508 pts/0    R+   06:10   0:00 ps aux

erkdk@my-lab:~$ kill 1215

erkdk@my-lab:~$ ps -p 1215
    PID TTY          TIME CMD

erkdk@my-lab:~$ htop
[1]+  Terminated              yes > /dev/null
```

---
9. Process priority (Run: ``nice -n 10 sleep 500 &``)
```
erkdk@my-lab:~$ nice -n 10 sleep 500 &
[1] 2380

erkdk@my-lab:~$ ps -o pid,ni,stat,comm -p 2380
    PID  NI STAT COMMAND
   2380  10 SN   sleep
```
- What changed?\
---> NI(Nice Value) = 10 and STAT = SN (sleep) so allows other high priority process to run and itself get low priority 
(note: nice value range -19(high priority) to 20(low priotiry))

- Why is this important?\
---> because ``nice`` affects CPU Scheduling priority (higher nice, less CPU share and lower nice, more CPU share).

---
10. Zombie process (concept + observe)
```
erkdk@my-lab:~$ ps aux | grep Z
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
erkdk       2413  0.0  0.0   7076  2220 pts/0    S+   06:53   0:00 grep --color=auto Z
[1]+  Done                    nice -n 10 sleep 500
```
- What is a zombie process?
---> process that has finished execution but still has an entry on the process table.
     parent has NOT read child exit status (wait())

---
11. Open files by process (Find:``lsof -p <PID>``)
```
erkdk@my-lab:~$ sleep 100 &
[1] 2431
erkdk@my-lab:~$ lsof -p 2431
COMMAND  PID  USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME
sleep   2431 erkdk  cwd    DIR  253,1     4096 262145 /home/erkdk
sleep   2431 erkdk  rtd    DIR  253,1     4096      2 /
sleep   2431 erkdk  txt    REG  253,1    35336   2005 /usr/bin/sleep
sleep   2431 erkdk  mem    REG  253,1  3055776   7750 /usr/lib/locale/locale-archive
sleep   2431 erkdk  mem    REG  253,1  2125328   6493 /usr/lib/x86_64-linux-gnu/libc.so.6
sleep   2431 erkdk  mem    REG  253,1   360460   7756 /usr/lib/locale/C.utf8/LC_CTYPE
sleep   2431 erkdk  mem    REG  253,1       50   7761 /usr/lib/locale/C.utf8/LC_NUMERIC
sleep   2431 erkdk  mem    REG  253,1     3360   7764 /usr/lib/locale/C.utf8/LC_TIME
sleep   2431 erkdk  mem    REG  253,1     1406   7755 /usr/lib/locale/C.utf8/LC_COLLATE
sleep   2431 erkdk  mem    REG  253,1      270   7759 /usr/lib/locale/C.utf8/LC_MONETARY
sleep   2431 erkdk  mem    REG  253,1       48   7753 /usr/lib/locale/C.utf8/LC_MESSAGES/SYS_LC_MESSAGES
sleep   2431 erkdk  mem    REG  253,1    27028   5419 /usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache
sleep   2431 erkdk  mem    REG  253,1       34   7762 /usr/lib/locale/C.utf8/LC_PAPER
sleep   2431 erkdk  mem    REG  253,1       62   7760 /usr/lib/locale/C.utf8/LC_NAME
sleep   2431 erkdk  mem    REG  253,1      127   7754 /usr/lib/locale/C.utf8/LC_ADDRESS
sleep   2431 erkdk  mem    REG  253,1       47   7763 /usr/lib/locale/C.utf8/LC_TELEPHONE
sleep   2431 erkdk  mem    REG  253,1       23   7758 /usr/lib/locale/C.utf8/LC_MEASUREMENT
sleep   2431 erkdk  mem    REG  253,1      258   7757 /usr/lib/locale/C.utf8/LC_IDENTIFICATION
sleep   2431 erkdk  mem    REG  253,1   236616   6490 /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
sleep   2431 erkdk    0u   CHR  136,0      0t0      3 /dev/pts/0
sleep   2431 erkdk    1u   CHR  136,0      0t0      3 /dev/pts/0
sleep   2431 erkdk    2u   CHR  136,0      0t0      3 /dev/pts/0
erkdk@my-lab:~$ 
```
- What files does a process use?
- ``txt → /usr/bin/sleep`` : executable file
￼
- ``cwd → /home/erkdk`` : current working directory
￼
- ``0,1,2 → /dev/pts/0`` : stdin, stdout, stderr

---
