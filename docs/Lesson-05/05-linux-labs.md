# Lesson 5 Exercises

This section documents exercises from lesson 5

---

## Scenario: "Detective in the Network World"
### Exercise 1
In this exercise, I had to run a simple web server using Python's built-in module and investigate how the network handles requests.

### Task Steps

1. Create a directory named `my-server`.
2. Write into `index.html` using the `echo` command: `<h1>Congratulations! You found the server!</h1>`.
3. Run the server on port 8080: `python3 -m http.server 8080`.
4. Check the server via localhost: `curl http://localhost:8080`.
5. Check the server via my private IP: `curl http://<MY_IP>:8080`.
6. Use `ss -tulpn | grep 8080` to see which process listens on this port.

---

### Execution & Outputs

#### 1. Starting the Server
I created the directory and started the Python server on port 8080:

Output:

```bash
sane@power-sane:~/my-server$ python3 -m http.server 8080
Serving HTTP on 0.0.0.0 port 8080 (http://0.0.0.0:8080/) ...
```

Note: 0.0.0.0 means the server listens on all available network interfaces.


2. Testing via Localhost

In a second terminal window, I checked the server using localhost and its IP equivalent 127.0.0.1:

```bash
sane@power-sane:~/my-server$ curl http://localhost:8080
<h1>Congratulations! You have found a server!</h1>
```
```bash
sane@power-sane:~/my-server$ curl [http://127.0.0.1:8080]
<h1>Congratulations! You have found a server!</h1>
```

Server log for localhost requests:

```bash
127.0.0.1 - - [30/May/2026 14:47:24] "GET / HTTP/1.1" 200 -
127.0.0.1 - - [30/May/2026 14:47:52] "GET / HTTP/1.1" 200 -
```
3. Testing via Private IP

Next, I checked my private Wi-Fi IP address using ifconfig (which was 192.168.1.78) and sent a request to it:

```bash
sane@power-sane:~/my-server$ curl http://192.168.1.78:8080
<h1>Congratulations! You have found a server!</h1>
```

Server log for the private IP request:

```bash
192.168.1.78 - - [30/May/2026 14:49:42] "GET / HTTP/1.1" 200 -
```

4. Checking the Process (ss command)

To see what process is listening on port 8080, I used the ss command:

```bash
ss -tulpn | grep 8080
```

Output:

```bash
tcp   LISTEN 0      5            0.0.0.0:8080       0.0.0.0:* users:(("python3",pid=12345,fd=3))
```

My Notes & Conclusions

On what address does the server work? The server runs on 0.0.0.0:8080. This means it accepts connections from any network interface on my computer.

What is the difference between localhost and private IP?

localhost (127.0.0.1): This is a virtual internal loop. The traffic never leaves my computer and stays inside the operating system. In the server logs, it shows up as 127.0.0.1.

Private IP (192.168.1.78): This is the actual IP address assigned to my Wi-Fi network card by the router. When I use this IP, the traffic goes through the real network stack. In the server logs, it shows my specific network IP instead of the loopback address.

---

## "Port Battle"
### Exercise 2

The objective of this exercise is to run two servers in separate terminals on the same port (8080), analyze the resulting conflict, identify the process occupying the port using system utilities, and resolve the issue by using an alternative port.

To trigger the conflict, I ran the following command in a second terminal:

```bash
cd /tmp && python3 -m http.server 8080
```

Output:

```bash
sane@power-sane:~/first-devops-project$ cd /tmp && python3 -m http.server 8080
Traceback (most recent call last):
  File "<frozen runpy>", line 198, in _run_module_as_main
  File "<frozen runpy>", line 88, in _run_code
  File "/usr/lib/python3.12/http/server.py", line 1314, in <module>
    test(
  File "/usr/lib/python3.12/http/server.py", line 1261, in test
    with ServerClass(addr, HandlerClass) as httpd:
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/socketserver.py", line 457, in __init__
    self.server_bind()
  File "/usr/lib/python3.12/http/server.py", line 1308, in server_bind
    return super().server_bind()
           ^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.12/http/server.py", line 136, in server_bind
    socketserver.TCPServer.server_bind(self)
  File "/usr/lib/python3.12/socketserver.py", line 473, in server_bind
    self.socket.bind(self.server_address)
OSError: [Errno 98] Address already in use
```
### 1. Observing the Error

