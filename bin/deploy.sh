#!/bin/bash
set -e

# --- CONFIGURATION ---
APP_NAME="evas_art_website"
SERVER_IP="your_server_ip_here"
SERVER_USER="root" # or your sudo user

echo "🚀 Starting deployment for $APP_NAME..."

# 1. Build the image locally (This compiles Tailwind CSS for production)
echo "📦 Building Docker image..."
docker compose build

# 2. Save and Move the image to the server 
# (If you don't have a Docker Registry, this is the easiest way)
echo "📤 Transferring image to Alpine server..."
docker save $APP_NAME | ssh $SERVER_USER@$SERVER_IP "docker load"

# 3. Copy the compose.yml and .env files to the server
echo "📄 Syncing configuration files..."
scp compose.yml .env $SERVER_USER@$SERVER_IP:~/app/

# 4. Restart the app on the Alpine server
echo "🔄 Restarting containers on server..."
ssh $SERVER_USER@$SERVER_IP "cd ~/app && docker compose up -d"

echo "✅ Deployment complete! Your site is live."
