#!/usr/bin/env bash

TARGET_FILE="app.config"

if [ -f "$TARGET_FILE" ]; then
    echo "[SUCCESS] Configuration file '$TARGET_FILE' exists."
    exit 0
else
    echo "[WARN] '$TARGET_FILE' missing. Creating a default one..." >&2
    touch "$TARGET_FILE"
    exit 1
fi

