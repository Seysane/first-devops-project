# Lesson 13 Exercise 2

This section documents exercise 2 from lesson 13

---

### Nginx and Apache2 reverse proxy

In this exercise I had to create a reverse proxy connection between my `Nginx` and `Apache2` servers, where `Nginx` takes user requests and send it to the `Apache2` backend server that response back to `Nginx` and `Nginx` serves output for the `client`.

### Exercise requirements:

Documentation file NGINX_REVERSE_PROXY.md that will contain:
* Diagram: Client -> Nginx -> Apache
* Explanation of proxy headers
* Issues to fix
* How to monitor the performance


### Issues to fix

First thing that I did was installing apache2 but it didnt started as planned because `nginx` was already using `port 80`.

I changed `Listen 80` to `Listen 8080` with this command:

```bash
sudo nano /etc/apache2/ports.conf
```

After port change I restarted apache2.

### Reverse proxy configuration

I opened apache_proxy.conf file to paste provided code in exercise:

```bash
upstream apache_backend {
    server 127.0.0.1:8080;
    }
    server {
        listen 80;
        server_name localhost;

        location / {
        proxy_pass http://apache_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    location /health {
        access_log off;
        return 200 "healthy\n";
    }
}
```

### Headers 
`upstream apache_backend` - defines backend, instead of using IP adress in proxy_pass, we can simply name it, easier to maintain.

`proxy_pass http://apache_backend`- tells the `nginx` to serve requests to `apache`, `apache` sees the rest like:
* Host - original request domain
* X-Real-IP - client real IP address
* X-Forwarded-For - list of IP addresses of that request pass through
* X-Forwarded-Proto - it tells if client used HTTP or HTTPS

`location/health` - special endpoint to check if server is allive and we set access_log to off there would be too many logs.

## Diagram

```mermaid
flowchart LR
    A[Client browser] -->|port 80| B(Nginx reverse proxy) -->| port 8080| C(Apache backend)
```

### How to monitor the performance?

Well in this case we have to check if the server response with /health endpoint so after checking it with command:

```bash
sane@power-sane:~$ curl -v http://localhost/health
* Host localhost:80 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:80...
* connect to ::1 port 80 from ::1 port 48682 failed: Connection refused
*   Trying 127.0.0.1:80...
* Connected to localhost (127.0.0.1) port 80
> GET /health HTTP/1.1
> Host: localhost
> User-Agent: curl/8.5.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Server: nginx/1.24.0 (Ubuntu)
< Date: Tue, 30 Jun 2026 12:58:52 GMT
< Content-Type: application/octet-stream
< Content-Length: 8
< Connection: keep-alive
<
healthy
* Connection #0 to host localhost left intact
```

We can see that response confirms the server is healthy and reachable through Nginx, without revealing Apache directly.