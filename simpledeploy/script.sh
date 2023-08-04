#!/bin/bash

# DevOps Deployment Script

# Set variables
APP_NAME="my-web-app"
DEPLOY_DIR="/var/www/$APP_NAME"
BACKUP_DIR="/var/backup/$APP_NAME"
RELEASE_DIR="/var/releases/$APP_NAME"
CURRENT_DIR="/var/www/current"
DATE=$(date +"%Y%m%d%H%M%S")

# Display a message
echo "Starting deployment of $APP_NAME"

# Backup current release
echo "Backing up current release..."
mkdir -p "$BACKUP_DIR"
tar czf "$BACKUP_DIR/$APP_NAME-$DATE.tar.gz" -C "$CURRENT_DIR" .

# Create a new release directory
echo "Creating a new release directory..."
mkdir -p "$RELEASE_DIR"
cp -r "$SOURCE_DIR/*" "$RELEASE_DIR"

# Update symbolic link
echo "Updating symbolic link..."
ln -sfn "$RELEASE_DIR" "$CURRENT_DIR"

# Restart services
echo "Restarting services..."
systemctl restart apache2
systemctl restart nginx

# Display completion message
echo "Deployment completed!"
