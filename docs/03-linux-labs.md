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

# 3. Top 5 Users by Number of Processes

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
