#!/bin/bash

# Dropbox CLI path
DROPBOX_CLI=/path/to/dropbox-cli

# MySQL database credentials
DB_USER="your_mysql_username"
DB_PASSWORD="your_mysql_password"
DB_NAME="your_database_name"

# Backup directory
BACKUP_DIR="/path/to/backup/folder"
SERVER_FILES_DIR="/path/to/your/server/files"

# Date and timestamp for the backup
DATE=$(date +%Y%m%d_%H%M%S)

# Function to backup the MySQL database
backup_mysql_database() {
  echo "Backing up MySQL database..."
  mysqldump -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$BACKUP_DIR/mysql_backup_$DATE.sql"
  echo "MySQL backup complete."
}

# Function to backup server files
backup_server_files() {
  echo "Backing up server files..."
  tar czf "$BACKUP_DIR/server_files_backup_$DATE.tar.gz" -C "$SERVER_FILES_DIR" .
  echo "Server files backup complete."
}

# Function to upload backup files to Dropbox
upload_to_dropbox() {
  echo "Uploading backup files to Dropbox..."
  "$DROPBOX_CLI" upload "$BACKUP_DIR/mysql_backup_$DATE.sql" "/ServerBackups/"
  "$DROPBOX_CLI" upload "$BACKUP_DIR/server_files_backup_$DATE.tar.gz" "/ServerBackups/"
  echo "Upload complete."
}

# Function to clear older backup files
clear_old_backups() {
  echo "Clearing older backup files..."
  ls -t "$BACKUP_DIR/mysql_backup_"*.sql | tail -n +4 | xargs rm --
  ls -t "$BACKUP_DIR/server_files_backup_"*.tar.gz | tail -n +4 | xargs rm --
  echo "Older backup files cleared."
}

# Main script starts here

# Create the backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Perform the backups
backup_mysql_database
backup_server_files

# Upload backup files to Dropbox
upload_to_dropbox

# Clear older backup files (keep only the last 3 copies)
clear_old_backups

echo "Backup process completed successfully."
