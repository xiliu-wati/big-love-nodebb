#!/bin/bash

# Big Love App Deployment Script

set -e

echo "🚀 Big Love App Deployment Script"
echo "================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js 18+"
        exit 1
    fi
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker"
        exit 1
    fi
    
    # Check Railway CLI (optional)
    if ! command -v railway &> /dev/null; then
        print_warning "Railway CLI not found. Install it for easy deployment: npm install -g @railway/cli"
    fi
    
    print_success "Prerequisites check completed"
}

# Deploy NodeBB Backend
deploy_backend() {
    print_status "Deploying NodeBB Backend..."
    
    cd nodebb_backend/nodebb
    
    # Install dependencies
    print_status "Installing NodeBB dependencies..."
    npm install
    
    # Check if Railway CLI is available
    if command -v railway &> /dev/null; then
        print_status "Deploying to Railway..."
        
        # Login check
        if ! railway whoami &> /dev/null; then
            print_status "Please login to Railway:"
            railway login
        fi
        
        # Create project if it doesn't exist
        if [ ! -f ".railway/project.json" ]; then
            print_status "Creating new Railway project..."
            railway init --name "big-love-nodebb"
        fi
        
        # Add Redis service
        print_status "Adding Redis service..."
        railway add redis || print_warning "Redis service might already exist"
        
        # Deploy
        print_status "Deploying to Railway..."
        railway up
        
        # Get the deployment URL
        BACKEND_URL=$(railway domain)
        if [ -n "$BACKEND_URL" ]; then
            print_success "Backend deployed to: https://$BACKEND_URL"
            echo "https://$BACKEND_URL" > ../backend_url.txt
        else
            print_warning "Could not get deployment URL. Check Railway dashboard."
        fi
        
    else
        print_status "Starting local Docker deployment..."
        docker-compose up -d
        
        print_success "Backend running locally at: http://localhost:4567"
        echo "http://localhost:4567" > ../backend_url.txt
    fi
    
    cd ..
    print_success "Backend deployment completed"
}

# Build Flutter App
build_flutter_app() {
    print_status "Building Flutter App..."
    
    cd big_love_flutter
    
    # Check if Flutter is installed
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed. Please install Flutter SDK"
        print_status "Visit: https://docs.flutter.dev/get-started/install"
        exit 1
    fi
    
    # Update API URL if backend URL is available
    if [ -f "../backend_url.txt" ]; then
        BACKEND_URL=$(cat ../backend_url.txt)
        print_status "Updating API URL to: $BACKEND_URL"
        
        # Update the API config file
        sed -i.bak "s|https://biglove-nodebb.railway.app|$BACKEND_URL|g" lib/config/api_config.dart
        rm -f lib/config/api_config.dart.bak
    fi
    
    # Get dependencies
    print_status "Getting Flutter dependencies..."
    flutter pub get
    
    # Build APK for Android
    print_status "Building Android APK..."
    flutter build apk --release
    
    if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
        print_success "Android APK built successfully!"
        print_status "APK location: big_love_flutter/build/app/outputs/flutter-apk/app-release.apk"
        
        # Copy APK to root directory for easy access
        cp build/app/outputs/flutter-apk/app-release.apk ../big_love_app.apk
        print_success "APK copied to: big_love_app.apk"
    else
        print_error "Failed to build Android APK"
        exit 1
    fi
    
    cd ..
}

# Main deployment function
main() {
    echo ""
    print_status "Starting Big Love App deployment..."
    echo ""
    
    # Ask user what to deploy
    echo "What would you like to deploy?"
    echo "1) Backend only"
    echo "2) Flutter app only"
    echo "3) Both (recommended)"
    echo ""
    read -p "Enter your choice (1-3): " choice
    
    case $choice in
        1)
            check_prerequisites
            deploy_backend
            ;;
        2)
            build_flutter_app
            ;;
        3)
            check_prerequisites
            deploy_backend
            build_flutter_app
            ;;
        *)
            print_error "Invalid choice. Please run the script again."
            exit 1
            ;;
    esac
    
    echo ""
    print_success "🎉 Deployment completed successfully!"
    echo ""
    
    if [ -f "backend_url.txt" ]; then
        BACKEND_URL=$(cat backend_url.txt)
        echo "📱 Backend URL: $BACKEND_URL"
    fi
    
    if [ -f "big_love_app.apk" ]; then
        echo "📱 Android APK: big_love_app.apk"
        echo ""
        echo "To install on your Android device:"
        echo "1. Transfer big_love_app.apk to your Android device"
        echo "2. Enable 'Install from unknown sources' in Settings"
        echo "3. Open the APK file and install"
    fi
    
    echo ""
    echo "🚀 Your Big Love community app is ready!"
}

# Run main function
main
