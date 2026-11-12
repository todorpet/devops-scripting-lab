#!/usr/bin/env bash

set -u

#=============================================================
# Name: The Log Noise Filter
# Description: Filters out noisy patterns and save the "clean" output to a new file
# Usage: ./filter_noise.sh [input_log]
#=============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_LOG="${1:-$SCRIPT_DIR/web_server.log}"
OUTPUT_LOG="${2:-$SCRIPT_DIR/cleaned_events.log}"

if [ ! -f "$INPUT_LOG" ]; then
    echo "[ERROR] Input log file '$INPUT_LOG' does not exist. Usage: $0 [input_log]" >&2
    exit 1
fi

ORIGINAL_LINES=$(wc -l < "$INPUT_LOG")

# Filter noise with chained grep -v command and send it to a new Output file
grep -v "/healthz" "$INPUT_LOG" | grep -v "DEBUG" > "$OUTPUT_LOG"

CLEANED_LINES=$(wc -l < "$OUTPUT_LOG")

REMOVED_LINES=$((ORIGINAL_LINES - CLEANED_LINES))

# Report summary
echo "[INFO] Noise filtering complete!"
echo "--------------------------------------------------"
echo "Original lines : $ORIGINAL_LINES"
echo "Cleaned lines  : $CLEANED_LINES"
echo "Noise removed  : $REMOVED_LINES line(s)"
echo "Clean log saved: $OUTPUT_LOG"
echo "--------------------------------------------------"
exit 0

