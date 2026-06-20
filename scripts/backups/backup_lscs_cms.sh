#!/bin/bash

# Get current server
CURRENT_SERVER=$(hostname)

if [ "$CURRENT_SERVER" == "lscsprod1.dlsu-lscs.org" ]; then
   DB_CONTAINER_NAME="lscs-cms-db"       
   API_CONTAINER_NAME="lscs-cms-api"     
   GARAGE_CONTAINER_NAME="lscs-cms-garagewithui-a1qauq-garage-1"   
elif [ "$CURRENT_SERVER" == "lscsdev1.dlsu-lscs.org" ]; then
   DB_CONTAINER_NAME="lscs-cms-dev-db"        
   API_CONTAINER_NAME="lscs-cms-dev-api"      
   GARAGE_CONTAINER_NAME=""
else
  echo "Currently in an unknown server."
  exit 1
fi

# Get the container IDs
DB_ID=$(docker ps -q -f "name=$DB_CONTAINER_NAME")
API_ID=$(docker ps -q -f "name=$API_CONTAINER_NAME")

# check if containers running
if [ -z "$DB_ID" ] || [ -z "$API_ID" ]; then
    echo "Error: Could not find one or both core Dokploy containers. Backup aborted."
    exit 1
fi

# Garage Safety Check (Only for Prod)
if [ "$CURRENT_SERVER" == "lscsprod1.dlsu-lscs.org" ]; then
    GARAGE_ID=$(docker ps -q -f "name=$GARAGE_CONTAINER_NAME")
    if [ -z "$GARAGE_ID" ]; then
        echo "Error: Could not find the Garage container on production. Backup aborted."
        exit 1
    fi
fi

DB_USER=$(docker exec "$DB_ID" printenv POSTGRES_USER)
DB_PASSWORD=$(docker exec "$DB_ID" printenv POSTGRES_PASSWORD)
DB_NAME=$(docker exec "$DB_ID" printenv POSTGRES_DB)

# Create a backup folder
mkdir -p ./backup/lscs-cms

# Run a database dump that outputs a file [Database]
docker exec -e PGPASSWORD="$DB_PASSWORD" "$DB_ID" pg_dump -U "$DB_USER" "$DB_NAME" > ./backup/lscs-cms/sql_backup.sql
echo "Database dump successfully created."

# Copy environment variables to a .env [LSCS CMS API]
if [ ! -f "./backup/lscs-cms/env_backup.env" ]; then
   docker exec "$API_ID" printenv > "./backup/lscs-cms/env_backup.env"
   echo "Initial environment variables backup created."
else
   docker exec "$API_ID" printenv > "./backup/lscs-cms/env_backup_temp.env"
   grep -Fxvf "./backup/lscs-cms/env_backup.env" "./backup/lscs-cms/env_backup_temp.env" >> "./backup/lscs-cms/env_backup.env"
   rm -f "./backup/lscs-cms/env_backup_temp.env"
   echo "New variables (if any) are appended to the env backup file."
fi

# Back up Garage Configuration
if [ -n "$GARAGE_CONTAINER_NAME" ]; then
    docker cp "$GARAGE_ID:/etc/garage/garage.toml" "./backup/lscs-cms/garage.toml"
    echo "Garage configuration successfully backed up."
fi
