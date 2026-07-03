# Lesson 14 Exercise 2

This section documents exercise 2 from lesson 14

---

### Testing HTTP Server with Apache Bench and Apache JMeter

### Homework exercise requirements

* Test localholst with Apache Bench with different requests:
    - 100 requests, 10 simultaneously
    - 1000 requests, 10 simultaneously
    - 1000 requests, 50 simultaneously
    - 1000 requests, 100 simultaneously
    - 1000 requests, 500 simultaneously

* Create test script (test_server.sh)

* Test using JMeter:
    - path tests: (/, /page1, /page2)
    - different HTTP methods (GET, POST if available)
    - Timers `think-time` between requests

* Create report script for testing (generate_report.sh)

* Documentation `this file`:

    - test methodology
    - used tools (ab, JMeter)
    - results of test with different load
    - bottleneck identification
    - opimialization recommendation

* Practice:
    - Nginx vs Apache performance
    - Test with cache (on/off)
    - resource monitoring


### Test results witch Apache Bench


#### 100 requests, 10 simultaneously

```bash
sane@power-sane:~$ ab -n 100 -c 10 http://localhost/
This is ApacheBench, Version 2.3 <$Revision: 1903618 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient).....done


Server Software:        nginx/1.24.0
Server Hostname:        localhost
Server Port:            80

Document Path:          /
Document Length:        10671 bytes

Concurrency Level:      10
Time taken for tests:   0.011 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      1094400 bytes
HTML transferred:       1067100 bytes
Requests per second:    9383.50 [#/sec] (mean)
Time per request:       1.066 [ms] (mean)
Time per request:       0.107 [ms] (mean, across all concurrent requests)
Transfer rate:          100286.20 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:     0    1   0.4      1       2
Waiting:        0    1   0.4      1       2
Total:          0    1   0.5      1       2

Percentage of the requests served within a certain time (ms)
  50%      1
  66%      1
  75%      1
  80%      1
  90%      2
  95%      2
  98%      2
  99%      2
 100%      2 (longest request)
```

#### 1000 requests, 10 simultaneously

```bash
sane@power-sane:~$ ab -n 1000 -c 10 http://localhost/

Benchmarking localhost (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests


Server Software:        nginx/1.24.0
Server Hostname:        localhost
Server Port:            80

Document Path:          /
Document Length:        10671 bytes

Concurrency Level:      10
Time taken for tests:   0.082 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      10944000 bytes
HTML transferred:       10671000 bytes
Requests per second:    12143.73 [#/sec] (mean)
Time per request:       0.823 [ms] (mean)
Time per request:       0.082 [ms] (mean, across all concurrent requests)
Transfer rate:          129786.15 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:     0    1   0.3      0       2
Waiting:        0    0   0.3      0       2
Total:          0    1   0.4      1       2
ERROR: The median and mean for the processing time are more than twice the standard
       deviation apart. These results are NOT reliable.

Percentage of the requests served within a certain time (ms)
  50%      1
  66%      1
  75%      1
  80%      1
  90%      1
  95%      2
  98%      2
  99%      2
 100%      2 (longest request)
```

#### 1000 requests, 50 simultaneously

```bash
sane@power-sane:~$ ab -n 1000 -c 50 http://localhost/

Benchmarking localhost (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests


Server Software:        nginx/1.24.0
Server Hostname:        localhost
Server Port:            80

Document Path:          /
Document Length:        10671 bytes

Concurrency Level:      50
Time taken for tests:   0.069 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      10944000 bytes
HTML transferred:       10671000 bytes
Requests per second:    14517.37 [#/sec] (mean)
Time per request:       3.444 [ms] (mean)
Time per request:       0.069 [ms] (mean, across all concurrent requests)
Transfer rate:          155154.39 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   0.4      1       2
Processing:     0    2   1.1      2       6
Waiting:        0    2   0.8      1       5
Total:          1    3   1.3      3       8
WARNING: The median and mean for the waiting time are not within a normal deviation
        These results are probably not that reliable.

Percentage of the requests served within a certain time (ms)
  50%      3
  66%      3
  75%      4
  80%      4
  90%      6
  95%      6
  98%      7
  99%      7
 100%      8 (longest request)
```

#### 1000 requests, 100 simultaneously

