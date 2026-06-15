#!/bin/bash

CONF_FILE="$(dirname "$0")/vm_guardian.conf"

if [ ! -f "$CONF_FILE" ]; then
    echo "[ERROR] Configuration file $CONF_FILE not found!" >&2
    exit 1
fi

source "$CONF_FILE"

# ==============
# RESTORE MODE
# ==============

if [ "$1" == "--restore" ]; then
    echo "=================================="
    echo "    [!] RESTORE MODE ACTIVE [!]   "
    echo "=================================="
    echo "Target directory on VMs: $VM_LOG_SRC"
    echo "----------------------------------"

    DEBIAN_RESTORE_SRC="${BACKUP_SRC}/debian/backup/"
    ROCKY_RESTORE_SRC="${BACKUP_SRC}/rocky/backup/"

    CHOICE=$(echo "$2" | tr '[:upper:]' '[:lower:]')

    if [ "$CHOICE" == "debian" ] || [ "$CHOICE" == "all" ] || [ -z "$CHOICE" ]; then
        echo "[+] Restoring logs to Debian (${DEBIAN_IP})..."
        rsync -avz "$DEBIAN_RESTORE_SRC" "${DEBIAN_USER}@${DEBIAN_IP}:${VM_LOG_SRC}"
    fi

    if [ "$CHOICE" == "rocky" ] || [ "$CHOICE" == "all" ] || [ -z "$CHOICE" ]; then
        echo "[+] Restoring logs to Rocky Linux (${ROCKY_IP})..."
        rsync -avz "$ROCKY_RESTORE_SRC" "${ROCKY_USER}@${ROCKY_IP}:${VM_LOG_SRC}"
    fi

    if [ "$CHOICE" != "debian" ] && [ "$CHOICE" != "rocky" ] && [ "$CHOICE" != "all" ] && [ ! -z "$CHOICE" ]; then
        echo "[ERROR] Unknown restore target: '$2'"
        echo "Valid options: debian, rocky, all"
        exit 1
    fi

    echo "----------------------------------"
    echo "Restore operation finished."
    exit 0 
fi

echo "===== VM_Guardian Diagnostic ====="
echo "Config file: $CONF_FILE"
echo "Base Source: $BACKUP_SRC"
echo "Log File:    $LOG_FILE"
echo "Retention:   $MAX_BACKUPS backups"
echo "=================================="
echo "Starting log synchronization: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"


# ==========
# 1. DEBIAN
# ==========

DEBIAN_BACKUP_DIR="${BACKUP_SRC}/debian/backup"
DEBIAN_ARCHIVE_DIR="${BACKUP_SRC}/debian/archives"

mkdir -p "$DEBIAN_BACKUP_DIR" "$DEBIAN_ARCHIVE_DIR"
echo "[+] Fetching logs from Debian to current backup folder..."

rsync -avz "${DEBIAN_USER}@${DEBIAN_IP}:${VM_LOG_SRC}" "$DEBIAN_BACKUP_DIR" >> "$LOG_FILE" 2>&1

while [ $(ls -1 "$DEBIAN_BACKUP_DIR" | wc -l) -gt "$MAX_BACKUPS" ]; do
    OLDEST_FILE=$(ls -tr "$DEBIAN_BACKUP_DIR" | head -n 1)
    echo "Retention trigger: Moving $OLDEST_FILE to archives." >> "$LOG_FILE"
    echo "[!] Debian: Moving $OLDEST_FILE to archives due to retention policy."
    mv "${DEBIAN_BACKUP_DIR}/${OLDEST_FILE}" "$DEBIAN_ARCHIVE_DIR/"
done

while [ $(ls -1 "$DEBIAN_ARCHIVE_DIR" | wc -l) -gt "$MAX_BACKUPS" ]; do
    OLDEST_ARCHIVE=$(ls -tr "$DEBIAN_ARCHIVE_DIR" | head -n 1)
    echo "Purge trigger: Deleting $OLDEST_ARCHIVE from archives permanently." >> "$LOG_FILE"
    echo "[X] Debian: Purging $OLDEST_ARCHIVE from archives permanently."
    rm "${DEBIAN_ARCHIVE_DIR}/${OLDEST_ARCHIVE}"
done


# =========
# 2. Rocky
# =========

ROCKY_BACKUP_DIR="${BACKUP_SRC}/rocky/backup"
ROCKY_ARCHIVE_DIR="${BACKUP_SRC}/rocky/archives"


mkdir -p "$ROCKY_BACKUP_DIR" "$ROCKY_ARCHIVE_DIR"
echo "[+] Fetching logs from Rocky Linux to current backup folder..."

rsync -avz "${ROCKY_USER}@${ROCKY_IP}:${VM_LOG_SRC}" "$ROCKY_BACKUP_DIR" >> "$LOG_FILE" 2>&1

while [ $(ls -1 "$ROCKY_BACKUP_DIR" | wc -l) -gt "$MAX_BACKUPS" ]; do
    OLDEST_FILE=$(ls -tr "$ROCKY_BACKUP_DIR" | head -n 1)
    echo "Retention trigger: Moving $OLDEST_FILE to archives." >> "$LOG_FILE"
    echo "[!] Rocky: Moving $OLDEST_FILE to archives due to retention policy."
    mv "${ROCKY_BACKUP_DIR}/${OLDEST_FILE}" "$ROCKY_ARCHIVE_DIR/"
done

while [ $(ls -1 "$ROCKY_ARCHIVE_DIR" | wc -l) -gt "$MAX_BACKUPS" ]; do
    OLDEST_ARCHIVE=$(ls -tr "$ROCKY_ARCHIVE_DIR" | head -n 1)
    echo "Purge trigger: Deleting $OLDEST_ARCHIVE from archives permanently." >> "$LOG_FILE"
    echo "[X] Rocky: Purging $OLDEST_ARCHIVE from archives permanently."
    rm "${ROCKY_ARCHIVE_DIR}/${OLDEST_ARCHIVE}"
done

echo "Log synchronization finished: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"

echo "Done! Current logs landed in backup/. Archives/ folders are ready for retention logic."
