#!/bin/bash

DATE=$(date +"%Y-%m-%d")
# Absolute path ensuring it saves to the correct project directory
ARCHIVE_FILE="/home/lscs/backup/lscs-links/lscs_links_backup_$DATE.archive"
DB_URL="mongodb://root:NOTb6ChU4L0IWrHU0NK4QgwjD8vUw6X9MRxF8d8AmAJfT7woU2gfp0smiu0o0I3n@167.253.157.145:27071/?directConnection=true"

echo "Starting MongoDB backup via stream..."

# We use --archive to stream the backup directly out of Docker into a file on the host
docker run --rm mongo:latest mongodump --uri="$DB_URL" --archive > "$ARCHIVE_FILE"

# Check if the file was created and is not empty
if [ -s "$ARCHIVE_FILE" ]; then
    echo "Backup successfully saved as: $ARCHIVE_FILE"
else
    echo "Error: Backup failed or file is empty."
    rm -f "$ARCHIVE_FILE"
fi