At first glance, the output displays a standard Python traceback, but the crucial information is at the very end: OSError: [Errno 98] Address already in use. As expected, two processes cannot occupy the same network port simultaneously.

### 2. Where the error occured.

The traceback shows that the execution failed at this specific line:

```bash
File "/usr/lib/python3.12/socketserver.py", line 473, in server_bind
    self.socket.bind(self.server_address)
```

Python attempted to bind to port 8080, but the system call failed and terminated the application because the port was already reserved.
### 3. System Call Traces

The remaining lines trace the execution path the program took before hitting the network conflict wall. The Python code itself is completely correct, but the server cannot start due to an environmental network conflict—port 8080 already has an "owner" in the system.

Investigating the Port with ss

To identify the process blocking the port, I ran the socket statistics command:

```bash
sane@power-sane:/tmp$ ss -tulpn | grep 8080
```

Output:

```bash
tcp   LISTEN 0      5            0.0.0.0:8080       0.0.0.0:*    users:(("python3",pid=103243,fd=3))
```

Output Breakdown:

    tcp: The protocol used by the server. HTTP traffic always operates over TCP.

    LISTEN: The socket state, meaning the server is actively listening and waiting for incoming connections.

    0.0.0.0:8080: The local address and port. 0.0.0.0 signifies that the server is listening on all available network interfaces.

    python3: The name of the application occupying the port.

    pid=103243: The unique Process ID assigned by the operating system.

This utility clearly indicates that the port is blocked by my first Python server session (PID 103243).

To resolve the port conflict, I launched the second server on a different, unassigned port (8081):

```bash
sane@power-sane:/tmp$ python3 -m http.server 8081
Serving HTTP on 0.0.0.0 port 8081 (http://0.0.0.0:8081/) ...
```

The second server started successfully because port 8081 was free and had no active bindings.

# "Network Connections Map"

## Exercise 3

The objective of this exercise is to observe outbound network connections generated by a web browser, isolate secure HTTPS traffic operating on port 443, and create a structured connection report.

### Task Steps
1. Open multiple websites in a browser.
2. Find active connections using `ss -tunaep` or `netstat -tunaep`.
3. Identify remote ports used for HTTPS (standard port 443).
4. Document the connections in a structured report format:
```text
Connection 1:
- Local IP address and port: 192.168.1.5:52431
- Remote IP address and port: 142.250.186.78:443
- Status? : ESTABLISHED
- Process: chrome
```

### Step 1: Initial Discovery

I executed the broad socket statistics command to see all active network sockets:

