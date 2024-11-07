#!/bin/bash

source $(dirname $(realpath "$0"))/base.sh

log_muted_message "### Wi-Fi and Bluetooth Test ##############################################################################################"

# Check Wi-Fi and Bluetooth status
WIFI_STATUS=$(nmcli radio wifi)
BLUETOOTH_STATUS=$(rfkill list bluetooth | grep "Soft blocked: no" | wc -l)

log_info "Wi-Fi Status: $WIFI_STATUS"
log_info "Bluetooth Status: $BLUETOOTH_STATUS"

# Rating based on Wi-Fi and Bluetooth connectivity
if [ "$WIFI_STATUS" = "enabled" ] && [ "$BLUETOOTH_STATUS" -eq 1 ]; then
    log_success_message "Wi-Fi/Bluetooth Rating: 5 (Excellent)"
elif [ "$WIFI_STATUS" = "enabled" ]; then
    log_info_message "Wi-Fi/Bluetooth Rating: 3 (Average - No Bluetooth)"
else
    log_error_message "Wi-Fi/Bluetooth Rating: 1 (Poor - No Wi-Fi or Bluetooth)"
fi
