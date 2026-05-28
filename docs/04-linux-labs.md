# Lesson 4 Exercises

This section documents exercises from lesson 4

---

## 1. Cron Service Status

My goal was to check the status of the `cron` service:
- Is it currently running?
- Is it enabled to start after a system restart?

I used the following command: `systemctl status cron`

Output:

```bash
sane@power-sane:~$ systemctl status cron
Warning: The unit file, source configuration file or drop-ins of cron.service change>
● cron.service - Regular background program processing daemon
     Loaded: loaded (/usr/lib/systemd/system/cron.service; enabled; preset: enabled)
     Active: active (running) since Sun 2026-05-24 19:14:17 CEST; 3 days ago
       Docs: man:cron(8)
   Main PID: 1219 (cron)
      Tasks: 1 (limit: 37875)
     Memory: 342.8M (peak: 578.6M)
        CPU: 2min 42.619s
     CGroup: /system.slice/cron.service
             └─1219 /usr/sbin/cron -f -P

```


The output confirms that the cron service is enabled (it will load automatically on system boot) and it is currently active (running).

---

## 2. Process identification

The second task was to check my bash (PID) process number and I must use ps and grep

command that I used to check my shell (PID) was: 

`ps aux | grep bash`

Output:

```bash
sane@power-sane:~/first-devops-project/docs$ ps aux | grep bash
sane       47604  0.0  0.0  19940  5652 pts/3    Ss   May26   0:00 bash
sane       48443  0.0  0.0  19940  5684 pts/3    S    May26   0:00 bash
sane      135999  0.0  0.0  17820  2332 pts/3    S+   00:36   0:00 grep --color=auto bash
```

After checking the meaning of each column, I can tell my main process number is 47604, which is in the STAT column with the letters Ss meaning session leader.

I was also curious if I could check it a little bit faster and I found a shortcut command:

`echo $$`

This built-in shell variable immediately returns the PID of the current active bash session.

---

## 3. Storage and Memory Resource Checking

The goal of this task was to check the amount of free disk space across all mounted partitions and the available RAM using human-readable formatting (GB/MB).

### 1. Disk Space Usage `df -h`

I used the `df -h` command to list the file systems in a human-readable format:

```bash
sane@power-sane:~$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
tmpfs                              3.2G  3.9M  3.1G   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv  935G   48G  840G   6% /
tmpfs                               16G  4.0K   16G   1% /dev/shm
tmpfs                              5.0M  8.0K  5.0M   1% /run/lock
efivarfs                           438K  344K   90K  80% /sys/firmware/efi/efivars
/dev/nvme0n1p2                     2.0G  221M  1.6G  13% /boot
/dev/nvme0n1p1                     1.1G  6.2M  1.1G   1% /boot/efi
tmpfs                              3.2G  2.6M  3.2G   1% /run/user/1000
```

My main logical volume system root partition (/) has a total size of 935 GB, with only 48 GB used and 840 GB available.

### 2. RAM and Swap Usage `free -h`

I checked the memory utilization with the `free -h` command:

```bash
sane@power-sane:~$ free -h
               total        used        free      shared  buff/cache   available
Mem:            31Gi       4.4Gi        19Gi       1.1Gi       7.5Gi        26Gi
Swap:          8.0Gi          0B       8.0Gi
```

My system has a total of 31 GiB of RAM. Currently, 4.4 GiB is being used, leaving 26 GiB available for new processes and applications. The Swap space is completely untouched (0B used out of 8.0 GiB).

---

## 4. Background process termination

This exercise focuses on running a prepared script in the background, locating its process ID, and terminating it using the `kill` command.

The script provided for this task:

`bash -c 'i=0; while true; do echo $i >> ~/counter.log; i=$((i+1)); sleep 1; done' &`

### Script Breakdown:
* `i=0` initializes a counter variable named `i`.
* `while true` sets up an infinite loop that constantly executes the code blocks inside.
* `echo $i >> ~/counter.log` redirects and appends the current value of `$i` into the `counter.log` file inside the home directory.
* `i=$((i+1))` increments the counter variable by one during each iteration.
* `sleep 1` adds a one-second delay between loop cycles.
* The trailing ampersand (`&`) sends the entire execution to the background, allowing the terminal to stay interactive while immediately returning the job number and its PID.

