#!/usr/bin/env bash

set -u

#========================================================
# Name: The Log Error Finder
# Description: Searches a log file for lines matching [ERROR] and displays them.
# Usage: ./find_errors.sh [log_file_path]
#========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${1:-$SCRIPT_DIR/web_server.log}"

if [ ! -f "$LOG_FILE" ]; then
    echo "[ERROR] Destination file '$LOG_FILE' does not exist." >&2
    exit 1
fi

echo "[INFO] Scanning '$LOG_FILE' for errors..."
echo "--------------------------------------------------------"

# Run grep and capture the output
ERROR_LINES=$(grep "\[ERROR\]" "$LOG_FILE")
GREP_EXIT=$?

if [ $GREP_EXIT -eq 0 ]; then
    echo "$ERROR_LINES"
    echo "--------------------------------------------------------"
    echo "[ALERT] Errors were found in the log file!" >&2
    exit 1
else
    echo "[SUCCESS] No errors found in the log file."
    exit 0
fi 
