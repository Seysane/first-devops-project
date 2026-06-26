#!/bin/bash

set -euo pipefail

log() {
    echo "$(date "+%Y-%m-%d %H:%M") - $1 $2 "
}
cleanup() {
    rm -f "$temp_file"
    log "INFO" "Temporary files deleted."
}
show_help() {
echo "Usage: ./tar_backup.sh -s <source> -d <destination> [-v] [-h]

    Options:
    -s    Source directory
    -d    Destination directory
    -v    Verbose mode
    -h    Show this help"
}

temp_file=$(mktemp)
trap cleanup EXIT


SOURCE=""
DEST=""
VERBOSE=false

while getopts "s:d:vh" opt; do
    case $opt in
        s) SOURCE=$OPTARG ;;
        d) DEST=$OPTARG ;;
        v) VERBOSE=true ;;
        h) show_help
        trap - EXIT
           exit 0 ;;
    esac
done

if [ -z "$SOURCE" ]; then
    echo "ERORR: Source directory not specified."
    exit 1
fi

if [ ! -d "$SOURCE" ]; then
    echo "Source directory does not exist"
    exit 1
fi

if [ -z "$DEST" ]; then
    echo "ERROR: Destination directory not specified."
    exit 1
fi

if [ ! -d "$DEST" ]; then
    echo "Destination directory does not exist"
    exit 1
fi

date_suffix=$(date +%Y%m%d_%H%M%S)
backup_file="$DEST/backup_${date_suffix}.tar.gz"

tar -czf "$backup_file" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")"

log "INFO" "Backup created: $backup_file"
if [ "$VERBOSE" = "true" ]; then
    log "INFO" "Verbose - ON"
    ls -lh "$backup_file"
fi