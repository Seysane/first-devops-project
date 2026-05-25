# Lesson 3 Exercises

This section documents few exercises from lesson 3

---

## 1. Log Analysis UFW

The first task was to display the contents of the n\
/var/log/ufw.log file. I had to use pipes (|) to filter lines containing the word "BLOCK" and count them to see how many blocked connection requests there were.

First, I searched for UFW using: 

```bash
apt search ufw
```

Then I checked what the paclage was about using: 

```bash
apt show ufw
```

Since it was a firewall package, I downloaded it:

```bash
sudo apt install ufw
```
I expected it to start automatically, but I could not find the ufw.log file in the /var/log directory.
I asked Gemini if this was an issue or normal behavior. It replied that I needed to enable it, as some software does not run automatically after installation. I specifically asked Gemini not to give me a direct answer or commands because I wanted to learn by myslef. It suggested I check the docummentation.

I remembered that apt show provided a lot of information, including the official homepage link, where I found the UFW wiki:


```text
https://wiki.ubuntu.com/UncomplicatedFirewall
```
After the documentation features table, I found the basic usage guide:

```text
Basic Usage

Getting started with ufw is easy. For example, to enable firewall, allow ssh access, enable logging, and check the status of the firewall, perform:

$ sudo ufw allow ssh/tcp
$ sudo ufw logging on
$ sudo ufw enable
```

That was exactly what I needed. After running these commands, I checked the /var/log directory again, and the log file was there, though it only had one line. I decided to take a break to give the system some time to collect more logs.

After an hour,I used cat to check the file again. It now contained many lines. FInally, I could filter out the lines containing the word "BLOCK". Since I noticed almost all lines contained this world, I filtered and counted them using grep with the -wc flags( to count lines matching the string) while targeting ./ufw.log (as I was already inside the /var/log directory):

```bash
grep -wc "BLOCK" ./ufw.log
```

he terminal returned a count of 40 blocked connections at that moment.

I was curious about what UFW was actually blocking, considering the count jumped from 1 to 40 in just one hour. I searched Google and found a 5-year-old StackOverflow post from someone asking the same question. In his case, it was a public server hosting a website, and the traffic came from Russian IP addresses, probably bots.

However, when I analyzed the MAC address from my own ufw.log (I was away from home but connected to a trusted Wi-Fi network) and checked it on macvendors.com, the result showed "Apple, Inc.". It turns out it was likely my girlfriend's iPad MAC address. I started questioning its security because it felt weird that an iPad was broadcasting network traffic to my laptop. I will definitely investigate her iPad later.

---

## 2. Creating a persistent environment variable

The second exercise was to create a persistent environment variable named COURSE_STATUS="during_the_course". The hint was to read about the ~/.bashrc and ~/.profile files.

As I knew before I can write it at the bottom of /.bashrc file to make them load when the new temrinal comes up and it loads the instructions inside.

So, I used the following command:

```bash
nano ~/.bashrc
```

And I added the following line at the very end of the file:

```bash
COURSE_STATUS="during_the_course"
```

However, what I didn't know before was that I needed to include the export keyword before the variable name to make it a true environment variable:

```bash
export COURSE_STATUS="during_the_course"
```

Regarding the difference between the two files mentioned in the hint:

```bash
~/.profile (Login Shell) - it loads only once when user logs into system. 
```

```bash
~/.bashrc (Interactive Non-Login Shell) - it loads every time a new interactive terminal window is opened.
```

---

## 3. Top 5 Users by Number of Processes

In this exercise, I had to create a single long command using pipes (|) that would:

    List all active processes.

    Cut only the first column (usernames).

    Sort the usernames alphabetically.

    Count the occurrences of each username (showing how many processes each user has).

    Sort the numerical results in descending order (from highest to lowest).

    Display only the first 5 lines.

The exercise hint was quite big because the author listed the exact commands and flags needed: cut, sort, uniq -c, and head. They even provided an example: ps aux | cut -d' ' -f1 | sort | uniq -c | sort -rn | head -5.

I automatically copied this long command:

```bash
ps aux | cut -d' ' -f1 | sort | uniq -c | sort -rn | head -5
```

