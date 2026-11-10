#!/usr/bin/env bash

set -u

#=========================================================
# Name: The Migration Rollback Countdown
# Description: Print a warning and start a countdown loop.
# Usage: ./migration_countdown.sh [seconds]
#=========================================================

SECONDS_LEFT="${1:-5}"

if [ "$SECONDS_LEFT" -le 0 ]; then
    echo "[ERROR] Countdown seconds must be greater than 0." >&2
    exit 1
fi

echo "[ALERT] Initializing database rollback in $SECONDS_LEFT seconds..."
echo "[INFO] Press Ctrl+C immediately to abort the operation!"
echo "--------------------------------------------------------"

while [ "$SECONDS_LEFT" -gt 0 ]; do
    echo "[COUNTDOWN] T-minus $SECONDS_LEFT second(s)..."
    sleep 1
    SECONDS_LEFT=$((SECONDS_LEFT - 1))
done

echo "--------------------------------------------------------"
echo "[EXECUTE] Time elapsed! Executing database rollback now..."
echo "[SUCCESS] Rollback completed successfully."
exit 0

