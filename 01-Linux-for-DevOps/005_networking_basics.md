### Networking

- Scenario: 
“A service is not reachable. You must debug the network.”

---
1. Identify network configuration ( Find: Your IP address, Network interface name, Default gateway )
```
erkdk@my-lab:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:86:bc:78 brd ff:ff:ff:ff:ff:ff
    inet 192.168.200.88/24 metric 100 brd 192.168.100.255 scope global dynamic enp1s0
       valid_lft 2610sec preferred_lft 2610sec
    inet6 fe80::5054:ff:fe86:bc78/64 scope link 
       valid_lft forever preferred_lft forever
erkdk@my-lab:~$ 
```
```
erkdk@my-lab:~$ ip route
default via 192.168.200.2 dev enp1s0 proto dhcp src 192.168.200.88 metric 100 
192.168.200.0/24 dev enp1s0 proto kernel scope link src 192.168.200.88 metric 100 
192.168.200.2 dev enp1s0 proto dhcp scope link src 192.168.200.88 metric 100 
```
- ``lo``: loopback used for internal connection, IPC
- ``enp1s0``(Network interface name): ethernet interface
- IP address: ``192.168.200.88``
- Default gateway: `` 192.168.200.2``

---
2. DNS configuration ( Find: Which DNS server you are using)
```
erkdk@my-lab:~$ resolvectl status
Global
         Protocols: -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
  resolv.conf mode: stub

Link 2 (enp1s0)
    Current Scopes: DNS
         Protocols: +DefaultRoute -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
Current DNS Server: 192.168.200.2
       DNS Servers: 192.168.200.2
erkdk@my-lab:~$ 
```
- DNS server: ``192.168.200.2``

---
3. Connectivity test ( Test: Ping your host machine, Ping public IP (8.8.8.8), Ping domain (google.com) )
```
erkdk@my-lab:~$ ping -c 4 192.168.200.88			(IP of current vm itself)
PING 192.168.200.88 (192.168.200.88) 56(84) bytes of data.
64 bytes from 192.168.200.88: icmp_seq=1 ttl=64 time=0.073 ms
64 bytes from 192.168.200.88: icmp_seq=2 ttl=64 time=0.048 ms
64 bytes from 192.168.200.88: icmp_seq=3 ttl=64 time=0.044 ms
64 bytes from 192.168.200.88: icmp_seq=4 ttl=64 time=0.043 ms

--- 192.168.200.88 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3104ms
rtt min/avg/max/mdev = 0.043/0.052/0.073/0.012 ms

erkdk@my-lab:~$ ping -c 4 192.168.200.2					(host-machine)
PING 192.168.200.2 (192.168.200.2) 56(84) bytes of data.
64 bytes from 192.168.200.2: icmp_seq=1 ttl=64 time=0.227 ms
64 bytes from 192.168.200.2: icmp_seq=2 ttl=64 time=0.386 ms
64 bytes from 192.168.200.2: icmp_seq=3 ttl=64 time=0.479 ms
64 bytes from 192.168.200.2: icmp_seq=4 ttl=64 time=0.322 ms

--- 192.168.200.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3091ms
rtt min/avg/max/mdev = 0.227/0.353/0.479/0.091 ms

erkdk@my-lab:~$ ping -c 4 8.8.8.8					(public IP)
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=114 time=20.5 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=114 time=24.2 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=114 time=21.2 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=114 time=21.0 ms

--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3006ms
rtt min/avg/max/mdev = 20.466/21.734/24.241/1.472 ms

erkdk@my-lab:~$ ping -c 4 google.com					(google.com)
PING google.com (142.250.183.206) 56(84) bytes of data.
64 bytes from tzdela-am-in-f14.1e100.net (142.250.183.206): icmp_seq=1 ttl=115 time=22.4 ms
64 bytes from tzdela-am-in-f14.1e100.net (142.250.183.206): icmp_seq=2 ttl=115 time=20.2 ms
64 bytes from tzdela-am-in-f14.1e100.net (142.250.183.206): icmp_seq=3 ttl=115 time=36.6 ms
64 bytes from tzdela-am-in-f14.1e100.net (142.250.183.206): icmp_seq=4 ttl=115 time=29.7 ms

--- google.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3006ms
rtt min/avg/max/mdev = 20.160/27.218/36.629/6.467 ms
erkdk@my-lab:~$ 
```

