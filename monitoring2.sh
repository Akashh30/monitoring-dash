#!/bin/bash

# Function to display the top 10 applications consuming the most CPU and memory
top_10_apps() {
    echo "Top 10 CPU consuming applications:"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 11
    
    echo "Top 10 Memory consuming applications:"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 11
}

# Function to monitor network statistics
network_monitoring() {
    echo "Number of concurrent connections:"
    ss -s | grep "TCP:" | awk '{print $2}'
    
    echo "Packet drops:"
    netstat -i | grep "drop"
    
    echo "Network usage (MB in and out):"
    ifconfig eth0 | awk '/RX bytes/ {print "In: " $3/1024/1024 " MB, Out: " $7/1024/1024 " MB"}'
}

# Function to display disk usage and highlight partitions using more than 80% of space
disk_usage() {
    echo "Disk Usage:"
    df -h | awk '$5+0 > 80 {print $1 " is using " $5 " of the disk space!"}'
}

# Function to display system load and CPU usage breakdown
system_load() {
    echo "Current Load Average:"
    uptime
    
    echo "CPU Usage Breakdown:"
    mpstat | grep -A 5 "%idle"
}

# Function to display memory usage including swap
memory_usage() {
    echo "Memory Usage:"
    free -h
    
    echo "Swap Usage:"
    vmstat -s | grep "swap"
}

# Function to monitor the number of active processes and top 5 consuming processes
process_monitoring() {
    echo "Number of active processes:"
    ps aux | wc -l
    
    echo "Top 5 CPU consuming processes:"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
    
    echo "Top 5 Memory consuming processes:"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
}

# Function to check the status of essential services
service_monitoring() {
    echo "Service Status:"
    for service in sshd nginx iptables; do
        echo -n "$service: "
        systemctl is-active $service
    done
}

# Main script to call functions based on command-line arguments
case "$1" in
    -cpu) top_10_apps ;;
    -network) network_monitoring ;;
    -disk) disk_usage ;;
    -load) system_load ;;
    -memory) memory_usage ;;
    -process) process_monitoring ;;
    -services) service_monitoring ;;
    *)
        echo "Usage: $0 {-cpu|-network|-disk|-load|-memory|-process|-services}"
        exit 1
    ;;
esac