```bash
sane@power-sane:~/first-devops-project/docs$ ss -tunaep
Netid  State      Recv-Q   Send-Q              Local Address:Port        Peer Address:Port  Process                                                                                     
udp    UNCONN     0        0                         0.0.0.0:60269            0.0.0.0:*      uid:108 ino:3692 sk:b cgroup:/system.slice/avahi-daemon.service <->                        
udp    UNCONN     0        0                         0.0.0.0:46894            0.0.0.0:*      uid:1000 ino:868504 sk:35 cgroup:/user.slice/user-1000.slice/user@1000.service/app.slice/app-gnome-virtualbox-10991.scope <->
udp    UNCONN     0        0                      127.0.0.54:53               0.0.0.0:*      uid:991 ino:11002 sk:13 cgroup:/system.slice/systemd-resolved.service <->                  
udp    UNCONN     0        0                   127.0.0.53%lo:53               0.0.0.0:*      uid:991 ino:11000 sk:14 cgroup:/system.slice/systemd-resolved.service <->                  
udp    ESTAB      0        0          192.168.1.78%wlp0s20f3:68           192.168.1.1:67     ino:763698 sk:36 cgroup:/system.slice/NetworkManager.service <->                           
udp    ESTAB      0        0          192.168.1.81%enp0s31f6:68           192.168.1.1:67     ino:500665 sk:37 cgroup:/system.slice/NetworkManager.service <->                           
udp    UNCONN     0        0                         0.0.0.0:33265            0.0.0.0:*      uid:1000 ino:859570 sk:38 cgroup:/user.slice/user-1000.slice/user@1000.service/app.slice/app-gnome-virtualbox-10991.scope <->
udp    UNCONN     0        0                         0.0.0.0:50648            0.0.0.0:*      uid:1000 ino:864564 sk:39 cgroup:/user.slice/user-1000.slice/user@1000.service/app.slice/app-gnome-virtualbox-10991.scope <->
udp    UNCONN     0        0                         0.0.0.0:52535            0.0.0.0:*      uid:1000 ino:864565 sk:3a cgroup:/user.slice/user-1000.slice/user@1000.service/app.slice/app-gnome-virtualbox-10991.scope <->
udp    UNCONN     0        0                         0.0.0.0:54285            0.0.0.0:*      uid:1000 ino:867560 sk:3b cgroup:/user.slice/user-1000.slice/user@1000.service/app.slice/app-gnome-virtualbox-10991.scope <->
udp    UNCONN     0        0                         0.0.0.0:5353             0.0.0.0:*      uid:108 ino:3690 sk:20 cgroup:/system.slice/avahi-daemon.service <->                       
udp    UNCONN     0        0                         0.0.0.0:38332            0.0.0.0:*      users:(("firefox",pid=38575,fd=193)) uid:1000 ino:875528 sk:3c cgroup:/user.slice/user-1000.slice/user@1000.service/app.slice/snap.firefox.firefox-8d3f1834-c397-4085-b29d-3b2538c9ff4e.scope <->
udp    UNCONN     0        0                         0.0.0.0:54912            0.0.0.0:*      users:(("firefox",pid=38575,fd=189)) uid:1000 ino:874583 sk:3d cgroup:/user.slice/user-1000.slice/user@1000.service/app.slice/snap.firefox.firefox-8d3f1834-c397-4085-b29d-3b2538c9ff4e.scope <->
udp    UNCONN     0        0                         0.0.0.0:39587            0.0.0.0:*      users:(("firefox",pid=38575,fd=201)) uid:1000 ino:872098 sk:3e cgroup:/user.slice/user-1000.slice/user@1000.service/app.slice/snap.firefox.firefox-8d3f1834-c397-4085-b29d-3b2538c9ff4e.scope <->
udp    UNCONN     0        0                         0.0.0.0:39779            0.0.0.0:*      uid:1000 ino:862039 sk:3f cgroup:/user.slice/user-1000.slice/user@1000.service/app.slice/app-gnome-virtualbox-10991.scope <->
udp    UNCONN     0        0                            [::]:38042               [::]:*      uid:108 ino:3693 sk:2f cgroup:/system.slice/avahi-daemon.service v6only:1 <->              
udp    UNCONN     0        0                            [::]:5353                [::]:*      uid:108 ino:3691 sk:30 cgroup:/system.slice/avahi-daemon.service v6only:1 <->              
tcp    LISTEN     0        5                         0.0.0.0:8080             0.0.0.0:*      users:(("python3",pid=103243,fd=3)) uid:1000 ino:491894 sk:1017 cgroup:/user.slice/user-1000.slice/user@1000.service/app.slice/app-org.gnome.Terminal.slice/vte-spawn-352a31af-8e50-480f-948b-4f087f9ab0a8.scope <->
tcp    LISTEN     0        4096                   127.0.0.54:53               0.0.0.0:*      uid:991 ino:11003 sk:31 cgroup:/system.slice/systemd-resolved.service <->                  
tcp    LISTEN     0        4096                127.0.0.53%lo:53               0.0.0.0:*      uid:991 ino:11001 sk:32 cgroup:/system.slice/systemd-resolved.service <->                  
tcp    LISTEN     0        4096                    127.0.0.1:631              0.0.0.0:*      ino:680782 sk:1018 cgroup:/system.slice/cups.service <->                                   
tcp    TIME-WAIT  0        0                    192.168.1.81:43024      108.138.51.79:443    timer:(timewait,7.031ms,0) ino:0 sk:40                                                     
tcp    TIME-WAIT  0        0                    192.168.1.81:59312       91.189.92.23:80     timer:(timewait,7.069ms,0) ino:0 sk:41                                                     
tcp    ESTAB      0        0                    192.168.1.81:52172      34.107.243.93:443    users:(("firefox",pid=38575,fd=198)) timer:(keepalive,1min1sec,0) uid:1000 ino:820452 sk:42 cgroup:/user.slice/user-1000.slice/user@1000.service/app.slice/snap.firefox.firefox-8d3f1834-c397-4085-b29d-3b2538c9ff4e.scope <->
tcp    TIME-WAIT  0        0                    192.168.1.81:54336      216.58.207.14:443    timer:(timewait,7.039ms,0) ino:0 sk:43                                                     
tcp    ESTAB      0        0                    192.168.1.81:40626      140.82.112.25:443    users:(("firefox",pid=38575,fd=182)) timer:(keepalive,2min44sec,0) uid:1000 ino:830993 sk:44 cgroup:/user.slice/user-1000.slice/user@1000.service/app.slice/snap.firefox.firefox-8d3f1834-c397-4085-b29d-3b2538c9ff4e.scope <->
tcp    TIME-WAIT  0        0                    192.168.1.81:39658     172.66.152.176:80     timer:(timewait,7.023ms,0) ino:0 sk:45                                                     
tcp    LISTEN     0        4096                        [::1]:631                 [::]:*      ino:680781 sk:1019 cgroup:/system.slice/cups.service v6only:1 <->
```

