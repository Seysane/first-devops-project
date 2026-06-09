# Lesson 6 Exercises

This section documents the homework exercises from Lesson 6.

---

## Exercise 1: "Virtual Zoo"

The objective of this exercise is to deploy and configure a multi-OS virtual environment.

### Project Requirements:
1. Create **3 Virtual Machines** with different operating system families.
2. Configure a local network between all VMs.
3. Set up a shared/common folder accessible by the machines.
4. Create system snapshots for backup/rollback purposes.
5. Perform initial baseline performance tests.

### Selected Operating Systems:
1. **Debian** (Debian/Ubuntu family)
2. **Rocky Linux** (RHEL family)
3. **FreeBSD** (BSD Unix family)

### Hardware Provisioning (Per VM):
To ensure smooth operation on the host workstation, each virtual machine has been allocated the following dedicated resources:

| Resource | Allocation |
| :--- | :--- |
| **RAM** | 4 GB |
| **vCPU** | 3 Cores |
| **Storage** | 100 GB |

---

## Implementation Progress

### 1. OS Provisioning & VirtualBox Setup
* Downloaded the official `.iso` image files for Debian, Rocky Linux, and FreeBSD.
* Initialized the virtual environments in VirtualBox with the specified resource footprints and created default non-root users.

### 2. Networking & Infrastructure Challenges
* **DHCP & Visibility Issues:** During initial deployment, the local router's DHCP server encountered difficulties discovering the virtual network interfaces.
* **Solution Strategy:** Shifted implementation strategy towards configuring **Static IP Addresses** directly inside the guest operating systems to ensure permanent, reliable network routing.
* **Current Phase:** Actively establishing inter-VM and Host-to-VM secure communications via **SSH connections**.

### 3. SSH Full Mesh Configuration (Every Node to Every Node)
To avoid typing long IP addresses every time, I configured `config` files on all virtual machines and my host laptop. Now, the entire "Virtual Zoo" has short aliases and full inter-node connectivity.

#### Host Workstation Setup (Ubuntu)
* **Connection Refused Issue:** Initially, Debian could not SSH into my laptop. I realized that `openssh-server` wasn't actually installed on my Ubuntu host.
* **Solution:** Re-ran the installation via `sudo apt install openssh-server -y`, enabled the service using `sudo systemctl enable --now ssh`, and opened the port in the firewall with `sudo ufw allow 22/tcp`.
* Created `~/.ssh/config` on the laptop and mapped short aliases for all three VMs (Debian, Rocky, FreeBSD).

#### Guest VMs Setup

* **Debian:**
    * The `~/.ssh` directory was already present from earlier host-to-VM testing.
    * Created `~/.ssh/config` and added routing blocks pointing to the Host, Rocky, and FreeBSD.

* **Rocky Linux:**
    * A clean Rocky installation does not include `nano` by default, so I installed it using `sudo dnf install nano -y`.
    * Created the `config` file.

* **FreeBSD:**
    * Instead of nano, I used the built-in text editor: `ee ~/.ssh/config`. Applied the same `chmod 600` rule to the file.
    * To allow administrative privilege escalation via SSH, I had to ensure my non-root user was a member of the `wheel` group using `pw groupmod wheel -m my_user`. Without this, running `su` over an SSH session is blocked by default.

#### Connectivity Status
Tested connections from every single machine to every other machine. Pings are responsive and SSH access works perfectly across the board:

| From System: | To: Host | To: Debian | To: Rocky | To: FreeBSD |
| :--- | :---: | :---: | :---: | :---: |
| **Host (Ubuntu)** | - | Yes | Yes | Yes |
| **Debian** | Yes | - | Yes | Yes |
| **Rocky Linux** | Yes | Yes | - | Yes |
| **FreeBSD** | Yes | Yes | Yes | - |

---

### 4. Shared Folder Infrastructure Setup

To bypass unstable, kernel-dependent VirtualBox Guest Additions, the shared workspace architecture was shifted towards a robust network-based solution using **NFS (Network File System)**.

---

### Host Workstation Directory & Server Setup (Ubuntu)

#### 1. Created a permanent shared directory on the Ubuntu host laptop:

```bash
mkdir -p /home/sane/vbox_shared
```

#### 2. Installed the NFS kernel server:

```Bash
sudo apt install nfs-kernel-server -y
```

#### 3. Configured /etc/exports to share the directory with user ID mapping (all_squash) to avoid permission conflicts across different OS environments:

```text
/home/sane/vbox_shared *(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=1000)
```

#### 4. Adjusted the host firewall (UFW) to allow full traffic from the laboratory subnet:

```bash
sudo ufw allow from 192.168.1.0/24
```

#### 5. Guest Shared Folder Mounting (NFS Clients)

---

### Rocky Linux (RHEL family)

Installed necessary NFS utilities: 

```bash
sudo dnf install nfs-utils -y.
```

Created a dedicated mountpoint, mounted the remote host directory, and verified seamless read/write access:

```bash
sudo mkdir -p /media/sf_vbox_shared
sudo mount -t nfs 192.168.1.80:/home/sane/vbox_shared /media/sf_vbox_shared
```

Verified full read/write access seamlessly without Guest Additions.

### FreeBSD (BSD Unix family)

* Ensured administrative escalation via `sudo` was configured for the `wheel` group.

* Created the `/mnt/vbox_shared` mountpoint and adjusted local POSIX permissions to grant ownership to the local user:

