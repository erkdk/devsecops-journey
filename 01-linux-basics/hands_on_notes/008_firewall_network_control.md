#### Firewall & Network Control (REAL DEFENSE)
##### Scenario:
- “Your server is exposed to the internet. You must restrict access, detect attacks, and protect services.”

##### Baseline (Understand current exposure)
1. Check open ports (before firewall: ``sudo ss -tulnp``)
```
erkdk@my-lab:~$ sudo ss -tulnp

Netid        State         Recv-Q        Send-Q                       Local Address:Port               Peer Address:Port       Process                                                       
udp          UNCONN        0             0                               127.0.0.54:53                      0.0.0.0:*           users:(("systemd-resolve",pid=1257,fd=16))                   
udp          UNCONN        0             0                            127.0.0.53%lo:53                      0.0.0.0:*           users:(("systemd-resolve",pid=1257,fd=14))                   
udp          UNCONN        0             0                    192.168.200.88%enp1s0:68                      0.0.0.0:*           users:(("systemd-network",pid=653,fd=22))                    
tcp          LISTEN        0             4096                         127.0.0.53%lo:53                      0.0.0.0:*           users:(("systemd-resolve",pid=1257,fd=15))                   
tcp          LISTEN        0             4096                            127.0.0.54:53                      0.0.0.0:*           users:(("systemd-resolve",pid=1257,fd=17))                   
tcp          LISTEN        0             4096                               0.0.0.0:22                      0.0.0.0:*           users:(("sshd",pid=997,fd=3),("systemd",pid=1,fd=156))       
tcp          LISTEN        0             4096                                  [::]:22                         [::]:*           users:(("sshd",pid=997,fd=4),("systemd",pid=1,fd=157))       
erkdk@my-lab:~$ 
```
- port 22 → SSH ( [IPv4]: ``0.0.0.0: 22`` or [IPv6]: ``[::]:22 ``, so port 22 is open to every network interface(local and external))

---
2. Check if firewall exists(``sudo ufw status verbose``)
```
erkdk@my-lab:~$ sudo ufw status verbose
Status: inactive
erkdk@my-lab:~$ 
```
- inactive → ❗ dangerous (default state in many systems)

##### Enable firewall safely (CRITICAL: ``sudo ufw allow 22/tcp``)
- BEFORE enabling firewall:
- ALWAYS allow SSH first (or you will lock yourself out)
```
erkdk@my-lab:~$ sudo ufw allow 22/tcp
Rules updated
Rules updated (v6)
erkdk@my-lab:~$

erkdk@my-lab:~$ sudo ufw default deny incoming
Default incoming policy changed to 'deny'
(be sure to update your rules accordingly)
erkdk@my-lab:~$ 

erkdk@my-lab:~$ sudo ufw default allow outgoing
Default outgoing policy changed to 'allow'
(be sure to update your rules accordingly)
erkdk@my-lab:~$ 

erkdk@my-lab:~$ sudo ufw status verbose
Status: inactive
```

---
3. Enable firewall (``sudo ufw enable`` and verify: ``sudo ufw status numbered``)
```
erkdk@my-lab:~$ sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
erkdk@my-lab:~$ 

erkdk@my-lab:~$ sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere                  
22/tcp (v6)                ALLOW IN    Anywhere (v6)             

erkdk@my-lab:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    Anywhere                  
[ 2] 22/tcp (v6)                ALLOW IN    Anywhere (v6)             

erkdk@my-lab:~$ 
```
- Understand default policy: deny incoming (❌) and allow outgoing (✅)


---
##### Controlled exposure (real-world)
4. Allow your app (port 8080: ``sudo ufw allow 8080/tcp``)
```
erkdk@my-lab:~$  python3 -m http.server 8080
Serving HTTP on 0.0.0.0 port 8080 (http://0.0.0.0:8080/) ...

erkdk@my-lab:~$ ss -tulnp
Netid   State    Recv-Q    Send-Q               Local Address:Port       Peer Address:Port   Process                                                                                      
...                                                                                                  
tcp     LISTEN   0         5                          0.0.0.0:8080            0.0.0.0:*       users:(("python3",pid=3083,fd=3))                                                           
...                                                                                               
erkdk@my-lab:~$ 

erkdk@my-lab:~$ sudo ufw allow 8080/tcp
Rule added
Rule added (v6)

erkdk@my-lab:~$ sudo ufw allow 8080/tcp
Skipping adding existing rule
Skipping adding existing rule (v6)
erkdk@my-lab:~$
```

