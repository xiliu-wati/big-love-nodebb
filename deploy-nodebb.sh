#!/bin/bash

# Big Love NodeBB Deployment Script - Organized Version

set -e

echo "🚀 Big Love NodeBB - Cloud Deployment"
echo "===================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    print_status "Installing Railway CLI..."
    npm install -g @railway/cli
    # Add to PATH for this session
    export PATH="$PATH:$(npm config get prefix)/bin"
fi

# Use npx as fallback
RAILWAY_CMD="railway"
if ! command -v railway &> /dev/null; then
    RAILWAY_CMD="npx @railway/cli"
    print_status "Using npx to run Railway CLI..."
fi

# Navigate to NodeBB directory
cd nodebb_backend/nodebb

print_status "Setting up NodeBB for Railway deployment..."

# Create railway.json for deployment
cat > railway.json << EOF
{
  "\$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "numReplicas": 1,
    "sleepApplication": false,
    "restartPolicyType": "ON_FAILURE"
  }
}
EOF

# Create production config
cat > config.json << EOF
{
  "url": "https://\${RAILWAY_PUBLIC_DOMAIN}",
  "secret": "\${SECRET_KEY}",
  "database": "redis",
  "redis": {
    "host": "\${REDIS_HOST}",
    "port": "\${REDIS_PORT}",
    "password": "\${REDIS_PASSWORD}",
    "database": 0
  },
  "port": "\${PORT}",
  "bind_address": "0.0.0.0",
  "upload_path": "/uploads",
  "sessionKey": "express.sid"
}
EOF

print_status "Initializing Railway project..."

# Check if already logged in
if ! $RAILWAY_CMD whoami &> /dev/null; then
    print_status "Please login to Railway:"
    $RAILWAY_CMD login
fi

# Initialize Railway project
if [ ! -f ".railway/project.json" ]; then
    $RAILWAY_CMD init --name "big-love-nodebb"
fi

# Add Redis service
print_status "Adding Redis service..."
$RAILWAY_CMD add --database redis || print_warning "Redis service might already exist"

# Set environment variables
print_status "Setting environment variables..."
$RAILWAY_CMD variables --set "NODE_ENV=production"
$RAILWAY_CMD variables --set "SECRET_KEY=$(openssl rand -hex 32)"

# Deploy to Railway
print_status "Deploying to Railway..."
$RAILWAY_CMD up

# Get deployment URL
sleep 5
BACKEND_URL=$($RAILWAY_CMD domain 2>/dev/null || echo "")

if [ -n "$BACKEND_URL" ]; then
    print_success "✅ NodeBB deployed successfully!"
    print_success "🌐 Backend URL: https://$BACKEND_URL"
    echo "https://$BACKEND_URL" > ../../backend_url.txt
    
    print_status "📱 Next steps:"
    print_status "1. Visit https://$BACKEND_URL to complete NodeBB setup"
    print_status "2. Create admin account"
    print_status "3. Configure your forum"
    print_status "4. Build Flutter app with: cd ../../big_love_flutter && flutter build apk"
else
    print_warning "Could not get deployment URL. Check Railway dashboard."
fi

print_success "🎉 Deployment completed!"