I executed this script in my local terminal:

Output:

```bash
sane@power-sane:~$ bash -c 'i=0; while true; do echo $i >> ~/counter.log; i=$((i+1)); sleep 1; done' &
[1] 153814
```
The system confirmed the process was running under background job [1] with PID 153814. To verify if the background loop was actively writing data, I used ps aux filtered by grep:

Output:

```bash
sane@power-sane:~$ ps aux | grep counter
sane      153814  0.0  0.0  18616  3600 pts/3    S    10:25   0:00 bash -c i=0; while true; do echo $i >> ~/counter.log; i=$((i+1)); sleep 1; done
sane      154175  0.0  0.0  17820  2328 pts/3    S+   10:27   0:00 grep --color=auto counter
```

As the output indicates, the process was actively running with the S (Interruptible sleep) status.

The next requirement was to stop the script using the kill command targeted at its specific PID, followed by another status check:

```bash
sane@power-sane:~$ kill 153814
sane@power-sane:~$ ps aux | grep counter
sane      154532  0.0  0.0  17820  2332 pts/3    S+   10:29   0:00 grep --color=auto counter
[1]+  Terminated              bash -c 'i=0; while true; do echo $i >> ~/counter.log; i=$((i+1)); sleep 1; done'
```

The terminal explicitly printed a Terminated status confirmation, meaning the background process was successfully stopped. Finally, I inspected the generated log file using cat to ensure the loop ran properly before being killed:

Output:

```bash
sane@power-sane:~$ cat ~/counter.log
0
1
2
3
4
5
6
7
8
9
10
11
```

## 5. Filtering Logs

Next exercise is focused on journalctl to look up at all kernel messages from today, which has priority warning or higher.

There was no more given information in the exercise so I searched for the possible options to use it.

At first place I checked `man journalctl` command and I saw a syntax 
`journalctl [OPTIONS...] [MATCHES...]

but then I was looking for flags how to get kernel messegaes and I found -k flag, also I found --since and there is an second to --since today, priority levels are under -p

so I used command:

`journalctl -k --since today -p warning`

```bash
sane@power-sane:~$ journalctl -k --since today -p warning
May 28 00:00:27 power-sane kernel: [UFW BLOCK] IN=enp0s31f6 OUT= MAC=01:00:5e:00:00:fb:52:d7:b>
May 28 00:00:34 power-sane kernel: [UFW BLOCK] IN=enp0s31f6 OUT= MAC=01:00:5e:00:00:01:cc:00:f>
May 28 00:01:14 power-sane kernel: [UFW BLOCK] IN=enp0s31f6 OUT= MAC=01:00:5e:00:00:01:cc:00:f>
May 28 00:01:14 power-sane kernel: [UFW BLOCK] IN=wlp0s20f3 OUT= MAC=8c:f8:c5:de:c9:e8:cc:00:f>
May 28 00:01:49 power-sane kernel: [UFW BLOCK] IN=enp0s31f6 OUT= MAC=01:00:5e:00:00:fb:52:d7:b>
```
The output was heavily flooded with identical [UFW BLOCK] entries. After scrolling down several screens, I finally spotted a different line:

```bash
May 28 12:49:02 power-sane kernel: kauditd_printk_skb: 2 callbacks suppressed 
```

To clear this firewall noise and make the log output readable, I looked for a way to exclude specific strings and found the grep -v option.

I combined both commands using a pipe:

```bash
ane@power-sane:~$ journalctl -k --since today -p warning | grep -v "UFW BLOCK"
May 28 12:49:02 power-sane kernel: kauditd_printk_skb: 2 callbacks suppressed
```

By inverting the match with grep -v, I successfully filtered out all firewall noise. This confirmed that, apart from routine UFW blocks, the kernel only logged a single warning today regarding suppressed callbacks.

---
