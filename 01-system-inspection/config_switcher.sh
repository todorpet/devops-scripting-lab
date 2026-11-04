#!/usr/bin/env bash

set -u

#===================================================
# Name: The Environment Config Switcher
# Description: Swap configuration files based on the deployment target
# Usage: ./config_switcher.sh <dev|prod|status|reset>
#=================================================== 

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACTIVE_CONFIG="$SCRIPT_DIR/.env"

if [ $# -lt 1 ]; then
    echo "[ERROR] Action required. Usage: $0 <dev|prod|status|reset>" >&2
    exit 1
fi

MODE="$1"

case "$MODE" in
    dev)
        echo "APP_ENV=development" > "$ACTIVE_CONFIG"
        echo "DEBUG=true" >> "$ACTIVE_CONFIG"
        echo "[SUCCESS] Switched active configuration to DEVELOPMENT."
        exit 0
        ;;
    prod)
        echo "APP_ENV=production" > "$ACTIVE_CONFIG"
        echo "DEBUG=false" >> "$ACTIVE_CONFIG"
        echo "[SUCCESS] Switched active configuration to PRODUCTION"
        exit 0
        ;;
    status)
        if [ ! -f "$ACTIVE_CONFIG" ]; then
            echo "[WARN] No active .env configuration found." >&2
            exit 1
        fi

        echo "[INFO] Current active configuration:"
        cat "$ACTIVE_CONFIG"
        exit 0
        ;;
    reset)
        if [ -f "$ACTIVE_CONFIG" ]; then
            rm -f "$ACTIVE_CONFIG"
            echo "[SUCCESS] Active configuration reset (file removed)."
            exit 0
        else
            echo "[INFO] Nothing to reset. No active configuration file."
            exit 0
        fi
        ;;
    *)
        echo "[ERROR] Unrecognized mode: '$MODE'. Allowed: dev, prod, status, reset" >&2
        exit 2
        ;;
esac