```bash
sudo mkdir -p /mnt/vbox_shared
sudo chown freebsd:wheel /mnt/vbox_shared
sudo chmod 775 /mnt/vbox_shared
```
Mounted the network share using the native BSD storage syntax:

```bash
sudo mount -t nfs 192.168.1.80:/home/sane/vbox_shared /mnt/vbox_shared
```

### Debian (Debian/Ubuntu family)

Completely removed the legacy, unstable vboxsf configuration and purged VirtualBox Guest Additions configurations.

Installed the standard NFS client tools package:

```bash
sudo apt update && sudo apt install nfs-common -y
```

Re-created a clean local directory, assigned proper ownership to the sanedeb user, and mounted the unified NFS share:

```bash
sudo mkdir -p /media/sf_vbox_shared
sudo chown sanedeb:sanedeb /media/sf_vbox_shared
sudo chmod 775 /media/sf_vbox_shared
sudo mount -t nfs 192.168.1.80:/home/sane/vbox_shared /media/sf_vbox_shared
```

Cluster Integration Status

All guest virtual machines now share a unified, cross-platform network workspace hosted by the Ubuntu workstation. Read and write operations sync instantly across the entire mesh.

### 5. Environment State Preservation (Snapshots)

To guarantee a clean fallback state before conducting heavy system tests or resource deployments, all three virtual environments were gracefully shut down (sudo poweroff) and cold system snapshots were generated within VirtualBox.

* **Snapshot Names:** 
   * Debian: `Debian_Mesh_Network_and_NFS_Configured`
    * Rocky Linux: `Rocky_Mesh_Network_and_NFS_Configured`
    * FreeBSD: `FreeBSD_Mesh_Network_and_NFS_Configured`

Full mesh SSH operational, static IP allocations permanent, unified cross-platform shared storage workspace configured via NFS server user mapping. Baseline state secured.

## Verification & Proof of Work

### 1. Network Connectivity Verification (Host to Zoo)
Below is the execution of the connectivity check from the host workstation (`power-sane`) to all three laboratory nodes using their static IP addresses, showing 0% packet loss:

```bash
sane@power-sane:~$ ping -c 2 192.168.1.81 && ping -c 2 192.168.1.88 && ping -c 2 192.168.1.87
PING 192.168.1.81 (192.168.1.81) 56(84) bytes of data.
64 bytes from 192.168.1.81: icmp_seq=1 ttl=64 time=0.615 ms
64 bytes from 192.168.1.81: icmp_seq=2 ttl=64 time=1.02 ms

--- 192.168.1.81 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1040ms
rtt min/avg/max/mdev = 0.615/0.818/1.021/0.203 ms
PING 192.168.1.88 (192.168.1.88) 56(84) bytes of data.
64 bytes from 192.168.1.88: icmp_seq=1 ttl=64 time=1.52 ms
64 bytes from 192.168.1.88: icmp_seq=2 ttl=64 time=0.863 ms

--- 192.168.1.88 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 0.863/1.190/1.518/0.327 ms
PING 192.168.1.87 (192.168.1.87) 56(84) bytes of data.
64 bytes from 192.168.1.87: icmp_seq=1 ttl=64 time=0.924 ms
64 bytes from 192.168.1.87: icmp_seq=2 ttl=64 time=1.29 ms

--- 192.168.1.87 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.924/1.107/1.291/0.183 ms
```

### 2. Storage Synchronization Verification (NFS Shared Directory)

Listing the contents of the shared directory on the host machine confirms that all guest environments have identical read/write access and their test files are properly synchronized:

```bash
sane@power-sane:~$ ls -l /home/sane/vbox_shared
total 0
-rw-r--r-- 1 sane sane 0 Jun  8 23:20 debian_nfs_test.txt
-rw-r--r-- 1 sane sane 0 Jun  8 23:15 freebsd_final_test.txt
-rw-r--r-- 1 sane sane 0 Jun  8 23:02 rocky_final_test.txt
```

### 3. Storage Performance Baseline (NFS Write Benchmarks)
To complete the exercise requirements, sequential write performance tests were conducted across all three guest operating systems using the `dd` utility (writing a 1 GB file of contiguous zeros directly to the NFS mountpoint):

**Debian (Direct I/O):**
```bash
sanedeb@Deb:~$ dd if=/dev/zero of=/media/sf_vbox_shared/speedtest_debian.img bs=1M count=1000 oflag=direct
1048576000 bytes (1.0 GB, 1000 MiB) copied, 2.00597 s, 523 MB/s
```

**Rocky Linux (Kernel-Optimized Direct I/O):**

```bash
[sanerocky@Rocky ~]$ dd if=/dev/zero of=/media/sf_vbox_shared/speedtest_rocky.img bs=1M count=1000 oflag=direct
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 0.690958 s, 1.5 GB/s
```

**FreeBSD (Buffered I/O Syntax):**

```bash
freebsd@freebsd:~ $ dd if=/dev/zero of=/mnt/vbox_shared/speedtest_freebsd.img bs=1m count=1000
1048576000 bytes transferred in 1.488090 secs (704645700 bytes/sec)
```

The lab infrastructure demonstrates excellent storage throughput. The differences in speeds highlight how each kernel family (Debian/Linux, RHEL/Enterprise, and BSD/Unix) handles virtual network sockets and synchronous/buffered I/O sub-systems over the VirtualBox internal memory bridge.
