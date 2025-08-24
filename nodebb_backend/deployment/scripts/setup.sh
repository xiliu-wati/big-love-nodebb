#!/bin/bash

# Big Love NodeBB Setup Script

echo "🚀 Setting up Big Love NodeBB Backend..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18 or higher."
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version 18 or higher is required. Current version: $(node -v)"
    exit 1
fi

echo "✅ Node.js version: $(node -v)"

# Clone NodeBB from GitHub (recommended approach)
echo "📦 Cloning NodeBB from GitHub..."

# Backup config files
cp config.json config.json.backup 2>/dev/null || true
cp package.json package.json.backup 2>/dev/null || true

# Clone NodeBB
git clone -b v3.x https://github.com/NodeBB/NodeBB.git nodebb_source

# Move NodeBB files to current directory
cp -r nodebb_source/* .
cp -r nodebb_source/.* . 2>/dev/null || true
rm -rf nodebb_source

# Restore our config files
cp config.json.backup config.json 2>/dev/null || true
cp package.json.backup package.json 2>/dev/null || true

# Install NodeBB dependencies
echo "📦 Installing NodeBB dependencies..."
npm install

# Check if NodeBB was installed successfully
if [ ! -f "nodebb" ]; then
    echo "❌ NodeBB installation failed"
    exit 1
fi

echo "✅ NodeBB installed successfully"

# Make nodebb executable
chmod +x nodebb

# Setup NodeBB (interactive)
echo "🔧 Running NodeBB setup..."
echo "Please follow the interactive setup:"
echo "1. Choose Redis as your database"
echo "2. Use default Redis settings (localhost:6379)"
echo "3. Create an admin account"
echo ""

./nodebb setup

# Build NodeBB
echo "🔨 Building NodeBB..."
./nodebb build

echo "✅ NodeBB setup complete!"
echo ""
echo "🎉 Your Big Love community backend is ready!"
echo ""
echo "To start the server:"
echo "  npm start"
echo ""
echo "To start in development mode:"
echo "  npm run dev"
echo ""
echo "Access your forum at: http://localhost:4567"
