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

