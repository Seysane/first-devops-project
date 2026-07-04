# Lesson 15 

This section documents exercises from lesson 15

---


### Implementation of the Let's Encrypt on real server

#### Exercise requirements:

* Server access
* Registered domain
* Configure HTTP server with basic site
* Use Certbot to gain Let's Encrypt certificate
* Configure auto renewal for certificate
* Check SSL security using online tools like SSL Labs Server Test

#### Additional points

* Configure HSTS (HTTP Strict Transport Security)
* Configure OCSP Stapling
* Configure TLS 1.3 as preffered protocol
* SSL Labs degree should be A or A+

### Before homework

I actually have own website `www.sanedev.pl` so instead of doing every taks I will check if im already using them because I know that I used some of the provided exercise requirements.


#### Server access

I do have access to my own server by ssh and by Raspberry Pi Connect.

```bash
sicin@pi-server:~ $ uname -a && whoami
Linux pi-server 6.xx.xxxxx-rpi-xxxx
sicin
sicin@pi-server:~ $ curl ifconfig.me
178.xx.xxx.xx
```

#### Registered domain

![alt text](dns.png)

#### Configure HTTP server with basic site

Currently I'm using nginx server

```bash
sicin@pi-server:~ $ nginx -version
nginx version: nginx/1.26.3
```

#### Let's Encrypt Certbot certificate

```bash
sicin@pi-server:~ $ sudo certbot certificates
Saving debug log to [REDACTED]

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Found the following certs:
  Certificate Name: sanedev.pl
    Serial Number: [REDACTED]
    Key Type: [REDACTED]
    Domains: sanedev.pl www.sanedev.pl
    Expiry Date: [REDACTED] (VALID: 37 days)
    Certificate Path: [REDACTED]
    Private Key Path: [REDACTED]
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

#### Certbot auto renewal

My auto renewal service is running.

```bash
sicin@pi-server:~ $ systemctl list-timers | grep certbot
Sat 2026-07-04 22:10:55 CEST       6h Sat 2026-07-04 08:56:52 CEST      6h ago certbot.timer                certbot.service
```

and it runs cron script

```bash
sicin@pi-server:~ $ ls -l /etc/cron.d/certbot
-rw-r--r-- 1 root root 802 Apr 16  2023 /etc/cron.d/certbot
```