---
4. Port & service inspection ( Find: Which ports are open, Which service is listening on port 22 (SSH) )
```
erkdk@my-lab:~$ sudo ss -tulnp
Netid       State         Recv-Q        Send-Q                       Local Address:Port               Peer Address:Port       Process                                                        
udp         UNCONN        0             0                               127.0.0.54:53                      0.0.0.0:*           users:(("systemd-resolve",pid=538,fd=16))                     
udp         UNCONN        0             0                            127.0.0.53%lo:53                      0.0.0.0:*           users:(("systemd-resolve",pid=538,fd=14))                     
udp         UNCONN        0             0                    192.168.100.87%enp1s0:68                      0.0.0.0:*           users:(("systemd-network",pid=653,fd=11))                     
tcp         LISTEN        0             4096                         127.0.0.53%lo:53                      0.0.0.0:*           users:(("systemd-resolve",pid=538,fd=15))                     
tcp         LISTEN        0             4096                               0.0.0.0:22                      0.0.0.0:*           users:(("sshd",pid=1032,fd=3),("systemd",pid=1,fd=210))       
tcp         LISTEN        0             4096                            127.0.0.54:53                      0.0.0.0:*           users:(("systemd-resolve",pid=538,fd=17))                     
tcp         LISTEN        0             4096                                  [::]:22                         [::]:*           users:(("sshd",pid=1032,fd=4),("systemd",pid=1,fd=211))       
erkdk@my-lab:~$ 

erkdk@my-lab:~$ sudo ss -tulnp | grep :22
tcp   LISTEN 0      4096                 0.0.0.0:22        0.0.0.0:*    users:(("sshd",pid=1032,fd=3),("systemd",pid=1,fd=210))
tcp   LISTEN 0      4096                    [::]:22           [::]:*    users:(("sshd",pid=1032,fd=4),("systemd",pid=1,fd=211))
erkdk@my-lab:~$ 
```
- ports:
| Port | Protocol | Purpose     |
| ---- | -------- | ----------- |
| 22   | TCP      | SSH         |
| 53   | TCP/UDP  | DNS         |
| 68   | UDP      | DHCP client |

- on port 22: ``sshd`` service is listening and ``systemd``: opened socket(socket activation)

5. Process ↔ port mapping  ( Find: Which process is using a specific port )
- port: 22(SSH connection), process: ``sshd``, pid: ``1032``, fd(file-descriptor given by kernel i.e an index into process’s open file table): ``210``,\
  scope: ``0.0.0.0 and [::]``(accepts any connections from IPv4 or IPv6 address that can reach this vm)
- port: 53(DNS), process: ``systemd-resolve``, pid: ``538``, fd: ``16``
- port: 68(DHCP), process: ``systemd-network``, pid: ``653``, fd: ``11``

---
6. Simulate service ( Run: python3 -m http.server 8080 ( Then: Access it from host machine (browser or curl), Verify connection) )
```
erkdk@my-lab:~$ python3 -m http.server 8080
Serving HTTP on 0.0.0.0 port 8080 (http://0.0.0.0:8080/) ...

(after curl from browser and host machine)
aadarkdk@pop-os:~$ curl -I http://192.168.200.88:8080
HTTP/1.0 200 OK
Server: SimpleHTTP/0.6 Python/3.12.3
Date: Mon, 23 Mar 2026 02:53:36 GMT
Content-type: text/html; charset=utf-8
Content-Length: 778

erkdk@my-lab:~$ python3 -m http.server 8080
Serving HTTP on 0.0.0.0 port 8080 (http://0.0.0.0:8080/) ...
192.168.200.2 - - [23/Mar/2026 02:47:52] "GET / HTTP/1.1" 200 -
192.168.200.2 - - [23/Mar/2026 02:53:36] "HEAD / HTTP/1.1" 200 -
```
- ``0.0.0.0`` - listens on all interfaces (here ``lo``(internal loopback) and ``enp1s0``(external)

---
7. Debug connection ( From VM: curl localhost:8080 )
```
erkdk@my-lab:~$ curl localhost:8080			(localhost: 127.0.0.1)
<!DOCTYPE HTML>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Directory listing for /</title>
</head>
<body>
<h1>Directory listing for /</h1>
<hr>
<ul>
<li><a href=".bash_history">.bash_history</a></li>
<li><a href=".bash_logout">.bash_logout</a></li>
<li><a href=".bashrc">.bashrc</a></li>
<li><a href=".cache/">.cache/</a></li>
<li><a href=".config/">.config/</a></li>
<li><a href=".gitconfig">.gitconfig</a></li>
<li><a href=".lesshst">.lesshst</a></li>
<li><a href=".local/">.local/</a></li>
<li><a href=".profile">.profile</a></li>
<li><a href=".ssh/">.ssh/</a></li>
<li><a href=".sudo_as_admin_successful">.sudo_as_admin_successful</a></li>
<li><a href=".viminfo">.viminfo</a></li>
<li><a href="devops-journey/">devops-journey/</a></li>
</ul>
<hr>
</body>
</html>

erkdk@my-lab:~$ curl -I localhost:8080
HTTP/1.0 200 OK
Server: SimpleHTTP/0.6 Python/3.12.3
Date: Mon, 23 Mar 2026 03:13:55 GMT
Content-type: text/html; charset=utf-8
Content-Length: 778
```
---
