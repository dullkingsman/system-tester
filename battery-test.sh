#!/bin/bash                                                                                                                                                                                                    

source $(dirname $(realpath "$0"))/base.sh

log_muted_message "### Battery Test ##############################################################################################"

# Check battery capacity and cycle count
BATTERY_INFO=$(upower -i $(upower -e | grep BAT))
FULL_CAPACITY=$(echo "$BATTERY_INFO" | grep "capacity:" | awk '{print $2}' | cut -d'%' -f1)
CYCLE_COUNT=$(echo "$BATTERY_INFO" | grep "cycle count:" | awk '{print $3}')

log_info "capacity: $FULL_CAPACITY"
log_info "cycle count: $CYCLE_COUNT"

# Handle case where cycle count is not available
if [ -z "$CYCLE_COUNT" ]; then
    log_warn_message "Cycle count not available. Using default value of 0."
    CYCLE_COUNT=0
fi

# Rating based on battery capacity and cycle count
# Using bc for floating point comparison
if (( $(echo "$FULL_CAPACITY >= 90" | bc -l) )) && [ "$CYCLE_COUNT" -lt 100 ]; then
    log_success_message "Battery Rating: 5 (Excellent)"
elif (( $(echo "$FULL_CAPACITY >= 80" | bc -l) )) && [ "$CYCLE_COUNT" -lt 300 ]; then
    log_info_message "Battery Rating: 4 (Good)"
elif (( $(echo "$FULL_CAPACITY >= 60" | bc -l) )); then
    log_error_message "Battery Rating: 3 (Average)"
elif (( $(echo "$FULL_CAPACITY >= 40" | bc -l) )); then
    log_error_message "Battery Rating: 2 (Below Average)"
else
    log_error_message "Battery Rating: 1 (Poor)"
fi
