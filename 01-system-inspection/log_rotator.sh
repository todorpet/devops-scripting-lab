#!/usr/bin/env bash

set -u

#=============================
# Name: The Health-Check & Log Rotator
# Description: Inspect log file size, rotate old logs, and clean up
# Usage: ./log_rotator.sh <generate|check|rotate>
#============================= 

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/app.log"
ARCHIVE_FILE="$SCRIPT_DIR/app.log.old"

# Input validation
if [ -z "${1:-}" ]; then
    echo "[ERROR] Invalid or empty usage."
    exit 1
fi

# Action Dispatcher using case
case "$1" in
    generate)
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Health check OK - Status 200" >> "$LOG_FILE"
        echo "[SUCCESS] Appended new log entry to $LOG_FILE"
        exit 0
        ;;
    check)
        if [ -f "$LOG_FILE" ]; then
            LINE_COUNT=$(wc -l < "$LOG_FILE")
            echo "[INFO] Current log file has $LINE_COUNT entries."
            exit 0
        else
            echo "[INFO] No log file exists yet."
            exit 0
        fi
        ;;
    rotate)
        if [ ! -f "$LOG_FILE" ]; then
            echo "[WARN] Nothing to rotate. $LOG_FILE does not exist." >&2
            exit 1
        fi

        # If we made it past the check above, the file is guaranteed to exist!
        mv "$LOG_FILE" "$ARCHIVE_FILE"
        echo "[SUCCESS] Rotated $LOG_FILE to $ARCHIVE_FILE"
        exit 0
        ;;
    *)
        echo "[ERROR] Unrecognized action: '$1'. Allowed: generate, check, rotate" >&2
        exit 2
        ;;
esac

