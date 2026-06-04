# Lesson 6 Exercises

This section documens homework exercises form lesson 5

---

## 1. Comprehensive Network Troubleshooting

Scenario: A user reports: "The website example.com won't load, but my email is working perfectly."

### Step 1: Verify Host Availability (ping)

To initiate the diagnostic pipeline, we test low-level network connectivity and basic name resolution using the Internet Control Message Protocol (ICMP):

```bash
ping -c 4 example.com
```

Scenario A: The host responds successfully (0% packet loss)

```bash
sane@power-sane:~$ ping -c 4 example.com
PING example.com (172.66.147.243) 56(84) bytes of data.
64 bytes from 172.66.147.243: icmp_seq=1 ttl=57 time=5.29 ms
64 bytes from 172.66.147.243: icmp_seq=2 ttl=57 time=7.26 ms
64 bytes from 172.66.147.243: icmp_seq=3 ttl=57 time=9.11 ms
64 bytes from 172.66.147.243: icmp_seq=4 ttl=57 time=8.49 ms

--- example.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 5.293/7.536/9.106/1.455 ms
```

The terminal output provides crucial architectural data that allows us to narrow down the issue immediately:

DNS Layer Status: Functional. The local resolver successfully mapped example.com to the IP address 172.66.147.243.

Network Layer Status: Functional. There is 0% packet loss, and the round-trip time (RTT) is highly optimal (average 7.53ms), meaning low-level network routes between the client and the destination are fully healthy.

### Infrastructure Insight:

The resolved IP address (172.66.147.243) belongs to Cloudflare (a reverse proxy and CDN service). This means that our ping did not reach the actual backend origin server; it only reached Cloudflare's edge network.

Root Cause Location:

Since the network and Cloudflare edge proxies are operational, the breakdown occurs strictly at the Application Layer (HTTP/HTTPS). The most likely root causes are:

1. Origin Server Failure: The actual web server hosting the code behind Cloudflare (e.g., Nginx, Apache) is down, causing Cloudflare to display an HTTP 502 (Bad Gateway) or HTTP 521 (Web Server Is Down) error page.

2. Port/SSL Misconfiguration: Ports 80 or 443 are closed on the origin server, or there is an SSL handshake mismatch between Cloudflare and the backend.
