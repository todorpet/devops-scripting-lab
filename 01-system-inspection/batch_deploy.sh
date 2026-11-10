#!/usr/bin/env bash

set -u

#=================================================
# Name: The Multi-Environment Deployment Runner
# Description: Take a list of server hostnames or target environments from arguments, loop through them, run a deployment check, and track how many succeeded vs. failed.
# Usage: ./batch_deploy.sh <env1> [env2] ...
#=================================================

if [ $# -lt 1 ]; then
    echo "[ERROR] Missing arguments. Usage: $0 <env1> [env2] ..." >&2
    exit 1
fi

TOTAL_COUNT=0
SUCCESS_COUNT=0
FAILED_COUNT=0

for ENV in "$@"; do
    TOTAL_COUNT=$((TOTAL_COUNT + 1))

    # Simulated rule: 'prod' or 'production' requires special confirmation and fails if not authorized
    if [ "$ENV" = "prod" ] || [ "$ENV" = "production" ]; then
        echo "[BLOCKED] Target '$ENV' requires manual approval. Skipping." >&2
        FAILED_COUNT=$((FAILED_COUNT + 1))
    else
        echo "[DEPLOY] Successfully deployed to environment: '$ENV'"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    fi
done

echo "------------------------------------"
echo "Deployment Summary: Total: $TOTAL_COUNT | Succeeded: $SUCCESS_COUNT | Blocked: $FAILED_COUNT"

if [ "$FAILED_COUNT" -gt 0 ]; then
    exit 1
fi
exit 0

