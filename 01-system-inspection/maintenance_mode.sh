#!/usr/bin/env bash

set -u

#=====================================
# Name: The Maintenance Window Toggle
# Description: Toggle maintenance mode 
# Usage: ./maintenance_mode.sh <enable|disable|status>
#=====================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCK_FILE="$SCRIPT_DIR/maintenance.lock"

if [ $# -lt 1 ]; then
    echo "[ERROR] Action required. Usage: $0 <enable|disable|status>" >&2
    exit 1
fi

ACTION="$1"

case "$ACTION" in
    enable)
        if [ -f "$LOCK_FILE" ]; then
            echo "[WARN] Maintenance mode is ALREADY enabled." >&2
            exit 1
        fi

        echo "MAINTENANCE_ENABLED_AT=$(date '+%Y-%m-%d %H:%M:%S')" > "$LOCK_FILE"
        echo "[SUCCESS] Maintenance mode ENABLED (lock file created)."
        exit 0
        ;;
    disable)
        if [ ! -f "$LOCK_FILE" ]; then
            echo "[WARN] Maintenance mode is NOT active (nothing to disable)." >&2
            exit 1
        fi

        rm -f "$LOCK_FILE"
        echo "[SUCCESS] Maintenance mode DISABLED (traffic restored)."
        exit 0
        ;;
    status)
        if [ -f "$LOCK_FILE" ]; then
            echo "[ALERT] Maintenance mode is currently ACTIVE."
            cat "$LOCK_FILE"
            exit 0
        fi

        echo "[INFO] System is ONLINE (Maintenance mode is inactive)."
        exit 0
        ;;
    *)
        echo "[ERROR] Unrecognized action: '$ACTION'. Allowed: enable, disable, status" >&2
        exit 2
        ;;
esac

