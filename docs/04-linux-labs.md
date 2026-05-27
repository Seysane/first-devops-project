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
