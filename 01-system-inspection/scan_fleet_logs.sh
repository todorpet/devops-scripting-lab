#!/usr/bin/env bash

set -u

# ============================================================
# Name: The Fleet Health Investigator
# Description: Scans .log files in a directory and count failed and healthy services
# Usage: ./scan_fleet_logs.sh [logs_directory]
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$SCRIPT_DIR}"

# Check if directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "[ERROR] The directory '$TARGET_DIR' does not exist." >&2
    exit 1
fi

# Scan for errors and for healthy logs
FAILING_LOGS=$(grep -l "\[ERROR\]" "$TARGET_DIR"/*.log || true)
HEALTHY_LOGS=$(grep -L "\[ERROR\]" "$TARGET_DIR"/*.log || true)

# Count failing services
if [ -z "$FAILING_LOGS" ]; then
    FAIL_COUNT=0
else
    FAIL_COUNT=$(echo "$FAILING_LOGS" | wc -l)
fi

# Count healthy services
if [ -z "$HEALTHY_LOGS" ]; then
    HEALTHY_COUNT=0
else
    HEALTHY_COUNT=$(echo "$HEALTHY_LOGS" | wc -l)
fi

# Display results
echo "=== Microservice Fleet Health Audit ==="
echo "Scanned Directory : $TARGET_DIR"
echo "Healthy Services  : $HEALTHY_COUNT"
echo "Failing Services  : $FAIL_COUNT"
echo "--------------------------------------------------"

# Print Failing services list if more than 0
if [ "$FAIL_COUNT" -gt 0 ]; then
    echo "[BROKEN SERVICES (Action Required)]:"
    echo "$FAILING_LOGS"
    echo "----------------------------------------------------"
    echo "[ALERT] Fleet contains broken services!" >&2
    exit 1
else
    echo "[SUCCESS] All microservices are healthy!"
    exit 0
fi
