
# Linux System Health Monitor

## Project Overview

Linux System Health Monitor is a Bash-based automation project that monitors important system resources and generates system health reports.

It helps users monitor CPU usage, RAM usage, disk usage, and system uptime. It also identifies high resource utilization, maintains historical reports, and records monitoring activities in log files.

## Project Objectives

- Monitor essential Linux system resources.
- Identify high CPU, RAM, and disk utilization.
- Generate automated system health reports.
- Maintain timestamped historical reports.
- Record monitoring activities and errors in log files.
- Automatically remove historical reports older than 90 days.

## Features

- **CPU Monitoring:** Calculates CPU utilization and generates a warning when usage reaches 80% or above.
- **RAM Monitoring:** Displays total RAM, used RAM, and RAM utilization, with an 80% warning threshold.
- **Disk Monitoring:** Checks root filesystem disk usage and generates a warning at 80% or above.
- **Uptime Monitoring:** Displays system uptime in a human-readable format.
- **Health Status:** Displays the overall system status as HEALTHY or WARNING.
- **Report Generation:** Creates a system health report.
- **Historical Reports:** Saves timestamped copies of generated reports.
- **Logging:** Records monitoring activities, warnings, and errors.
- **Automatic Cleanup:** Deletes historical reports older than 90 days.
- **Error Handling:** Checks required commands and handles monitoring and report-generation failures.

## Technologies Used

- Linux (Ubuntu)
- Bash Shell Scripting
- Git
- GitHub
- Linux command-line utilities

## Project Structure

```text
linux-system-monitor/
│
├── scripts/
│   └── system_monitor.sh
│
├── reports/
│   └── system_report.txt
│
├── history/
│   └── timestamped reports
│
├── logs/
│   └── monitor.log
│
├── README.md
└── .gitignore
```

## Requirements

- Linux operating system
- Bash shell
- Required Linux commands:
  - bc
  - awk
  - df
  - free
  - top
  - grep
  - hostname
  - uptime
  - date
  - cp
  - find
  - mkdir

## How to Run

### 1. Clone the repository

```bash
git clone <your-github-repository-url>
```

### 2. Navigate to the project directory

```bash
cd linux-system-monitor
```

### 3. Run the monitoring script

```bash
bash scripts/system_monitor.sh
```

## Generated Reports

The project generates:

- **Latest Report:** `reports/system_report.txt`
- **Historical Reports:** Timestamped reports inside `history/`
- **Monitoring Logs:** `logs/monitor.log`

The latest report is updated every time the script runs.

Historical reports are maintained separately, and reports older than 90 days are automatically deleted.

## Sample Output

```text
=====================================
          SYSTEM HEALTH REPORT
          LINUX SYSTEM MONITOR
=====================================

SYSTEM INFORMATION
-------------------------------------
Date     : Wed Nov 25 12:13:55 AM IST 2026
Hostname : linux

CPU MONITORING
-------------------------------------
CPU Usage : 2.4%

RAM MONITORING
-------------------------------------
Total RAM : 3901 MB
Used RAM  : 318 MB
RAM Usage : 8.00%

DISK MONITORING
-------------------------------------
Disk Usage : 56%

UPTIME MONITORING
-------------------------------------
System Uptime : up 6 hours, 42 minutes

OVERALL SYSTEM STATUS
-------------------------------------
SYSTEM STATUS : HEALTHY
```

## Learning Outcomes

Through this project, I gained practical experience in:

- Linux command-line operations.
- Bash scripting and automation.
- CPU, RAM, disk, and uptime monitoring.
- Conditional statements and loops.
- Functions and variables in Bash.
- Error handling and exit codes.
- File management and log handling.
- Git and GitHub version control.

## Author

Developed as a hands-on Linux and DevOps learning project.
