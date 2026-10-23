#!/usr/bin/env bash

# Anchor path to script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_FILE="$SCRIPT_DIR/app.config"

# Check if our TARGET_FILE exists. Use $ in front of it to get the actual value/name of the file
if [ -f "$TARGET_FILE" ]; then
    echo "[SUCCESS] Configuration file '$TARGET_FILE' exists."
    exit 0
else
    echo "[WARN] '$TARGET_FILE' missing. Generating default configuration..." >&2

    # Write default config using a Heredoc
    cat <<EOF > "$TARGET_FILE"
PORT=8080
ENV=development
EOF

    echo "[INFO] Default config created at '$TARGET_FILE'."
    exit 1
fi


