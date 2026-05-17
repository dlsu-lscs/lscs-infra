#!/bin/bash

# Get current server
CURRENT_SERVER=$(hostname)

if [ "$CURRENT_SERVER" == "lscsprod1.dlsu-lscs.org" ]; then
   DB_CONTAINER_NAME="lscs-core-db"
   API_CONTAINER_NAME="lscs-core-api"	
elif [ "$CURRENT_SERVER" == "lscsdev1.dlsu-lscs.org" ]; then
   DB_CONTAINER_NAME="lscs-core-database-dev"
   API_CONTAINER_NAME="lscs-core-dev-api"
else
  echo "Currently in an unknown server.";
  exit 1;
fi

# Get the container IDs
DB_ID=$(docker ps -q -f "name=$DB_CONTAINER_NAME")
API_ID=$(docker ps -q -f "name=$API_CONTAINER_NAME")

# Safety Check: Make sure the containers are actually running
if [ -z "$DB_ID" ] || [ -z "$API_ID" ]; then
    echo "Error: Could not find one or both Dokploy containers. Backup aborted."
    exit 1
fi

DB_PASSWORD=$(docker exec "$DB_ID" printenv MYSQL_ROOT_PASSWORD)
DB_NAME=$(docker exec "$DB_ID" printenv MYSQL_DATABASE)

# Create a backup folder
mkdir -p ./backup/lscs-core

# Run a database dump that outputs a file [Database]
docker exec "$DB_ID" /usr/bin/mysqldump -u root --password="$DB_PASSWORD" "$DB_NAME" > ./backup/lscs-core/sql_backup.sql
echo "Database dump successfully created."

# Copy environment variables to a .env [LSCS Core API]
# Check if there is an existing backup file
if [ ! -f "./backup/lscs-core/env_backup.env" ]; then
   docker exec "$API_ID" printenv > "./backup/lscs-core/env_backup.env"
   echo "Initial environment variables backup created."
else
   docker exec "$API_ID" printenv > "./backup/lscs-core/env_backup_temp.env"
   grep -Fxvf "./backup/lscs-core/env_backup.env" "./backup/lscs-core/env_backup_temp.env" >> "./backup/lscs-core/env_backup.env"
   rm -f "./backup/lscs-core/env_backup_temp.env"
   echo "New variables (if any) are appended to the env backup file."
fi
