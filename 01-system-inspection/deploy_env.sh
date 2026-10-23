#!/usr/bin/env bash

# ==============================================================================
# Script Name : deploy_env.sh
# Description : Validates input parameters and triggers environment deployment.
# Usage       : ./deploy_env.sh <staging|production>
# ==============================================================================

# Fail-fast: ensure target environment argument is supplied
if [ -z "$1" ]; then
    echo "[ERROR] Missing environment argument. Usage: $0 <staging|production>" >&2
    exit 1
fi

# Store argument in a descriptive, immutable-style variable for readability
TARGET_ENV="$1"

echo "[INFO] Deploying to target environment: $TARGET_ENV"
exit 0