The terminal generated a massive list of connections. While I could spot some firefox activities, trying to filter dynamically using ss -tunaep | grep :443 | grep ESTABLISHED initially yielded no results. This happened because modern web browsers open and close TCP handshakes rapidly or switch over to UDP-based QUIC protocols.
Step 2: Forcing Active Connections

To force the system to maintain a persistent ESTABLISHED TCP link over HTTPS, I created a short loop in an alternative terminal to hit Google servers every second:

```bash
while true; do curl -s https://www.google.com > /dev/null; sleep 1; done
```

With the background traffic active, I ran the filtered command again, adjusting the state keyword to match Linux's shorthand (ESTAB instead of ESTABLISHED):

```bash
tcp   ESTAB     0      0                192.168.1.81:56448   34.107.243.93:443  users:(("firefox",pid=38575,fd=201)) ...
tcp   ESTAB     0      0                192.168.1.81:35392  34.120.208.123:443  users:(("firefox",pid=38575,fd=198)) ...
tcp   ESTAB     0      0                192.168.1.81:40058   140.82.112.25:443  users:(("firefox",pid=38575,fd=248)) ...
```

Final Network Connection Report

Using the verified data from the terminal output above, here is the structured map of active HTTPS connections:

### Connection 1:

    Local IP address and port: 192.168.1.81:56448

    Remote IP address and port: 34.107.243.93:443

    Status: ESTABLISHED

    Process: firefox (PID: 38575)

### Connection 2:

    Local IP address and port: 192.168.1.81:35392

    Remote IP address and port: 34.120.208.123:443

    Status: ESTABLISHED

    Process: firefox (PID: 38575)

### Connection 3:

    Local IP address and port: 192.168.1.81:40058

    Remote IP address and port: 140.82.112.25:443

    Status: ESTABLISHED

    Process: firefox (PID: 38575)

As predicted by the assignment, all secure remote connections communicate via port 443 (HTTPS). The local ports are randomly selected high-range ports allocated dynamically by the operating system to prevent crossover data between active browser tabs.

---

## Bonus Section (Extra Points Criteria)

### 1. Investigation of Open Ports and Active Services
Based on the full system diagnostic data gathered via `ss -tunaep` in Exercise 3, I identified the following active background services listening on the host:

* **Port `53` (`127.0.0.53` & `127.0.0.54`)**: Managed by `systemd-resolved`. This is the local DNS caching daemon used by Linux to handle domain name resolutions.
* **Port `631` (`127.0.0.1` & `[::1]`)**: Managed by the `cups.service` daemon. This is the Common Unix Printing System used to manage local network printer lines.
* **Port `5353` (`0.0.0.0`)**: Managed by `avahi-daemon`. It implements zero-configuration networking (mDNS/DNS-SD) for finding local devices like printers or file shares.

### 2. Automated Server Availability Bash Script

To fulfill the second bonus criterion, I engineered a compact health-check script in Bash. It queries the local web server and outputs only its HTTP response status code.

```bash
nano ~/first-devops-project/my-server/check_server.sh
```

### Script content:

```bash
#!/bin/bash
# Automatically verify local HTTP daemon state and capture HTTP status code
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)

echo "Server status code checked: $STATUS"

if [ "$STATUS" -eq 200 ]; then
    echo "Success: Server is active and operational!"
else
    echo "Warning: Critical state or server unreachable."
fi
```

I give the script rights to execute `chmod +x check_server.sh`
And I ran script with `./check_server.sh`

Output:

```bash
sane@power-sane:~/first-devops-project/my-server$ ./check_server.sh
Server status code checked: 200
Success: Server is active and operational!
```
