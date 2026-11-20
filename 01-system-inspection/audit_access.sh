#!/usr/bin/env bash

set -u

#=================================================================================
# Name: The Security Access Auditor
# Description: Find unauthorized access attempts and filter out health-check noise
# Usage: ./audit_access.sh [log_file]
#=================================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${1:-$SCRIPT_DIR/access.log}"

# Guard clause
if [ ! -f "$LOG_FILE" ]; then
    echo "[ERROR] Log file '$LOG_FILE' does not exist." >&2
    exit 1
fi

TOTAL_REQUESTS=$(wc -l < "$LOG_FILE")

# Extract security violations
VIOLATION_LINES=$(grep -i -E "UNAUTHORIZED|FORBIDDEN" "$LOG_FILE" || true)

if [ -z "$VIOLATION_LINES" ]; then
    echo "[INFO] No unauthorized access attempts detected."
    exit 0
else
    VIOLATIONS_COUNT=$(echo "$VIOLATION_LINES" | wc -l)
    # Display report
    echo "=== Access Security Telemetry ==="
    echo "Log Target       : $LOG_FILE"
    echo "Total Requests   : $TOTAL_REQUESTS"
    echo "Violations Found : $VIOLATIONS_COUNT"
    echo "--------------------------------------------------------"
    echo "$VIOLATION_LINES"
    echo "--------------------------------------------------------"
    echo "[ALERT] Security violations detected" >&2
    exit 1
fi
