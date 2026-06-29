# Lesson 13 Exercise 1

This section documents exercise 1 from lesson 13

---

### Nginx configuration


In this exercise I created 2 projects:

```bash
mkdir -p /var/www/project1 /var/www/project2

# Project 1
echo "<h1>Project 1</h1>" > /var/www/project1/index.html
# Project 2
echo "<h1>Project 2</h1>" > /var/www/project2/index.html
```

#### I set up nginx configuration files for both projects

```bash
# Project 1
sudo nano /etc/nginx/sites-available/project1.conf

server {
    listen 80;
    server_name project1.local;
    root /var/www/project1;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

```bash
sudo nano /etc/nginx/sites-available/project2.conf

server {
    listen 80;
    server_name project2.local;
    root /var/www/project2;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

In both projects we asign values like:

listen port - both are listening on port 80

server name - we asign for what domain this configuration should be used

root - directory where nginx is looking up for files if someones enter on project1.local/index.html nginx is looking up for a index.html in /var/www/project1/index.html

location / {try_files} - it tells the nginx to search first for file then directory, if nginx does not find anythin it will return error 404.

#### Configuration activation

Now I make symlink between configuration files and `sites-enabled` nginx search up in sites-enabled for files to load them and then we reload nginx service.

```bash
sudo ln -s /etc/nginx/sites-available/project1.conf /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/project2.conf /etc/nginx/sites-enabled/


sudo systemctl reload nginx
```

#### Tests

`/etc/hosts` is a local file that maps domains to IP addresses, system checks it before DNS requests.

Thats why we are running string command line with bash -c instead of using tee we can run command as a whole string because if I would run it without bash -c just simple echo only the `echo` would get sudo permissions.

Then we just use curl to get an response from the localhost http.

```bash
sudo bash -c 'echo "127.0.0.1 project1.local" >> /etc/hosts'
sudo bash -c 'echo "127.0.0.1 project2.local" >> /etc/hosts'

# Test
curl http://project1.local
curl http://project2.local
```

output:

```bash
sane@power-sane:~$ curl http://project1.local
<h1>Project 1</h1>

sane@power-sane:~$ curl http://project2.local
<h1>Project 2</h1>
```
#### Log analysis

```bash
sane@power-sane:~$ sudo tail -f /var/log/nginx/access.log
192.168.1.27 - - [29/Jun/2026:09:00:45 +0200] "GET / HTTP/1.1" 200 55 "-" "HomeNet/1.0"
192.168.1.27 - - [29/Jun/2026:10:56:48 +0200] "GET / HTTP/1.1" 200 55 "-" "HomeNet/1.0"
127.0.0.1 - - [29/Jun/2026:11:39:50 +0200] "GET / HTTP/1.1" 200 19 "-" "curl/8.5.0"
127.0.0.1 - - [29/Jun/2026:11:49:48 +0200] "GET / HTTP/1.1" 200 19 "-" "curl/8.5.0"
```

Using tail -f command shows last lines of a file and follows new entries in real time

```bash
[Who]
192.168.1.27  
127.0.0.1

[When]
[29/Jun/2026:09:00:45 +0200] 
[29/Jun/2026:11:39:50 +0200]

[Result]
200
200

[How_much] (bytes)
55
19

[What]
"GET / HTTP/1.1"
"GET / HTTP/1.1"

[Who_ask]
"HomeNet/1.0"
"curl/8.5.0"
```

In DevOps we can tell few things from logs like that:

Does someone have issues with access?
From what source the connection is comming?
What resources are mostly downloaded?
Are there any attacks? (many requests from one IP address)