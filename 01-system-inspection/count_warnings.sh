#!/usr/bin/env bash

set -u

#================================================================
# Name: The Threshold Log Alert
# Description: Counts how many warnings exist in a log file (case-insensitively) and compares it against an allowed threshold
# Usage: ./count_warnings.sh [log_file] [threshold]
#================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${1:-$SCRIPT_DIR/web_server.log}"

THRESHOLD="${2:-2}"

if [ ! -f "$LOG_FILE" ]; then
    echo "[ERROR] Destination file '$LOG_FILE' does not exist." >&2
    exit 1
fi

# Search case-insensitively (-i) and count matches (-c)
# We append '|| true' because grep returns exit code 1 if count is 0, which we don't want to break set -u
WARN_COUNT=$(grep -ic "warn" "$LOG_FILE" || true)

echo "[INFO] SCANNING '$LOG_FILE' for warnings (case-insensitive)..."
echo "[INFO] Found $WARN_COUNT warning(s). Allowed threshold is $THRESHOLD"

if [ "$WARN_COUNT" -gt "$THRESHOLD" ]; then
    echo "[ALERT] Warning count ($WARN_COUNT) EXCEEDED threshold ($THRESHOLD)!" >&2
    exit 1
else
    echo "[SUCCESS] Warning count ($WARN_COUNT) is within acceptable limits."
    exit 0
fi

