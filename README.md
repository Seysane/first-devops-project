<h1 align="center">First DevOps Project</h1>

<p align="center">A project to learn DevOps practices</p>

## Table of Contents
- [About](#about)
- [Requirements](#requirements)
- [Installation](#installation)
- [Project Structure](#project-structure)

<h2 id="about">About <span style="float:right">🧠</span></h2>

This repository serves as my personal journal for learning DevOps practices.  
It was created to organize the structure, configuration, and tool automation that
I am mastering throughout the course.

<h2 id="requirements">Requirements <span style="float:right">📌</span></h2>

Before running anything, ensure your system has:
**OS:** Linux (Ubuntu recommended) or macOS
**Tools:** Git (required to clone this repository), Bash

<h2 id="installation">Installation <span style="float:right">🛠️</span></h2>

### Milestone 1: Environment & Core Tools Setup (Lesson 1)
**Target Script:** `scripts/setup.sh`
**What it does:** Automatically installs the core CLI tools, utilities and dependencies used throughout this course.
**How to run it:**
```bash
# Clone the repository using Git
git clone https://github.com/Seysane/first-devops-project

# Navigate to the project folder
cd first-devops-project

# Run the initialization
sudo apt update

# Grant permissions to the setup.sh file
chmod +x scripts/setup.sh

# Run script
./scripts/setup.sh

```

<h2 id="project-structure">Project Structure<span style="float:right">📂</span></h2>


```text
├── docs                      # Theoretical documentation of the project
│   ├── 03-linux-labs.md       # Homework exercises lesson 3
│   ├── 04-linux-labs.md       # Homework exercises lesson 4   
│   ├── 05-linux-labs.md       # Homework exercises lesson 5
│   ├── 06-linux-labs.md       # Homework exercises lesson 6
│   ├── 07-linux-labs.md       # Homework exercises lesson 7
│   ├── architecture.md        # DevOps Philosophy
│   ├── filesystem-notes.md    # Filesystem exploration notes
│   ├── metrics.md             # DORA Metrics definitions
│   └── tools.md               # List of installed tools
├── my_project                # Exercise directory for lesson 6
│   ├── cors-server.py         # Custom Python script overriding default handlers to inject CORS headers
├── my-server                 # Server directory
│   ├── check_server.sh        # Automated server availabilit Bash script
│   └── index.html             # File to work with exercise 1 lesson 5
├── README.md
├── scripts                   # Scripts to automate configuration
│   └── setup.sh               # Simple script installing tools used on course
├── src                        # Source code of the application 
└── tests                      # Infrastructure and code testing
```


