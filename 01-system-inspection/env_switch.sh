#!/usr/bin/env bash

# ===================================
# Script Name: env_switch.sh
# Description: Whitelisting with case Statements
# Usage      : ./env_switch.sh
# ===================================

# Check if environmental variable is present
if [ -z "$1" ]; then
    echo "[ERROR] Evironmental variable is missing." >&2
    exit 1
fi

# Store environmental var
TARGET_ENV="$1"

# Whitelisting with case
case "$TARGET_ENV" in
    development)
        echo "[INFO] Initializing development settings (Debug enabled)..."
        exit 0
        ;;
    staging)
        echo "[INFO] Connecting to staging cluster and running tests..."
        exit 0
        ;;
    production)
        echo "[WARN] Targeting PRODUCTION. Applying strict security policies..."
        exit 0
        ;;
    *)
        echo "[ERROR] Unknown environment: '$TARGET_ENV'. Allowed: development, staging, production" >&2
        exit 2
        ;;
esac
