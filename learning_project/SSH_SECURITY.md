# Lesson 9: SSH Configuration & Security Lab Report

This document explains the basics of SSH key-based authentication, configuration file tweaks, and security best practices implemented during this lab using a local Debian VM on VirtualBox.

---

## 1. How SSH Keys Work (Public vs. Private)

Instead of using passwords, SSH key authentication uses a pair of mathematical keys:

* **Private Key (`learning_key`)**: This is your secret key. It stays safely on your host machine (Ubuntu) and must never be shared with anyone. Its file permissions must be strictly hidden from other local users (`chmod 600`).
* **Public Key (`learning_key.pub`)**: This is the key you upload to the remote server (Debian). It gets appended to the `~/.ssh/authorized_keys` file.

### Connection Mechanic:
When you connect, the server uses your public key to encrypt a challenge message. If you have the matching private key on your computer, your system decrypts the challenge and proves your identity. The private key itself is **never sent over the network**.

---

## 2. Key-Based Authentication vs. Passwords

| Feature | Password Authentication | Key-Based Authentication (RSA 4096) |
| :--- | :--- | :--- |
| **Brute-Force Protection** | **Weak.** Vulnerable to bots trying automated dictionary attacks. | **Extremely Strong.** Cryptographically impossible to crack by guessing ($2^{4096}$ combinations). |
| **DevOps & Automation** | **Hard.** Requires typing passwords or using insecure cleartext scripts. | **Perfect.** Allows seamless automation for Ansible, Docker, and CI/CD pipelines. |
| **Server Compromise Risk** | **High.** If an attacker gets your password, they can log into any account using it. | **Low.** The server only holds the public lock. Compromising it doesn't leak your private key. |

---

## 3. Best Practices for Managing SSH Keys

To keep your servers secure, follow these simple rules:

1. **Keep Permissions Tight**: Linux will reject SSH keys if permissions are too loose. Always use:
   ```bash
   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/learning_key
   chmod 644 ~/.ssh/learning_key.pub