---
5. Test externally (from host machine: ``curl http://<VM-IP>:8080``)
```
aadarkdk@pop-os:~$ curl -I http://192.168.200.88:8080
HTTP/1.0 200 OK
Server: SimpleHTTP/0.6 Python/3.12.3
Date: Wed, 01 Apr 2026 12:53:44 GMT
Content-type: text/html; charset=utf-8
Content-Length: 778
aadarkdk@pop-os:~$ 
```
- It worked ✅

---
6. Block the app (``sudo ufw deny 8080/tcp`` and Test again: ``curl http://<VM-IP>:8080``)
```
erkdk@my-lab:~$ sudo ufw deny 8080/tcp
Rule updated
Rule updated (v6)
erkdk@my-lab:~$ 

erkdk@my-lab:~$ sudo ufw status numbered
Status: active
     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    Anywhere                  
[ 2] 8080/tcp                   DENY IN     Anywhere                  
[ 3] 22/tcp (v6)                ALLOW IN    Anywhere (v6)             
[ 4] 8080/tcp (v6)              DENY IN     Anywhere (v6)             
erkdk@my-lab:~$ 

aadarkdk@pop-os:~$ curl -I --connect-timeout 5 http://192.168.200.88:8080
curl: (28) Connection timeout after 5004 ms
aadarkdk@pop-os:~$
```
- It failed!
##### Lesson:
- firewall = traffic filter
- service running doesn't mean accessible
- UFW ( Uncomplicated Firewall) evaluates rules top → down ( First match wins )

---
##### Attack simulation
7. Simulate port scanning (attacker behavior)
```
aadarkdk@pop-os:~$ nmap 192.168.200.88
Starting Nmap 7.80 ( https://nmap.org ) at 2026-04-01 19:03 +0545
Note: Host seems down. If it is really up, but blocking our ping probes, try -Pn
Nmap done: 1 IP address (0 hosts up) scanned in 3.03 seconds

aadarkdk@pop-os:~$ nmap -Pn 192.168.200.88				(-Pn -> No Ping)
Starting Nmap 7.80 ( https://nmap.org ) at 2026-04-01 19:08 +0545
Nmap scan report for 192.168.200.88
Host is up (0.00057s latency).
Not shown: 999 filtered ports
PORT   STATE SERVICE
22/tcp open  ssh
Nmap done: 1 IP address (1 host up) scanned in 4.29 seconds
aadarkdk@pop-os:~$ 
```
- Observe: ( Before firewall → all listening ports are reachable & After firewall → only allowed ports are reachable )
##### note: 
- Attackers always:( scan ports, identify services and exploit exposed ones)

---
##### Restrict SSH (production-grade)
8. Allow SSH only from trusted IP ( ``sudo ufw allow from <YOUR-IP> to any port 22`` )
```
erkdk@my-lab:~$ sudo ufw allow from 192.168.200.2 to any port 22
Rule added
erkdk@my-lab:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    Anywhere                  
[ 2] 8080/tcp                   DENY IN     Anywhere                  
[ 3] 22                         ALLOW IN    192.168.200.2             
[ 4] 22/tcp (v6)                ALLOW IN    Anywhere (v6)             
[ 5] 8080/tcp (v6)              DENY IN     Anywhere (v6)             
```

- Then remove open rule: ( ``sudo ufw delete allow 22/tcp`` ):
```
erkdk@my-lab:~$ sudo ufw delete 1
Deleting:
 allow 22/tcp
Proceed with operation (y|n)? y
Rule deleted
erkdk@my-lab:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 8080/tcp                   DENY IN     Anywhere                  
[ 2] 22                         ALLOW IN    192.168.200.2             
[ 3] 22/tcp (v6)                ALLOW IN    Anywhere (v6)             
[ 4] 8080/tcp (v6)              DENY IN     Anywhere (v6)             

erkdk@my-lab:~$ sudo ufw delete 3
Deleting:
 allow 22/tcp
Proceed with operation (y|n)? y
Rule deleted (v6)
erkdk@my-lab:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 8080/tcp                   DENY IN     Anywhere                  
[ 2] 22                         ALLOW IN    192.168.200.2            
[ 3] 8080/tcp (v6)              DENY IN     Anywhere (v6)             

erkdk@my-lab:~$

(from host):

aadarkdk@pop-os:~$ nmap -Pn 192.168.200.88
Starting Nmap 7.80 ( https://nmap.org ) at 2026-04-01 20:31 +0545
Nmap scan report for 192.168.200.88
Host is up (0.00056s latency).
Not shown: 999 filtered ports
PORT   STATE SERVICE
22/tcp open  ssh

Nmap done: 1 IP address (1 host up) scanned in 6.59 seconds
aadarkdk@pop-os:~$
```
- Only allowed source IPs can reach SSH (as per firewall rules)
- Others are blocked

---
##### Rate limiting (anti-brute-force)
9. Enable SSH rate limiting ( ``sudo ufw limit 22/tcp``)
```
erkdk@my-lab:~$ sudo ufw limit 22/tcp
Rule added
Rule added (v6)
erkdk@my-lab:~$ 

erkdk@my-lab:~$ sudo ufw status numbered
Status: active
     To                         Action      From
     --                         ------      ----           
[ 5] 22/tcp (v6)                LIMIT IN    Anywhere (v6)  
```
- Note: Production approach:
```
limit 22/tcp (global)
allow from trusted IP (optional stricter layer)
```

##### What it does:
- blocks repeated rapid attempts
- protects from brute-force attacks

---
##### Logging & monitoring
10. Enable logging ( ``sudo ufw logging on`` and Check logs: ``sudo tail -f /var/log/ufw.log`` )
```
erkdk@my-lab:~$ sudo ufw logging on
Logging enabled
erkdk@my-lab:~$ 

erkdk@my-lab:~$ sudo tail -f /var/log/ufw.log

```
- see:
blocked IPs
denied ports
attack attempts

---
11. Debugging: Reset firewall (safe recovery: ``sudo ufw reset``)
```
erkdk@my-lab:~$ sudo ufw reset

Resetting all rules to installed defaults. This may disrupt existing ssh
connections. Proceed with operation (y|n)? y
Backing up 'user.rules' to '/etc/ufw/user.rules.20260401_155204'
Backing up 'before.rules' to '/etc/ufw/before.rules.20260401_155204'
Backing up 'after.rules' to '/etc/ufw/after.rules.20260401_155204'
Backing up 'user6.rules' to '/etc/ufw/user6.rules.20260401_155204'
Backing up 'before6.rules' to '/etc/ufw/before6.rules.20260401_155204'
Backing up 'after6.rules' to '/etc/ufw/after6.rules.20260401_155204'

erkdk@my-lab:~$ sudo ufw status numbered 
Status: inactive
erkdk@my-lab:~$ 
```

---
12. Rebuild minimal secure config
```
erkdk@my-lab:~$ sudo ufw default deny incoming
Default incoming policy changed to 'deny'
(be sure to update your rules accordingly)
erkdk@my-lab:~$ sudo ufw default allow outgoing
Default outgoing policy changed to 'allow'
(be sure to update your rules accordingly)
erkdk@my-lab:~$ sudo ufw allow 22/tcp
Rules updated
Rules updated (v6)
erkdk@my-lab:~$ sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
erkdk@my-lab:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    Anywhere                  
[ 2] 22/tcp (v6)                ALLOW IN    Anywhere (v6)             

erkdk@my-lab:~$ 
```
---
##### Common mistakes to avoid:
- enabling firewall without SSH rule → lockout
- opening all ports → useless firewall
- ignoring logs → blind system

---
##### When service not reachable:
```
1. ss -tulnp
2. systemctl status <service>
3. ufw status
4. curl localhost:<port>
5. curl <ip>:<port>
```

---
##### Are you able to know or implement?
- Attack surface control
- Port-level security
- Traffic filtering
- Basic intrusion defense

##### IPTABLES (LOW-LEVEL FIREWALL)
- How UFW actually works internally
- packet filtering chains
- NAT
- container networking base

##### explain?
- why port is blocked
- how firewall interacts with service
- how attacker scans system

---
