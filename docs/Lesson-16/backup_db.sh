#!/bin/bash


DB_NAME="blog_db"
BACKUP_DIR="/home/sane/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_$TIMESTAMP.sql"

if [ ! -d "$BACKUP_DIR" ]; then
	mkdir -p "$BACKUP_DIR"
fi

echo "Creating Database Backup file"
pg_dump -U postgres -h localhost $DB_NAME > $BACKUP_FILE
echo "Database Backup file created: $BACKUP_FILE"

