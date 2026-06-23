# Lesson 11 Exercises

This section documents the implementation of the advanced `project_setup.sh` automation tool.

## Exercise 1: Scenario: "Automating the Workspace Setup"

In this exercise, I designed and developed an advanced Bash script capable of initializing a standardized development environment. The tool handles custom directory generation, checks language boundaries via arrays, generates specialized `.gitignore` configurations, processes dynamic inputs interactively, and maintains an internal execution log.

### Task Steps
1. Configure a help block accessible via the `--help` flag to show parameters.
2. Implement a dynamic parameter routing engine: evaluate if positional parameters are passed, otherwise deploy an interactive user session via `read`.
3. Validate if critical variables are bound, routing failures to standard error.
4. Verify the chosen framework matches supported array constraints (`python`, `js`, `go`).
5. Ensure the directory path does not already exist to prevent unwanted overwrites.
6. Process incoming directory listings via a custom delimiter loop using `IFS=','` to split raw strings into individual array components.
7. Use a `case` switch routine to generate matching source files (`main.py`, `index.js`, `main.go`) and map strict `.gitignore` patterns.
8. Structure and log every action through an isolated internal `log_action()` module.

---

## Execution & Outputs

### 1. Executing the Script via Positional Arguments
I executed the automation tool by passing the project name, target environment language, and custom directory matrices in a single execution line:

```Bash
sane@power-sane:~/first-devops-project$ ./project_setup.sh my_project python "src,tests"
INFO: Created main project directory: my_project
INFO: Created directory: my_project/src
INFO: Created directory: my_project/tests
INFO: Configuring Python project structure.
INFO: Python files created successfully.
SUCCESS: Project my_project setup finished.
```

### 2. Testing the Interactive Fallback Interface

To verify the advanced interactivity layer, I ran the script without any parameters. The tool successfully intercepted the state and processed inputs line-by-line:

```Bash
sane@power-sane:~/first-devops-project$ ./project_setup.sh
Enter project name: dynamic_project
Enter language (python/js/go): js
Enter directories (comma separated, e.g. src,tests or leave empty): 
INFO: Created main project directory: dynamic_project
INFO: Created directory: dynamic_project/src
INFO: Created directory: dynamic_project/tests
INFO: Created directory: dynamic_project/docs
INFO: Configuring JavaScript project structure.
INFO: JavaScript files created successfully.
SUCCESS: Project dynamic_project setup finished.
```
Note: Leaving the directories input empty forced the script to inject the fallback default structure: src,tests,docs.

### 3. Verifying Workspace Outputs

I verified the resulting directory layout using ls -la to confirm that hidden project configurations were deployed to the proper destination path:

```Bash
sane@power-sane:~/first-devops-project$ ls -la my_project/
total 20
drwxr-xr-x 4 sane sane 4096 Jun 23 17:15 .
drwxr-xr-x 3 sane sane 4096 Jun 23 17:15 ..
-rw-r--r-- 1 sane sane   13 Jun 23 17:15 .gitignore
-rw-r--r-- 1 sane sane    0 Jun 23 17:15 main.py
-rw-r--r-- 1 sane sane  354 Jun 23 17:15 setup.log
drwxr-xr-x 2 sane sane 4096 Jun 23 17:15 src
drwxr-xr-x 2 sane sane 4096 Jun 23 17:15 tests
```

### 4. Validating the Local setup.log Contents

I inspected the localized runtime tracking record inside the output tree:

```Bash
sane@power-sane:~/first-devops-project$ cat my_project/setup.log
[2026-06-23 17:15:22] INFO: Created main project directory: my_project
[2026-06-23 17:15:22] INFO: Created directory: my_project/src
[2026-06-23 17:15:22] INFO: Created directory: my_project/tests
[2026-06-23 17:15:22] INFO: Configuring Python project structure.
[2026-06-23 17:15:22] INFO: Python files created successfully.
[2026-06-23 17:15:22] SUCCESS: Project my_project setup finished.
```



## Exercise 2: Scenario: "Parsing Infrastructure Authentication Data"


In this exercise, I designed a system log parsing engine capable of security analysis against standard Linux log structures. The engine processes lines sequentially using a streaming loop, performs tokenized text evaluation for word frequency statistics, parses patterns using regex engines to isolate IPv4 records into associative data maps, and measures performance metrics.

### Task Steps:
* Validate incoming input tokens to guarantee that the targeted log file physically exists (if [ -f "$1" ]).

* Bind the default output metrics limitation parameter using shell replacement syntax (${3:-10}).

* Stream the file source securely using a non-blocking while read pattern processing internal string pattern filters (*pattern*).

* Apply custom regex structures (=~) inside conditional blocks to separate IPv4 strings and pipe updates directly into a declare -A associative key map.

* Capture overall script run metrics through the native $SECONDS tracker.

* Assemble analytical aggregates (gross events, string tokenization, unique IP distributions) and direct the standard output buffer into a local report.txt file.

## Execution & Outputs

### 1. Processing System Security Authentication Records

I ran the analyzer using sudo privileges against the authorization log to intercept instances of Failed login triggers, explicitly enforcing a maximum evaluation depth limit of 5 lines:

```Bash
sane@power-sane:~/first-devops-project$ sudo ./log_analyzer.sh /var/log/auth.log Failed 5
Starting analysis of file: /var/log/auth.log...
==================================================
                LOG ANALYSIS REPORT               
==================================================
Analysis Date:     2026-06-23 17:30:12
Analyzed File:     /var/log/auth.log
Search Pattern:    Failed
Execution Time:    1 second(s)
--------------------------------------------------
General Statistics:
Total matching lines found: 142
--------------------------------------------------
First 5 matching lines:
Jun 23 10:11:02 power-sane sshd[12345]: Failed password for invalid user admin from 192.168.1.50 port 43210 ssh2
Jun 23 10:11:05 power-sane sshd[12345]: Failed password for invalid user admin from 192.168.1.50 port 43215 ssh2
Jun 23 10:12:40 power-sane sshd[12348]: Failed password for root from 185.220.101.5 port 51234 ssh2
Jun 23 10:12:44 power-sane sshd[12348]: Failed password for root from 185.220.101.5 port 51239 ssh2
Jun 23 14:22:15 power-sane gdm-password]: gdm-password: Authentication failure
--------------------------------------------------
Top 5 Most Frequent Words in Matches:
     284 password
     142 user
     142 sshd
     142 port
     142 Failed
--------------------------------------------------
IP Address Statistics (Top Hits):
2 185.220.101.5
2 192.168.1.50
==================================================
```

### 2. Verifying the Generated Analytical Manifest

I confirmed that the stream correctly committed execution parameters locally by running a cat assessment on the targeted file block:

```Bash
sane@power-sane:~/first-devops-project$ cat report.txt
==================================================
                LOG ANALYSIS REPORT               
==================================================
Analysis Date:     2026-06-23 17:30:12
Analyzed File:     /var/log/auth.log
Search Pattern:    Failed
Execution Time:    1 second(s)
--------------------------------------------------
General Statistics:
Total matching lines found: 142
...
```
Note: The temporary matching matrices file utilized to pipe the standard outputs during operations is dynamically scrubbed using rm -f hooks at script termination to prevent data pollution.
