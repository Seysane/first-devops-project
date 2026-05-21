# DevOps Core Filesystem Exploration

This section documents my hands-on analysis focusing on the default system directories, their baseline contents, and what they mean.

---

## 1. System Directories

### The `/etc` Directory
*  This is the central repository for system-wide configuration files. Every single file here is plain text, and there are zero binary or executable files. 


```bash
  ls -lh /etc
```


* **Key components identified:** 
  * `/etc/passwd` – The core database tracking all user accounts created on the system during and after installation.

  * `/etc/hosts` – A static table for local hostname resolution (maps IP addresses to names before checking any DNS servers).

  * `/etc/fstab` – The file system table that dictates which storage partitions are mounted automatically at boot.
*  Because everything here is a plain text file, it requires `sudo` privileges to modify.

### The `/var/log` Directory
* This is where the operating system dumps all its runtime messages, errors, and system activity logs. 


```bash
  ls -lh /var/log
```


* **Key vanilla components identified:**
  * `/var/log/syslog` (or `messages` on some distros) – The main system log capturing general OS messages, boot events, and kernel outputs.

  * `/var/log/auth.log` (or `secure`) – Keeps a strict record of all user authentications, sudo execution logs, and login attempts.

  * `/var/log/dpkg.log` (or `yum.log`) – A chronological ledger tracking every single base package installed, updated, or removed by the system package manager.
* This directory is highly dynamic; it expands constantly as the system runs. In production, monitoring `/var/log` is the bare minimum required for basic observability. If a vanilla system service fails to start right after boot, the root cause will always be recorded here.

### The `/proc` Directory
* A pseudo-filesystem that looks like regular directories and files, but contains hundreds of subdirectories named entirely with numbers (e.g., `/proc/1`, `/proc/122`). These numbers match the exact Process IDs (PIDs) running right now.


```bash
  ls -lh /proc
```


* **Key vanilla components identified:**
  * `/proc/1` – The directory tracking PID 1, which belongs to `systemd` (the very first process started by the kernel).

  * `/proc/cpuinfo` – A virtual text file displaying the exact specifications, clock speed, and core count of the machine's processor.

  * `/proc/meminfo` – A real-time readout of RAM allocation, showing total, free, and cached memory.
* This directory does not exist on the hard drive and takes up 0 bytes of storage. It is generated on the fly inside RAM by the Linux kernel. Reading these files (e.g., using `cat /proc/cpuinfo`) is like querying the live state of the kernel and running hardware directly from memory.

---

## 2. Locating the Git Configuration File (`gitconfig`)

To locate the active Git configuration, I forced Git to reveal the exact source path of my global settings by executing the following command with the `--show-origin` flag:

```bash
git config --global --list --show-origin
```
And the result was that my git config is located in the /home/user directory as a hidden .gitconfig file.


---


## 3. Storage Analysis: The `/var` Directory Breakdown

To check the storage footprint of the dynamic system files, I executed the disk usage command on the `/var` directory:

```bash
sudo du -sh /var/*
```
```text
4.8M    /var/backups
653M    /var/cache
5.8M    /var/crash
5.7G    /var/lib
4.0K    /var/local
0       /var/lock
997M    /var/log
4.0K    /var/mail
4.0K    /var/metrics
4.0K    /var/opt
0       /var/run
15M     /var/snap
52K     /var/spool
100K    /var/tmp
```
This gave me a detailed list of every subdirectory with its individual size (ranging from a few Kilobytes up to several Gigabytes). However, looking at a raw list of files made it hard to see the big picture, so I looked for a way to automatically calculate the total sum directly in the terminal.

So I searched the internet for a solution and I discovered the `sudo du -shc /var/*` command. 
By adding the `-c` flag, the utility automatically calculates and appends a grand total line at the very bottom:
```text
4.8M    /var/backups
653M    /var/cache
5.8M    /var/crash
5.7G    /var/lib
4.0K    /var/local
0       /var/lock
997M    /var/log
4.0K    /var/mail
4.0K    /var/metrics
4.0K    /var/opt
0       /var/run
15M     /var/snap
52K     /var/spool
100K    /var/tmp
7.3G    total
```

The total footprint is 7.3G, heavily dominated by /var/lib (5.7G), which handles system state data. The /var/log directory is also high at 997M (nearly 1G), highlighting the vital need for log rotation monitoring to prevent root filesystem saturation.