```bash
sane@power-sane:~$ ab -n 1000 -c 100 http://localhost/

Benchmarking localhost (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests


Server Software:        nginx/1.24.0
Server Hostname:        localhost
Server Port:            80

Document Path:          /
Document Length:        10671 bytes

Concurrency Level:      100
Time taken for tests:   0.062 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      10944000 bytes
HTML transferred:       10671000 bytes
Requests per second:    16137.88 [#/sec] (mean)
Time per request:       6.197 [ms] (mean)
Time per request:       0.062 [ms] (mean, across all concurrent requests)
Transfer rate:          172473.61 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    2   0.9      2       7
Processing:     1    4   1.0      4       8
Waiting:        0    2   0.7      2       6
Total:          3    6   1.1      5      13

Percentage of the requests served within a certain time (ms)
  50%      5
  66%      6
  75%      6
  80%      6
  90%      7
  95%      8
  98%      9
  99%     10
 100%     13 (longest request)
```

#### 1000 requests, 500 simultaneously

```bash
sane@power-sane:~$ ab -n 1000 -c 500 http://localhost/

Benchmarking localhost (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests


Server Software:        nginx/1.24.0
Server Hostname:        localhost
Server Port:            80

Document Path:          /
Document Length:        10671 bytes

Concurrency Level:      500
Time taken for tests:   0.071 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      10944000 bytes
HTML transferred:       10671000 bytes
Requests per second:    13990.32 [#/sec] (mean)
Time per request:       35.739 [ms] (mean)
Time per request:       0.071 [ms] (mean, across all concurrent requests)
Transfer rate:          149521.53 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    9   2.2      9      14
Processing:     8   19   8.3     18      35
Waiting:        1   10   3.9      9      26
Total:         16   27   7.3     29      43

Percentage of the requests served within a certain time (ms)
  50%     29
  66%     32
  75%     32
  80%     35
  90%     38
  95%     39
  98%     39
  99%     40
 100%     43 (longest request)
```

#### Testing Script `test_server.sh`

In this case we got half of a script

```bash
#!/bin/bash

URL="http://localhost/"
RESULTS_FILE="load_test_results.csv"
echo "Concurrent,Requests,Time,RequestsPerSec,AvgResponseTime" > $RESULTS_FILE
for concurrent in 10 50 100 200 500; do
result=$(ab -n 500 -c $concurrent "$URL" 2>/dev/null | grep -E "Requests persecond|Time per request")

done
cat $RESULTS_FILE
```

I added 3 lines of code to this script

```bash
    rps=$(echo "$result" | grep "Requests per second" | awk '{print $4}')
    avg=$(echo "$result" | grep "Time per request" | head -1 | awk '{print $4}')
    echo "$concurrent,500,,$rps,$avg" >> $RESULTS_FILE
```

now the requests per second and time per request are filtered out from the ab test results and they are saved to the `$RESULTS_FILE`

```bash
sane@power-sane:~/first-devops-project/docs/Lesson-14$ ./test_server.sh
Concurrent,Requests,Time,RequestsPerSec,AvgResponseTime
10,500,,13321.61,0.751
50,500,,16878.78,2.962
100,500,,16307.36,6.132
200,500,,16168.15,12.370
500,500,,18368.17,27.221
```

#### `test_server.sh` results

RequestPerSec grows along with concurrency

AvgResponseTime grows proportionally


### JMeter Tests (more details)

I had to put more types of tests to JMeter config that we had before.

I added for `/index.html`, `/page1.html`, `/page2.html`, `/page3.html` POST requests and also added `timer think-time` with delay of 1 second.

So the 50% of the Error's were from POST method, our nginx blocked POST methods with information `405 Not Allowed`

### Generating test report (generate_report.sh)

So this exercise was to take test results from load_test_results.csv and generate better looking report.

I prepared very simple output that just looks "better"

```bash
# Load Test Report
Test Date: Fri Jul  3 05:17:36 PM CEST 2026

## Results Summary
| Concurrency | RPS | Avg Response Time |
|-------------|-----|-------------------|
| 10 | 13321.61 | 0.751 |
| 50 | 16878.78 | 2.962 |
| 100 | 16307.36 | 6.132 |
| 200 | 16168.15 | 12.370 |
| 500 | 18368.17 | 27.221 |
```

I asked AI if this can looks better and it can, I swapped:

```bash
awk -F',' 'NR > 1 { print "| " $1 " | " $4 " | " $5 " |" }' "$RESULTS_FILE"
```

for

```bash
awk -F',' 'NR > 1 { printf "| %-11s | %-8s | %-17s |\n", $1, $4, $5 }' "$RESULTS_FILE"
```

Now it looks good:

```bash
# Load Test Report
Test Date: Fri Jul  3 05:22:49 PM CEST 2026

## Results Summary
| Concurrency | RPS | Avg Response Time |
|-------------|-----|-------------------|
| 10          | 13321.61 | 0.751             |
| 50          | 16878.78 | 2.962             |
| 100         | 16307.36 | 6.132             |
| 200         | 16168.15 | 12.370            |
| 500         | 18368.17 | 27.221            |
```