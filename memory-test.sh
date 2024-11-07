#!/bin/bash                                                                                          
 
source $(dirname $(realpath "$0"))/base.sh

log_muted_message "### RAM Test ##################################################################################################"

# Check available memory
MEM_TOTAL=$(free -m | awk '/^Mem:/{print $2}')

log_info_message "$((($MEM_TOTAL / 1000) + 1)) GB of RAM"

# Memory Test
sudo apt install -y memtester > /dev/null 2>&1
memtester 256M 1 | grep -q 'ok' && MEM_OK=1 || MEM_OK=0  # Check for memory test success

# Rating based on memory availability and errors
if [ "$MEM_TOTAL" -ge 8192 ] && [ "$MEM_OK" -eq 1 ]; then
    log_success_message "RAM Rating: 5 (Excellent)"
elif [ "$MEM_TOTAL" -ge 4096 ] && [ "$MEM_OK" -eq 1 ]; then
    log_info_message "RAM Rating: 4 (Good)"
elif [ "$MEM_TOTAL" -ge 2048 ]; then
    log_warn_message "RAM Rating: 3 (Average)"
elif [ "$MEM_TOTAL" -ge 1024 ]; then
   	log_error_message "RAM Rating: 2 (Below Average)"
else
    log_error_message "RAM Rating: 1 (Poor)"
fi
