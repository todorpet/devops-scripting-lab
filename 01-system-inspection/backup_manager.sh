#!/usr/bin/env bash

#===========================
# Name: The Deployment Backup Manager
# Descirption: Creating backups for critical directories or files before deployment
# Usage: ./backup_manager.sh
#===========================

# Get directory and path resolution
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_FILE="$SCRIPT_DIR/database.conf"
BACKUP_FILE="$SCRIPT_DIR/database.conf.bak"

# Input validation
if [ -z "$1" ]; then
    echo "[ERROR] Action missing. Usage: $0 <backup|verify\clean>" >&2
    exit 1
fi

# Dispatcher using case
case "$1" in
    backup)
        if [ -f "$TARGET_FILE" ]; then
            cp "$TARGET_FILE" "$BACKUP_FILE"
            echo "[SUCCESS] Backup created at: $BACKUP_FILE"
            exit 0
        else
            echo "[ERROR] Source file '$TARGET_FILE' does not exist. Cannot backup." >&2
            exit 1
        fi
        ;;
    verify)
        if [ -f "$BACKUP_FILE" ]; then
            echo "[INFO] VAlid backup exists at: $BACKUP_FILE"
            exit 0
        else
            echo "[WARN] No backup found at: $BACKUP_FILE" >&2
            exit 1
        fi
        ;;
    clean)
        if [ -f "$BACKUP_FILE" ]; then
            rm "$BACKUP_FILE" && echo "[SUCCESS] Backup file cleaned up." && exit 0
        else
            echo "[INFO] Nothing to clean. Backup does not exist." && exit 0
        fi
        ;;
    *)
        echo "[ERROR] Unrecognized command: '$1'. Allowed: backup, verify, clean" >&2
        exit 2
        ;;
esac

