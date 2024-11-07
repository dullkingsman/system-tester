#!/bin/bash

source $(dirname $(realpath "$0"))/base.sh

log_muted_message "### GPU Test ##############################################################################################"

# Check GPU info
GPU_INFO=$(lspci | grep -i vga)
log_info "GPU Info: $GPU_INFO"

# Install glmark2 for GPU benchmarking
log_info "Installing glmark2 for GPU benchmark..."
sudo apt install -y glmark2 > /dev/null 2>&1

# Run glmark2 and get the GPU score
GPU_SCORE=$(glmark2 | grep -i 'glmark2 Score' | awk '{print $3}')

# Check if GPU score is available
if [ -z "$GPU_SCORE" ]; then
    log_error_message "Failed to retrieve GPU score from glmark2."
    log_error_message "GPU Rating: 1 (Poor)"
    exit 1
fi

log_info "GPU Score: $GPU_SCORE"

# Rating based on benchmark score
if [ "$GPU_SCORE" -ge 5000 ]; then
    log_success_message "GPU Rating: 5 (Excellent)"
elif [ "$GPU_SCORE" -ge 3000 ]; then
    log_info_message "GPU Rating: 4 (Good)"
elif [ "$GPU_SCORE" -ge 1000 ]; then
    log_error_message "GPU Rating: 3 (Average)"
elif [ "$GPU_SCORE" -ge 500 ]; then
    log_error_message "GPU Rating: 2 (Below Average)"
else
    log_error_message "GPU Rating: 1 (Poor)"
fi
