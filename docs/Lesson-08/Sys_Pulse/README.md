# Lesson 8: Automated VM Resource Monitor & Alerting System

This project is my solution for the Lesson 8 homework Exercise 2. The objective was to build a lightweight, production-like monitoring stack inside a Bash script (`monitor.sh`). 

It tracks core system performance metrics, ensures critical network services are alive, and parses system logfiles for unauthorized access saving historical trends and logging alerts when things go wrong.

## Project Requirements

1. Create a script named `monitor.sh` that checks CPU, RAM, and Disk utilization.

2. Monitor the active status of critical background network services.

3. Parse and analyze system authentication logs for failed `root` login attempts.

4. Save structured historical metrics data to allow for future trend analysis.

5. Implement an alerting mechanism (saving to an alert logfile) when:
   * CPU utilization breaches 80% continuously for over 5 minutes.
   * Free storage space falls below 10%.
   * New unauthorized failed `root` login attempts are detected.
   * A monitored network service stops responding or crashes.
6. Automate the entire pipeline using a dedicated `systemd` service and timer executing every minute.

## My Setup & Infrastructure
**Target System:** Host Workstation / Laptop running native Ubuntu Desktop (`power-sane`, user: `sane`).

**Monitored Services:** Secure Shell Server (`ssh`) and Network File System Core (`nfs-kernel-server`).
**Log Sources:** Native system authentication tracker (`/var/log/auth.log`).


## How It Works

Since a standard Bash script runs statelessly (it has no memory of what happened a minute ago), I had to implement two custom logic mechanisms to meet the advanced alerting requirements without overloading the system.

### 1. The 5-Minute CPU Window Logic
The requirement states that an alert must trigger only if CPU usage stays above 80% for **more than 5 minutes continuously**. 

Every 60 seconds, `systemd` wakes up the script.

The script calculates the current CPU load and appends it as a new row into `syspulse_metrics/syspulse_metrics.csv`.

It then uses `tail -n 5` to read only the last 5 rows (the last 5 minutes of history) and extracts the CPU column using `cut`.

A `for` loop evaluates these 5 values. If **all 5 values** are greater than or equal to `CPU_THRESHOLD` (80), a continuous breach is confirmed, and an alert is written to `syspulse_alerts.log`. If even one minute dropped below 80%, the alert is skipped.

### 2. State-Driven Brute Force Detection

Parsing `/var/log/auth.log` for the phrase `failed password for root` gives us the *total* number of failed logins since the log file was created. If the script simply checked this number every minute, it would spam the alert file on every single execution loop, even if no new attacks occurred.
* To prevent alert spam, the script utilizes a hidden state tracker file: `syspulse_logs/.last_failed_root`.
* On execution, the script fetches the current total of failed attempts from the system log.
* It reads the previous count stored inside `.last_failed_root` and subtracts it from the current total (`CURRENT_COUNT - LAST_COUNT`).
* An alert is generated **only if the result is greater than 0** (meaning new bad attempts occurred within that specific 60-second window).
* Finally, it updates `.last_failed_root` with the new total so it's ready for the next minute's comparison.

### 3. Metric Extraction Commands

To keep the script efficient and capable of performing mathematical comparisons, it cuts out all raw text formatting from system utilities to extract pure, raw integers:
* **CPU Load:** Extracted by taking the idle percentage from `top -bn1` and subtracting it from 100: `top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}'`.
* **RAM Usage:** Calculated dynamically using a ratio of used memory over total memory from `free`: `free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}'`.
* **Disk Space:** Inverted from the standard `df` output to represent pure *free* percentage left: `df / | awk 'NR==2 {print 100 - $5}'`.

## Verification & Proof of Work

### 1. Active Automation Schedules
Running the global systemd timer ledger check confirms that `sys_pulse.timer` has been ingested successfully by the init engine, showing active tracking and regular 1-minute execution intervals:

```bash
sane@power-sane:~/first-devops-project/Sys_Pulse$ systemctl list-timers sys_pulse.timer
NEXT                          LEFT     LAST                          PASSED     UNIT             ACTIVATES
Mon 2026-06-15 17:21:06 CEST  35s      Mon 2026-06-15 17:20:06 CEST  24s ago    sys_pulse.timer  sys_pulse.service
```

## Folder Structure

To keep the repository clean and avoid cluttering the project root, I designed a decoupled directory layout that isolates historical databases from raw text alert streams:

```text
~/first-devops-project/Sys_Pulse/
├── sys_pulse.conf           # Central environment configuration
├── monitor.sh               # Main automation engine script
├── sys_pulse.service        # Systemd service unit mapping
├── sys_pulse.timer          # Systemd calendar scheduler unit
├── syspulse_metrics/
│   └── syspulse_metrics.csv # Append-only database for performance trends
└── syspulse_logs/
    ├── syspulse_alerts.log  # Active monitoring alert history stream
    └── .last_failed_root    # Small state file tracking historical brute-force attempts


