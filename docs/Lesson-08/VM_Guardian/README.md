# Lesson 8: Automated VM Backup System

This project is my solution for the Lesson 7 homework. The goal was to create a bash script that automatically connects to remote virtual machines, downloads their logs using `rsync`, and manages how many backup files we keep so our disk doesn't get full.

## Homework Project Requirements
1. Create a script named `vmlog_guardian.sh` that uses `rsync`.
2. Save logs of the backup process itself into a text file.
3. Use a separate configuration file (`vm_guardian.conf`) to store IPs, usernames, and paths.
4. Keep a maximum of 7 backups (retention policy).
5. Create systemd `.service` and `.timer` files to run the script automatically every day at midnight.
6. Add a `--restore` option to send the files back to the VMs if something breaks.

## My Setup
* **My Laptop (Host):** Ubuntu Desktop (`power-sane`, user: `sane`)
* **VM 1:** Debian (`192.168.1.81`, user: `sanedeb`)
* **VM 2:** Rocky Linux (`192.168.1.88`, user: `sanerocky`)
* **What we are backing up:** Everything inside `/var/log/sysuu/` on both VMs.

---

## How I Built It (Step by Step)

### 1. Setting up SSH Keys (No Passwords)

Since the script needs to run automatically at midnight via systemd, it cannot stop and ask me to type a password every time it connects to a VM. 

To fix this, I generated an SSH key pair on my laptop:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
```

Then, I copied my public key to both virtual machines so they can recognize my laptop:

```Bash
ssh-copy-id sanedeb@192.168.1.81
ssh-copy-id sanerocky@192.168.1.88
```

Now, my laptop can connect to both VMs instantly without any passwords.

### 2. The Configuration File (vm_guardian.conf)

I didn't want to hardcode IP addresses or folders inside the main script. If a VM changes its IP, I only want to change it in one place. So, I put all variables into vm_guardian.conf:

```Bash
BACKUP_SRC="/home/sane/vbox_shared/VM_Guardian"
LOG_FILE="/home/sane/vbox_shared/VM_Guardian/vm_guardian.log"
MAX_BACKUPS=7
VM_LOG_SRC="/var/log/sysuu/"

DEBIAN_USER="sanedeb"
DEBIAN_IP="192.168.1.81"

ROCKY_USER="sanerocky"
ROCKY_IP="192.168.1.88"
```

### 3. How the Backup & Retention Works

When the script runs normally, it does this for each VM:

- It downloads the logs from the VM into a folder called backup/.

- It checks how many files are in backup/. If there are more than 7, it takes the oldest file and moves it to a folder called archives/.

- It checks how many files are in archives/. If there are more than 7 files there, it deletes (rm) the oldest archive permanently so we don't run out of disk space.


### 4. Automated with Systemd

Instead of using old cron jobs, I used systemd to run this script every night.
The Service File (/etc/systemd/system/vm_guardian.service)

This tells systemd what script to run and to execute it as my user (sane) so it can access my SSH keys:

```bash
[Unit]
Description=VM Guardian - Automatic VM Log Backup

[Service]
Type=oneshot
User=sane
ExecStart=/bin/bash /home/sane/vbox_shared/VM_Guardian/vmlog_guardian.sh
```

The Timer File (/etc/systemd/system/vm_guardian.timer)

This acts like an alarm clock set for midnight:

```bash
[Unit]
Description=Run VM Guardian everyday at midnight

[Timer]
OnCalendar=*-*-* 00:00:00
Persistent=true
Unit=vm_guardian.service

[Install]
WantedBy=timers.target
```

    Note: I used Persistent=true because this is a laptop. If my computer is turned off at midnight, systemd will notice it and run the backup immediately when I power it back on the next morning.


## Testing & Verification (Proof of Work)
### 1. Checking the Systemd Timer

I ran this command to verify that my timer is active and loaded. It shows it is waiting for midnight and has exactly 10 hours left before it triggers:
Bash

sane@power-sane:~/vbox_shared/VM_Guardian$ systemctl list-timers --all | grep vm_guardian
Tue 2026-06-16 00:00:00 CEST      10h left -                                        - vm_guardian.timer              vm_guardian.service

### 2. Testing the Restore Mode

To test if the restore function works, I logged into my Debian VM and deleted all its logs using sudo rm -rf /var/log/sysuu/*.

Then, I went back to my laptop and ran the script with the --restore debian flag. It successfully connected to the VM and put the files back where they belonged:

```Bash
sane@power-sane:~/vbox_shared/VM_Guardian$ bash vmlog_guardian.sh --restore debian
==================================
    [!] RESTORE MODE ACTIVE [!]   
==================================
Target directory on VMs: /var/log/sysuu/
----------------------------------
[+] Restoring logs to Debian (192.168.1.81)...
receiving incremental file list
sysuu260611-13.log
sysuu260612-13.log

sent 74 bytes  received 2,410 bytes  4,968.00 bytes/sec
total size is 8,244  speedup is 3.32
----------------------------------
Restore operation finished.
```
I verified on the VM, and all the files were safely restored.

I dont want to force push script to see the /backup >> /archive but its almost the same logic, I will push update after the script will be able to push logs itself.
