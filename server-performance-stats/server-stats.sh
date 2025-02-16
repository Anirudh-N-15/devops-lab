#!/bin/bash

print_header() {
  echo "============================================================"
  echo "Server Performance Stats - $(date)"
  echo "============================================================"
}

get_cpu_usage() {
  echo "CPU Usage:"
  cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
  echo "Total CPU Usage: $cpu_usage%"
  echo
}

get_memory_usage() {
  echo "Memory Usage:"
  free -m | awk 'NR==2{printf "Used: %s MB (%.2f%%), Free: %s MB\n", $3, $3*100/$2, $4}'
  echo
}

get_disk_usage() {
  echo "Disk Usage:"
  df -h --total | grep "total" | awk '{printf "Used: %s (%s), Free: %s\n", $3, $5, $4}'
  echo
}

get_top_cpu_processes() {
  echo "Top 5 Processes by CPU Usage:"
  ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
  echo
}

get_top_memory_processes() {
  echo "Top 5 Processes by Memory Usage:"
  ps -eo pid,comm,%mem --sort=-%mem | head -n 6
  echo
}

get_additional_info() {
  echo "Additional System Information:"
  
  os_version=$(cat /etc/os-release | grep "^PRETTY_NAME" | cut -d= -f2 | tr -d '"')
  echo "OS Version: $os_version"
  
  uptime_info=$(uptime -p)
  echo "Uptime: $uptime_info"
  
  load_avg=$(uptime | awk -F'load average:' '{print $2}' | xargs)
  echo "Load Average: $load_avg"
  
  logged_in_users=$(who | wc -l)
  echo "Logged-in Users: $logged_in_users"
  
  if [ "$(id -u)" -eq 0 ]; then
    failed_logins=$(grep "Failed password" /var/log/auth.log | wc -l)
    echo "Failed Login Attempts: $failed_logins"
  else
    echo "Failed Login Attempts: [Run script as root to view this info]"
  fi
  echo
}

print_header
get_cpu_usage
get_memory_usage
get_disk_usage
get_top_cpu_processes
get_top_memory_processes
get_additional_info