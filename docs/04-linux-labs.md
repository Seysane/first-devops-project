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
