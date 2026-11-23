#!/usr/bin/env bash

set -u

# =================================================================
# Name: The Targeted User Audit Tool
# Description: Search specific User ID with -w and filter lines that start with 2026. Count the lines wc -l and echo the results
# Usage: ./audit_user_events.sh <user_id> [log_file]
# =================================================================

# Input Guard Clause
if [ $# -lt 1 ]; then
    echo "[ERROR] User input is missing. Usage $0 <user_id> [log_file]" >&2
    exit 1
fi

TARGET_USER="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${2:-$SCRIPT_DIR/web_server.log}"

# Check if LOG_FILE exists
if [ ! -f "$LOG_FILE" ]; then
     echo "[ERROR] Log File '$LOG_FILE' does not exist." >&2
     exit 1
fi

# Pipeline anchor
USER_EVENTS=$(grep "^2026" "$LOG_FILE" | grep -w "$TARGET_USER" || true)

# Check if we have any matches
if [ -z "$USER_EVENTS" ]; then
    echo "[INFO] No audit events found for User ID '$TARGET_USER'."
    exit 0
else
    EVENT_COUNT=$(echo "$USER_EVENTS" | wc -l)
    # Print the results
    echo "=== User Audit Trial: $TARGET_USER ==="
    echo "Log Source   : $LOG_FILE"
    echo "Total Events : $EVENT_COUNT"
    echo "-------------------------------------------------------------"
    echo "$USER_EVENTS"
    echo "======================================"
    exit 0
fi

