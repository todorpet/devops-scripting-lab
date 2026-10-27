#!/usr/bin/env bash

set -u

#=========================================================
# Name: The Artifact Build & Deploy Simulator
# Description: Creates a "build artifact", validates it, and prepares it for deployment
# Usage: ./artifact_manager.sh <build|verify|deploy|clean>
#=========================================================

# Define an artifact directory and an artifact archive file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"
ARTIFACT_FILE="$BUILD_DIR/artifact.tar.gz"

# Input validation
if [ $# -lt 1 ]; then
    echo "[ERROR] Action required. Usage: $0 <build|verify|deploy|clean>" >&2
    exit 1
fi

ACTION="$1"

# Action Dispatcher using case
case "$ACTION" in
    build)
        mkdir -p "$BUILD_DIR"
        touch "$ARTIFACT_FILE"
        echo "[SUCCESS] Artifact built at: $ARTIFACT_FILE"
        exit 0
        ;;
    verify)
        if [ ! -f "$ARTIFACT_FILE"  ]; then
            echo "[ERROR] Verification failed: Artifact not found at $ARTIFACT_FILE" >&2
            exit 1
        fi
        
        echo "[SUCCESS] Artifact verified and ready for deployment."
        exit 0
        ;;
    deploy)
        if [ ! -f "$ARTIFACT_FILE" ]; then
            echo "[ERROR] Cannot deploy. Artifact is missing. Run build first." >&2
            exit 1
        fi

        echo "[INFO] Deploying artifact to simulated target server..."
        exit 0
        ;;
    clean)
        if [ -d "$BUILD_DIR" ]; then
            rm -f "$ARTIFACT_FILE"
            rmdir "$BUILD_DIR"
            echo "[SUCCESS] Build artifacts cleaned up."
            exit 0
        else
            echo "[INFO] No build directory to clean."
            exit 0
        fi
        ;;
    *)
        echo "[ERROR] Invalid action: '$ACTION'. Allowed: build, verify, deploy, clean" >&2
        exit 2
        ;;
esac
