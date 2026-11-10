#!/usr/bin/env bash

set -u

#===============================================
# Name: The Script Permissions Auditor 
# Description: Script that audits all .sh files in a given directory
# Usage: ./audit_permissions.sh [directory_path]
#====================================== ========

TARGET_DIR="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

if [ ! -d "$TARGET_DIR" ]; then
    echo "[ERROR] Directory '$LOGS_DIR' does not exist." >&2
    exit 1
fi

TOTAL=0
EXECUTABLE_COUNT=0
NON_EXECUTABLE_COUNT=0

for FILE in "$TARGET_DIR"/*.sh; do
    # Guard against glob match (no .sh files found)
    if [ ! -f "$FILE" ]; then
        echo "[INFO] No .sh files found in '$TARGET_DIR'."
        exit 0
    fi

    TOTAL=$((TOTAL + 1))

    # Check if file has execute permissions (-x)
    if [ -x "$FILE" ]; then
        EXECUTABLE_COUNT=$((EXECUTABLE_COUNT + 1))
        echo "[PASS] $(basename "$FILE") is executable"
    else
        NON_EXECUTABLE_COUNT=$((NON_EXECUTABLE_COUNT + 1))
        echo "[FAIL] $(basename "$FILE") is NOT executable" >&2
    fi
done

echo "------------------------------------"
echo "Audit Summary: $TOTAL total, $EXECUTABLE_COUNT executable, $NON_EXECUTABLE_COUNT non-executable"

if [ "$NON_EXECUTABLE_COUNT" -gt 0 ]; then
    exit 1
fi

exit 0

