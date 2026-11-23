#!/usr/bin/env bash

set -u

# ======================================================
# Name: The Automated Incident Dispatcher
# Description: Catch multiple severities and strip out health-check noise. audit specific user IDs without false positives. Calculate telemetry metrics. Save incident alerts in a report file.
# Usage: ./incident_dispatcher.sh <summary|audit-user|extract-severity|clean> [extra_arg]
# ======================================================

# Paths and file setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/web_server.log"
ALERT_LOG="$SCRIPT_DIR/critical_alerts.log"

# Guard Clause
if [ $# -lt 1 ]; then
    echo "[ERROR] Missing arguments. Usage: $0 <summary|audit-user|extract-severity|clean> [extra_arg]" >&2
    exit 1
fi

ACTION="$1"

# Check if LOG_FILE exists
if [ "$ACTION" != "clean" ] && [ ! -f "$LOG_FILE" ]; then
    echo "[ERROR] Log file '$LOG_FILE' does not exist." >&2
    exit 1
fi

# Action dispatcher
case "$ACTION" in
    summary)
        TOTAL=$(wc -l < "$LOG_FILE")
        INCIDENTS=$(grep -E "ERROR|CRITICAL|FATAL" "$LOG_FILE" | wc -l)
        # Print results
        echo "=== System Log Summary ==="
        echo "Log Target      : $LOG_FILE"
        echo "Total Events    : $TOTAL"
        echo "Total Incidents : $INCIDENTS"
        echo "=========================="
        exit 0
        ;;
    audit-user)
        if [ $# -lt 2 ]; then
            echo "[ERROR] User ID required. Usage: $0 audit-user <user-id>" >&2
            exit 1
        fi
        USER_ID="$2"
        # Find User events
        EVENTS=$(grep -w "$USER_ID" "$LOG_FILE" || true)
        # Check if any events are present and print them
        if [ -z "$EVENTS" ]; then
            echo "[INFO] No events found for user: $USER_ID"
            exit 0
        else
            COUNT=$(echo "$EVENTS" | wc -l)
            echo "=== User Audit: $USER_ID (Events: $COUNT) ==="
            echo "$EVENTS"
            exit 0
        fi
        ;;
    extract-severity)
        grep -E "CRITICAL|FATAL" "$LOG_FILE" | grep -v "/healthz" > "$ALERT_LOG"
        ALERT_COUNT=$(wc -l < "$ALERT_LOG")
        echo "[SUCCESS] Extracted $ALERT_COUNT critical alert(s) to: $ALERT_LOG"
        exit 0
        ;;
    clean)
        if [ -f "$ALERT_LOG" ]; then
            rm -f "$ALERT_LOG"
            echo "[SUCCESS] Cleaned up alert file."
            exit 0
        else
            echo "[INFO] No alert file to clean"
            exit 0
        fi
        ;;
    *)
        echo "[ERROR] Invalid action: '$ACTION'. Allowed: summary, audit-user, extract-severity, clean" >&2
        exit 2
        ;;
esac