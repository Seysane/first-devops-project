#!/bin/bash

# ==============================================================================
# VM_Guardian - Virtual Machine Log Backup & Retention System
# ==============================================================================

CONF_FILE="$(dirname "$0")/vm_guardian.conf"

if [ ! -f "$CONF_FILE" ]; then
    echo "[ERROR] Configuration file $CONF_FILE not found!" >&2
    exit 1
fi

source "$CONF_FILE"

echo "=== VM_Guardian Diagnostic ==="
echo "Config file: $CONF_FILE"
echo "Source:      $BACKUP_SRC"
echo "Destination: $BACKUP_DEST"
echo "Log File:    $LOG_FILE"
echo "Retention:   $MAX_BACKUPS backups"
echo "=============================="


