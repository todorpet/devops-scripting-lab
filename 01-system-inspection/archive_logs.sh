#!/usr/bin/env bash

set -u

#=================================================================
# Name: The Disk Cleanup & Log Archive Simulator
# Description: Checking each file, and creating simulated backup/archive copies while skipping files that are empty
# Usage: ./archive_logs.sh [logs_directory]
#=================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGS_DIR="${1:-$SCRIPT_DIR/logs}"

if [ ! -d "$LOGS_DIR" ]; then
    echo "[ERROR] Directory does not exists." >&2
    exit 1
fi

PROCESSED_COUNT=0
SKIPPED_COUNT=0

for LOG_FILE in "$LOGS_DIR"/*.log; do
    # Guard: if no .log files match at all
    if [ ! -f "$LOG_FILE" ]; then
        echo "[INFO] No .log files found to process in '$LOGS_DIR'."
        exit 0
    fi

    FILE_NAME=$(basename "$LOG_FILE")

    # Check if file is empty (-s checks for size > 0)
    if [ ! -s "$LOG_FILE" ]; then
        echo "[SKIP] $FILE_NAME is empty (0 bytes). Skipping."
        SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
        continue
    fi

    # If it has data, simulate archiving by renaming to .bak
    mv "$LOG_FILE" "${LOG_FILE}.bak"
    echo "[ARCHIVED] $FILE_NAME -> ${FILE_NAME}.bak"
    PROCESSED_COUNT=$((PROCESSED_COUNT + 1))
done

echo "-----------------------------------"
echo "Archival Summary: $PROCESSED_COUNT archived, $SKIPPED_COUNT skipped (empty)"
exit 0

