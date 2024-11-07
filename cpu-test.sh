#!/bin/bash
  
source $(dirname $(realpath "$0"))/base.sh

log_muted_message "### CPU Test ##################################################################################################" 

# Check CPU info
lscpu | grep -E 'Model name|CPU MHz|CPU max MHz'
CPU_SPEED=$(lscpu | grep 'CPU max MHz' | awk '{print $4}')
log_info "Detected CPU Speed: $(log_muted_message $CPU_SPEED) MHz"

# Check if required packages are installed
if ! command -v sensors &> /dev/null; then
    log_info "Installing lm-sensors for temperature readings..."
    sudo apt install -y lm-sensors > /dev/null 2>&1
    sudo sensors-detect --auto > /dev/null 2>&1
fi
if ! command -v bc &> /dev/null; then
    log_info "Installing bc for calculations..."
    sudo apt install -y bc > /dev/null 2>&1
fi

# Stress Test CPU
log_info "Starting CPU stress test..."
sudo apt install -y stress > /dev/null 2>&1
stress --cpu 4 --timeout 60 &  # Stress CPU for 60 seconds
sleep 65

# Get CPU temperature
TEMP=$(sensors | grep -oP 'Package id 0:\s+\+\K[0-9]+')
log_info "Detected CPU Temperature: $TEMP°C"

# Ensure CPU_SPEED and TEMP are valid numbers before rating
if [[ -z "$CPU_SPEED" || -z "$TEMP" || ! "$CPU_SPEED" =~ ^[0-9]+([.][0-9]+)?$ || ! "$TEMP" =~ ^[0-9]+$ ]]; then
    log_error "Error: Unable to retrieve valid CPU speed or temperature."
    log_error_message "CPU Rating: 1 (Poor)"
    exit 1
fi

# Rating based on speed and temperature
if (( $(echo "$CPU_SPEED >= 2500" | bc -l) )) && [ "$TEMP" -le 80 ]; then
    log_success_message "CPU Rating: 5 (Excellent)"
elif (( $(echo "$CPU_SPEED >= 2000" | bc -l) )) && [ "$TEMP" -le 85 ]; then
    log_info_message "CPU Rating: 4 (Good)"
elif (( $(echo "$CPU_SPEED >= 1500" | bc -l) )); then
    log_warn_message "CPU Rating: 3 (Average)"
elif (( $(echo "$CPU_SPEED >= 1000" | bc -l) )); then
    log_error_message "CPU Rating: 2 (Below Average)"
else
    log_error_message "CPU Rating: 1 (Poor)"
fi
