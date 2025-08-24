#!/bin/bash

# Big Love NodeBB Deployment Script (Organized Version)

set -e

echo "🚀 Big Love NodeBB - Organized Deployment"
echo "========================================"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

# Check if we're in the right directory structure
if [ ! -f "../../config/config.json" ]; then
    echo "❌ Please run this script from the deployment/scripts/ directory"
    echo "Current directory: $(pwd)"
    exit 1
fi

print_status "Setting up environment..."

# Copy appropriate config based on environment
ENV=${1:-production}
if [ -f "../../config/environment/${ENV}.json" ]; then
    cp "../../config/environment/${ENV}.json" "../../nodebb/config.json"
    print_success "Using ${ENV} configuration"
else
    cp "../../config/config.json" "../../nodebb/config.json"
    print_success "Using default configuration"
fi

# Navigate to NodeBB directory
cd ../../nodebb

print_status "Installing NodeBB dependencies..."
npm install

print_status "Setting up NodeBB..."
if [ ! -f "config.json" ]; then
    ./nodebb setup
fi

print_status "Building NodeBB..."
./nodebb build

print_success "✅ NodeBB setup complete!"
print_status "To start NodeBB: cd nodebb && npm start"
