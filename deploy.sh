#!/bin/bash

# PayFusion Backend Deployment Script for Digital Ocean Ubuntu Server
# This script handles the deployment process from code transfer to application startup

set -e  # Exit immediately if any command fails

echo "========================================="
echo "  PayFusion Backend Deployment Process"
echo "========================================="

# Configuration variables - change these as needed
APP_NAME="payfusion-api"
APP_DIR="/var/www/payfusion"
REPO_URL="your-git-repo-url-here"  # If using Git
NODE_ENV="production"
PORT=3000

# Create required directories
echo "Creating application directories..."
sudo mkdir -p $APP_DIR
sudo chown -R $USER:$USER $APP_DIR

# Clone or pull the latest code
if [ -d "$APP_DIR/.git" ]; then
    echo "Repository exists, pulling latest changes..."
    cd $APP_DIR
    git pull
else
    echo "Cloning repository for the first time..."
    git clone $REPO_URL $APP_DIR
    cd $APP_DIR
fi

# Alternative: if you're uploading files directly instead of using Git
# Just upload your files to $APP_DIR using SCP or SFTP

# Install dependencies
echo "Installing dependencies..."
npm ci

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "Creating .env file..."
    cp .env.example .env
    # Add your environment variables here
    echo "PORT=$PORT" >> .env
    echo "NODE_ENV=$NODE_ENV" >> .env
    echo "MONGODB_URI=mongodb://localhost:27017/payfusion" >> .env
    # Add other necessary environment variables
fi

# Build the application with webpack
echo "Building application..."
npm run build

# Install PM2 if not already installed
if ! command -v pm2 &> /dev/null; then
    echo "Installing PM2 globally..."
    sudo npm install -g pm2
fi

# Start/restart the application with PM2
if pm2 list | grep -q "$APP_NAME"; then
    echo "Restarting application with PM2..."
    pm2 restart $APP_NAME
else
    echo "Starting application with PM2..."
    pm2 start dist/server.bundle.js --name $APP_NAME
fi

# Save PM2 process list to auto-restart on server reboot
pm2 save

# Make PM2 start on system boot if not already set up
pm2 startup | tail -n 1

# Setup Nginx as a reverse proxy (if needed)
if ! command -v nginx &> /dev/null; then
    echo "Installing Nginx..."
    sudo apt update
    sudo apt install -y nginx
    
    # Create Nginx configuration
    sudo tee /etc/nginx/sites-available/$APP_NAME > /dev/null <<EOT
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;

    location / {
        proxy_pass http://localhost:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOT
    
    # Enable the site
    sudo ln -sf /etc/nginx/sites-available/$APP_NAME /etc/nginx/sites-enabled/
    
    # Test Nginx configuration
    sudo nginx -t
    
    # Restart Nginx
    sudo systemctl restart nginx
fi

echo "========================================="
echo "  Deployment completed successfully!"
echo "========================================="
echo "Your application should now be running at: http://your-server-ip:$PORT"
echo "If you configured Nginx, access it at: http://your-domain.com"