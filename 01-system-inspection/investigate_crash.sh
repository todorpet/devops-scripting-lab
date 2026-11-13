#!/usr/bin/env bash

set -u

#=================================================================
# Name: The Root Cause Incident Investigator
# Description: Script that takes a search and locates the line number, prints context lines and counts context events
# Usage: ./investigate_crash.sh <search_term> [context_lines] [log_file]
#=================================================================

if [ $# -lt 1 ]; then
    echo "[ERROR] Search term is missing. Usage: $0 <search_term> [context_lines] [log_file]" >&2
    exit 1
fi

SEARCH_TERM="$1"
CONTEXT_LINES="${2:-1}" # Default to 1 line before and after
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${3:-$SCRIPT_DIR/web_server.log}"
REPORT_FILE="$SCRIPT_DIR/incident_report.txt"

if [ ! -f "$LOG_FILE" ]; then
    echo "[ERROR] Log File '$LOG_FILE' does not exist." >&2
    exit 1
fi

# Capture output; use || true so script doesn't abort if nothing matches
INVESTIGATION_OUTPUT=$(grep -n -i -C "$CONTEXT_LINES" "$SEARCH_TERM" "$LOG_FILE" || true)

if [ -z "$INVESTIGATION_OUTPUT" ]; then
    echo "[INFO] No occurrences of '$SEARCH_TERM' found in '$LOG_FILE'."
    exit 0
else
    TOTAL_REPORT_LINES=$(echo "$INVESTIGATION_OUTPUT" | wc -l)
    echo "=== Incident Investigation Report ==="
    echo "Target Log File : $LOG_FILE"
    echo "Search Term     : '$SEARCH_TERM'"
    echo "Context Window  : +/- $CONTEXT_LINES line(s)"
    echo "Total Lines Extracted: $TOTAL_REPORT_LINES"
    echo "--------------------------------------------------------"
    echo "$INVESTIGATION_OUTPUT"
    echo "======================================="

    echo "$INVESTIGATION_OUTPUT" > "$REPORT_FILE"
    echo "[SUCCESS] Investigation report saved to: $REPORT_FILE"
    exit 0
fi

