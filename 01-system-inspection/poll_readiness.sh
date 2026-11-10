#!/usr/bin/env bash

set -u

#================================================================================
# Name: The Service Readiness Poller
# Description: Simulating a service booting up with a maximum number of attempts.
# Usage: ./poll_readiness.sh [max_attempts]
#================================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
READY_FILE="$SCRIPT_DIR/service.ready"

MAX_ATTEMPTS="${1:-5}"
ATTEMPT=1

while [ "$ATTEMPT" -le "$MAX_ATTEMPTS" ]; do
    if [ -f "$READY_FILE" ]; then
        echo "[SUCCESS] Service is READY! (Detected after attempt $ATTEMPT)"
        exit 0
    fi
    echo "[WAIT] Attempt $ATTEMPT/$MAX_ATTEMPTS: Service not ready yet. Retrying in 1s..."
    ATTEMPT=$((ATTEMPT + 1))
    sleep 1
done

echo "[ERROR] Timeout reached ($MAX_ATTEMPTS attempts). Service failed to start." >&2
exit 1


