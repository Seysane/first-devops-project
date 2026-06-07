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
| **Storage** | 100 GB (Dynamic Allocation) |

---

## Implementation Progress

### 1. OS Provisioning & VirtualBox Setup
* Downloaded the official `.iso` image files for Debian, Rocky Linux, and FreeBSD.
* Initialized the virtual environments in VirtualBox with the specified resource footprints and created default non-root users.

### 2. Networking & Infrastructure Challenges
* **DHCP & Visibility Issues:** During initial deployment, the local router's DHCP server encountered difficulties discovering the virtual network interfaces.
* **Solution Strategy:** Shifted implementation strategy towards configuring **Static IP Addresses** directly inside the guest operating systems to ensure permanent, reliable network routing.
* **Current Phase:** Actively establishing inter-VM and Host-to-VM secure communications via **SSH connections**.
