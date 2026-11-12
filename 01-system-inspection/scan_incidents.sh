#!/usr/bin/env bash

set -u

#========================================================
# Name: The Critical Incident Scanner
# Description: Scans a log file for multiple keywords, count number of incidents occurred, count the total words in the errors
# Usage: ./scan_incidents.sh [log_file]
#========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${1:-$SCRIPT_DIR/web_server.log}"

if [ ! -f "$LOG_FILE" ]; then
    echo "[ERROR] Missing log file $LOG_FILE. Usage: $0 [log_file]" >&2
    exit 1
fi

TOTAL_LINES=$(wc -l < "$LOG_FILE")
TOTAL_WORDS=$(wc -w < "$LOG_FILE")

SEVERITY_PATTERN="ERROR|CRITICAL|FATAL|PANIC"

INCIDENT_LINES=$(grep -E "$SEVERITY_PATTERN" "$LOG_FILE" || true)

if [ -z "$INCIDENT_LINES" ]; then
    INCIDENT_COUNT=0
    INCIDENT_WORDS=0
else
    INCIDENT_COUNT=$(echo "$INCIDENT_LINES" | wc -l)
    INCIDENT_WORDS=$(echo "$INCIDENT_LINES" | wc -w)
fi

echo "=== Log File Telemetry ==="
echo "Target File    : $LOG_FILE"
echo "Total Log Lines: $TOTAL_LINES ($TOTAL_WORDS words)"
echo "--------------------------------------------------------"
echo "Pattern Filter : $SEVERITY_PATTERN"
echo "Incidents Found: $INCIDENT_COUNT ($INCIDENT_WORDS words)"
echo "=========================="

if [ "$INCIDENT_COUNT" -gt 0 ]; then
    echo "[INCIDENT LOGS]:"
    echo "$INCIDENT_LINES"
    echo "--------------------------------------------------------"
    echo "[ALERT] High-severity incidents detected! Immediate action required." >&2
    exit 1
else
    echo "[SUCCESS] All systems operational. Zero critical incidents."
    exit 0
fi


