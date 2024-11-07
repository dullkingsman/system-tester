#!/bin/bash                                                                                                                                                                                                    

source $(dirname $(realpath "$0"))/base.sh

log_muted_message "### Temperature and Fan Test ##############################################################################################"

# Check CPU temperature and fan speed
TEMP=$(sensors | grep -oP 'Package id 0:\s+\+\K[0-9]+')
FAN_SPEED=$(sensors | grep -oP 'fan1:\s+\+\K[0-9]+')

log_info "CPU Temperature: $TEMP°C"

# Check if FAN_SPEED is available
if [ -z "$FAN_SPEED" ]; then
    log_warn_message "Fan speed not available. Setting default value to 0 RPM."
    FAN_SPEED=0
else
    log_info "Fan Speed: $FAN_SPEED RPM"
fi

# Rating based on temperature and fan response
if [ "$TEMP" -le 60 ] && [ "$FAN_SPEED" -gt 1000 ]; then
    log_success_message "Temperature/Fan Rating: 5 (Excellent)"
elif [ "$TEMP" -le 70 ]; then
    log_info_message "Temperature/Fan Rating: 4 (Good)"
elif [ "$TEMP" -le 80 ]; then
    log_error_message "Temperature/Fan Rating: 3 (Average)"
elif [ "$TEMP" -le 90 ]; then
    log_error_message "Temperature/Fan Rating: 2 (Below Average)"
else
    log_error_message "Temperature/Fan Rating: 1 (Poor)"
fi
