#!/bin/bash
# Function to record timestamped messages in the log file
log_message() {
    echo "[$(date '+%d-%m-%Y %H:%M:%S')] $1" >> logs/monitor.log
}

# Directory Checking
if ! mkdir -p reports logs history; then
    log_message "ERROR : Unable to create required directories"
    echo "ERROR : Unable to create required directories"
    exit 1
fi

# Verify that all required system commands are available
required_commands=("bc" "awk" "df" "free" "top" "grep" "hostname" "uptime" "date" "cp" "find" "mkdir")
for cmd in "${required_commands[@]}"; do
    if ! command -v "$cmd" > /dev/null 2>&1; then
        log_message "ERROR : Required command '$cmd' is not installed."
        echo "ERROR : Required command '$cmd' is not installed."
        exit 1
    fi
done

log_message "INFO : Monitoring Started"

# Initialize overall system health status as HEALTHY
system_status="HEALTHY"

# Generate a unique timestamp for the historical report filename
report_time=$(date '+%d-%b-%Y_%I-%M-%S-%p')_$$

# REPORT GENERATION
if ! cat > reports/system_report.txt <<EOF

=====================================
          SYSTEM HEALTH REPORT
          LINUX SYSTEM MONITOR
=====================================

SYSTEM INFORMATION
-------------------------------------
Date     : $(date)
Hostname : $(hostname)

CPU MONITORING
-------------------------------------
EOF
then
    log_message "ERROR : Unable to create system report"
    echo "ERROR : Unable to create system report"
    exit 1
fi

echo "=====================================" 
echo "     LINUX SYSTEM HEALTH MONITOR     " 
echo "=====================================" 
echo " "
echo "Hostname : $(hostname)"
echo " "

echo "CPU Monitoring"
# Calculate CPU usage using the idle percentage reported by top
idle=$(top -bn1 | grep "%Cpu(s)" | awk -F',' '{print $4}' | awk '{print $1}')
cpu_usage=$(echo "100 - $idle" | bc)
if [ $? -ne 0 ] || [ -z "$cpu_usage" ]; then
    log_message "ERROR : CPU calculation failed"
    echo "ERROR : CPU calculation failed"
    exit 1
fi
{
    echo "CPU Usage : $cpu_usage%"
    echo ""
} >> reports/system_report.txt
echo "CPU Usage : $cpu_usage%"
if (( $(echo "$cpu_usage >= 80" | bc -l) )); then
    system_status="WARNING"
    log_message "WARNING : CPU usage reached 80% or above"
    echo "WARNING : High CPU usage detected"
fi
log_message "INFO : CPU Monitoring Completed"
echo " "

echo "RAM Monitoring"
# Retrieve total and used RAM and calculate memory utilization
read total used < <(free -m | awk '/^Mem:/ {print $2 " " $3}')
ram_usage=$(echo "scale=2; ($used / $total) * 100" | bc)
if [ $? -ne 0 ] || [ -z "$ram_usage" ] || [ "$total" -eq 0 ]; then
    log_message "ERROR : RAM calculation failed"
    echo "ERROR : RAM calculation failed"
    exit 1
fi
{
    echo ""
    echo "RAM MONITORING"
    echo "-------------------------------------"
    echo "Total RAM : $total MB"
    echo "Used RAM  : $used MB"
    echo "RAM Usage : $ram_usage%"
} >> reports/system_report.txt
echo "Total RAM : $total MB"
echo "Used RAM : $used MB"
echo "RAM usage : $ram_usage%"
if (( $(echo "$ram_usage >= 80" | bc -l) )); then
    system_status="WARNING"
    log_message "WARNING : RAM usage reached 80% or above"
    echo "WARNING : High RAM usage detected"
fi
log_message "INFO : RAM Monitoring Completed"
echo " "

echo "DISK Monitoring"
# Retrieve disk usage for the root filesystem
if ! disk_output=$(df -P / ); then
    log_message "ERROR : Disk monitoring failed"
    echo "ERROR : Disk monitoring failed"
    exit 1
fi

disk_usage=$(echo "$disk_output" | awk 'NR==2 {print $5}')

if [[ ! "$disk_usage" =~ ^[0-9]+%$ ]]; then
    log_message "ERROR : Invalid disk usage value"
    echo "ERROR : Invalid disk usage value"
    exit 1
fi
{
    echo ""
    echo ""
    echo "DISK MONITORING"
    echo "-------------------------------------"
    echo "Disk Usage : $disk_usage"
} >> reports/system_report.txt
echo "Disk Usage : $disk_usage"
# Remove the percentage symbol to compare disk usage numerically
disk_percentage=${disk_usage%\%}
if [ "$disk_percentage" -ge 80 ]; then
    system_status="WARNING"
    log_message "WARNING: Disk usage reached 80% or above"
    echo "WARNING : High disk usage detected"
fi
log_message "INFO : Disk Monitoring Completed"
echo " "

echo "Uptime Monitoring"
# Retrieve system uptime in a human-readable format
if ! system_uptime=$(uptime -p); then
    log_message "ERROR : Uptime monitoring failed"
    echo "ERROR : Uptime monitoring failed"
    exit 1
fi

if [ -z "$system_uptime" ]; then
    log_message "ERROR : Invalid uptime value"
    echo "ERROR : Invalid uptime value"
    exit 1
fi
{
    echo ""
    echo ""
    echo "UPTIME MONITORING"
    echo "-------------------------------------"
    echo "System Uptime : $system_uptime"
} >> reports/system_report.txt


echo "System Uptime : $system_uptime"
log_message "INFO : Uptime Monitoring Completed"

# Overall System Health Status
echo " "
echo " "
echo "====================================="
echo "SYSTEM STATUS : $system_status"

{
    echo ""
    echo ""
    echo "OVERALL SYSTEM STATUS"
    echo "-------------------------------------"
    echo "SYSTEM STATUS : $system_status"
    echo ""
    echo ""
    echo "====================================="
    echo "             END OF REPORT"
    echo "====================================="
    echo ""
} >> reports/system_report.txt
# Log the final overall system health status
if [ "$system_status" = "WARNING" ]; then
    log_message "WARNING : System health status is WARNING"
else
    log_message "INFO : System health status is HEALTHY"
fi

# Save a timestamped copy of the latest system report
if cp reports/system_report.txt "history/report_$report_time.txt"; then
    log_message "INFO : Historical report saved successfully"
else
    log_message "ERROR : Failed to save historical report"
    echo "ERROR : Failed to save historical report"
    exit 1
fi

# Delete historical reports older than 90 days
if find history -type f -name 'report_*.txt' -mmin +129600 -delete; then
    log_message "INFO : Historical report cleanup completed"
else
    log_message "ERROR : Historical report cleanup failed"
    echo "ERROR : Historical report cleanup failed"
    exit 1
fi

log_message "INFO : Monitoring Completed Successfully"
