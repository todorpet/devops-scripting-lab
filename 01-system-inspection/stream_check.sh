#!/usr/bin/env bash

# 1. Normal message to standard output (stdout - FD 1)
echo "[INFO] Running stream verification check..."

# 2. Simulated error message directed explicitly to standard error (FD 2) File Descriptor
echo "[ERROR] Simulated warning or error condition occurred" >&2

# 3. Check the exit code fo the last command
echo "[DEBUG] Previous echo exit code was: $?"

$ 4. Attempt to list a non-existing file/directory
ls /non_existent_directory_for_test 2>/dev/null
CHECK_EXIT=$?

if [ $CHECK_EXIT -ne 0 ]; then
    echo "[WARN] Directory check failed with exit code: $CHECK_EXIT"
else
    echo "[SUCCESS] Directory exists."
fi

# 5. Exit the script with success
exit 0
