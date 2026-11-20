#!/usr/bin/env bash

set -u

# ============================================
# Name: The Service Metric Extractor
# Description: We want to extract high-resource usage warnings from our web_server.log
# Usage: ./extract_metrics.sh [log_file]
# ============================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${1:-$SCRIPT_DIR/web_server.log}"

# Guard Clause
if [ ! -f "$LOG_FILE" ]; then
    echo "[ERROR] Log File '$LOG_FILE' does not exist." >&2
    exit 1
fi

MEMORY_WARNS=$(grep -i "warn" "$LOG_FILE" | grep -v -i "disk" || true)

if [ -z "$MEMORY_WARNS" ]; then
    echo "[INFO] No memory-related warnings found."
    exit 0
else
    # Count the warning lines
    WARN_COUNT=$(echo "$MEMORY_WARNS" | wc -l)
    # Print report
    echo "=== Memory Warning Report ==="
    echo "Target Log File : $LOG_FILE"
    echo "Alerts Detected : $WARN_COUNT"
    echo "-------------------------------------------"
    echo "$MEMORY_WARNS"
    echo "==========================================="
    exit 0
fi
