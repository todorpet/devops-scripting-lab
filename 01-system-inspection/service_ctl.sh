#!/usr/bin/env bash

#============================================
# Name: A Service Control Script 
# Description: CLI wrapper to manage services
# Usage: ./service_ctl.sh <start|stop|status>
#============================================

# Define script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$SCRIPT_DIR/service.pid"

if [ -z "$1" ]; then
    echo "[ERROR] Action required. Usage: $0 <start|stop|status>" >&2
    exit 1
fi

case "$1" in
    start)
        if [ -f "$PID_FILE" ]; then
            echo "[WARN] Service is already running." >&2
            exit 1
        else
            touch "$PID_FILE" && echo "[SUCCESS] Service started successfully."
            exit 0
        fi
        ;;
    stop)
        if [ -f "$PID_FILE" ]; then
            rm "$PID_FILE"
            echo "[SUCCESS] Service stopped successfully"
            exit 0
        else
            echo "[WARN] Service is not running (nothing to stop)." >&2
            exit 1
        fi
        ;;
    status)
        if [ -f "$PID_FILE" ]; then
            echo "[INFO] Service is RUNNING."
            exit 0
        else
            echo "[INFO] Service is STOPPED."
            exit 0
        fi
        ;;
    *)
        echo "[ERROR] Invalid command: '$1'. Allowed: start, stop, status" >&2
        exit 2
        ;;
esac