and pasted it into my terminal. It worked perfectly fine. 

```bash
    222 root
     94 sane
      3 systemd+
      2 kernoops
      2 avahi
```

However, I was curious if there was something odd about this command, so I asked Google Gemini about it, and it compared it with another tool and found an interesting difference.

Instead of using:

```bash
cut -d' ' -f1
```

I could use:

```bash
awk '{print $1}'
```

When I tested both, they actually gave me the exact same result! But under the hood, there is a big difference. The command cut -d' ' -f1 cuts everything after the first space. It worked here only because the usernames are at the very beginning of the line. If there were multiple spaces between columns (like before the PID or %CPU columns to keep the table aligned), cut would break and return empty lines. On the other hand, awk automatically handles any number of spaces, making it much more reliable for this kind of task.

---

## 4. Identifying File Owner and Network Analysis (ss)

The goal of this exercise was to find which package provides the ss command (the modern replacement for netstat).

First, I checked where the ss binary is located using which:

```bash
which ss
Output: /usr/bin/ss
```

Then, I wanted to find the package that owns this file using dpkg -S. I had to use a wildcard (*bin/ss) because of how the system handles directory paths:

```bash
dpkg -S *bin/ss
Output: iproute2: /bin/ss
```

The command ss is provided by the iproute2 package, which is a core networking package in Ubuntu and was already installed on my system.

Next, I ran the command to check all active, listening TCP ports in a numeric format:

```bash
ss -ltn
```

My output:

```text
State      Recv-Q     Send-Q        Local Address:Port           Peer Address:Port     Process    
LISTEN     0          4096             127.0.0.54:53                0.0.0.0:*                  
LISTEN     0          4096              127.0.0.1:631               0.0.0.0:*                  
LISTEN     0          4096          127.0.0.53%lo:53                0.0.0.0:*                  
LISTEN     0          4096                  [::1]:631                  [::]:*
```

What these flags mean:

    -l (listening): Shows only sockets that are actively waiting for incoming connections.

    -t (TCP): Filters the results to show only TCP connections.

    -n (numeric): Shows raw port numbers and IP addresses instead of resolving them into service names (like showing 631 instead of ipp/cups).

My analysis of the open ports:

    Ports 53 (127.0.0.53 / 127.0.0.54): This is the standard DNS port. In Ubuntu, it is managed by systemd-resolved acting as a local DNS forwarder.

    Ports 631 (127.0.0.1 / [::1]): This is the CUPS service, which is the Common Unix Printing System responsible for managing printers. It listens only on localhost, meaning it's secured and not accessible from the outside network.

---

## 5. Log Cleanup Using find and xargs

The goal of this exercise was to find and safely delete all old, compressed log files (with the .gz extension) inside the /var/log directory using find, xargs, and rm.

Since rm is a dangerous command, I followed a safe 3-step DevOps approach to ensure no critical files were accidentally deleted.

#### Step 1: Verification (Dry Run)

First, I ran a simple search to list all .gz files and verify what find could see:

```bash
find /var/log/ -name "*.gz"
```

The output showed various compressed system logs (like syslog.2.gz, kern.log.3.gz, dpkg.log.2.gz). It also showed some Permission denied errors for restricted system folders, which is normal for a regular user.

#### Step 2: Simulating the Command with echo

Before executing the actual deletion, I piped the results into xargs echo sudo rm to preview the exact command that would be constructed:

```bash
find /var/log/ -name "*.gz" | xargs echo sudo rm
```

This safely displayed sudo rm followed by a single long line containing all the paths to the .gz files separated by spaces. This confirmed that xargs was grouping the arguments correctly.

#### Step 3: Execution and Final Verification

Once I verified the list of files was correct, I removed the echo and executed the real cleanup:

```bash
find /var/log/ -name "*.gz" | xargs sudo rm
```
To make sure that absolutely all files were gone—even inside the restricted directories—I did a final check using sudo find:

```bash
sudo find /var/log/ -name "*.gz"
```

The command returned absolutely nothing, confirming that every single compressed log file was successfully and safely removed from the system.
