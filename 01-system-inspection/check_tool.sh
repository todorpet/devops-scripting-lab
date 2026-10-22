#!/usr/bin/env bash

which git >/dev/null 2>&1
TOOL_STATUS=$?

if [ $TOOL_STATUS -eq 0 ]; then
    echo "[SUCCESS] Git is installed."
    exit 0
else
    echo "[ERROR] Git is not installed" >&2
    exit 1
fi

