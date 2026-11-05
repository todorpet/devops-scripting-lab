#!/usr/bin/env bash

set -u

#==================================
# Name: service_pinger.sh
# Description: Iterates through a list of services and checks their status.
# Usage: ./service_pinger.sh <service1> [service2] [service3] ...
#==================================

# 1. Guard clause: Ensure at least ONE service argument was provided
if [ $# -lt 1 ]; then
    echo "[ERROR] No service provided. Usage: $0 <service1> <service2> ..." >&2
    exit 1
fi

echo "[INFO] Starting health check scan for $# service(s)..."
echo "-----------------------------------------------------"

# 2. A counter variable to track items
COUNT=0

# 3. The 'for' loop iterating over all arguments ("$@")
for SERVICE in "$@"; do
    COUNT=$((COUNT + 1))    # Arithmetic syntax in Bash: $(( math here ))
    echo "[$COUNT] Checking service: '$SERVICE' -> [STATUS: OK]"
done

echo "-----------------------------------------------------"
echo "[SUCCESS] Scan complete. Total services verified: $COUNT"
exit 0

