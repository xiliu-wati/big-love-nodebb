#!/bin/bash

# Extended Cloud Deployment Script for Big Love App
# Supports: Railway, DigitalOcean, AWS, Google Cloud, Heroku

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Cloud deployment functions
deploy_railway() {
    print_status "🚀 Deploying to Railway..."
    
    if ! command -v railway &> /dev/null; then
        print_status "Installing Railway CLI..."
        npm install -g @railway/cli
    fi
    
    cd nodebb_backend
    
    if ! railway whoami &> /dev/null; then
        print_status "Please login to Railway:"
        railway login
    fi
    
    if [ ! -f ".railway/project.json" ]; then
        railway init --name "big-love-nodebb"
    fi
    
    railway add redis || print_warning "Redis might already exist"
    railway up
    
    BACKEND_URL=$(railway domain 2>/dev/null || echo "")
    if [ -n "$BACKEND_URL" ]; then
        print_success "✅ Deployed to Railway: https://$BACKEND_URL"
        echo "https://$BACKEND_URL" > ../backend_url.txt
    fi
    
    cd ..
}

deploy_heroku() {
    print_status "🟣 Deploying to Heroku..."
    
    if ! command -v heroku &> /dev/null; then
        print_error "Heroku CLI not installed. Install from: https://devcenter.heroku.com/articles/heroku-cli"
        return 1
    fi
    
    cd nodebb_backend
    
    # Login check
    if ! heroku whoami &> /dev/null; then
        heroku login
    fi
    
    # Create app
    APP_NAME="big-love-$(date +%s)"
    heroku create $APP_NAME
    
    # Add Redis addon
    heroku addons:create heroku-redis:mini -a $APP_NAME
    
    # Set environment variables
    heroku config:set NODE_ENV=production -a $APP_NAME
    
    # Create Procfile
    echo "web: npm start" > Procfile
    
    # Deploy
    git init 2>/dev/null || true
    git add .
    git commit -m "Deploy to Heroku" 2>/dev/null || git commit --amend -m "Deploy to Heroku"
    heroku git:remote -a $APP_NAME
    git push heroku main || git push heroku master
    
    BACKEND_URL="https://$APP_NAME.herokuapp.com"
    print_success "✅ Deployed to Heroku: $BACKEND_URL"
    echo "$BACKEND_URL" > ../backend_url.txt
    
    cd ..
}

deploy_digitalocean() {
    print_status "🌊 Deploying to DigitalOcean App Platform..."
    
    if ! command -v doctl &> /dev/null; then
        print_error "DigitalOcean CLI not installed. Install from: https://docs.digitalocean.com/reference/doctl/"
        return 1
    fi
    
    cd nodebb_backend
    
    # Create app spec
    cat > .do/app.yaml << EOF
name: big-love-nodebb
services:
- name: web
  source_dir: /
  github:
    repo: your-username/big-love-app
    branch: main
  run_command: npm start
  environment_slug: node-js
  instance_count: 1
  instance_size_slug: basic-xxs
  env:
  - key: NODE_ENV
    value: production
databases:
- name: redis
  engine: REDIS
  version: "7"
  size: db-s-1vcpu-1gb
EOF
    
    print_status "App spec created. Please:"
    print_status "1. Push code to GitHub"
    print_status "2. Go to DigitalOcean App Platform dashboard"
    print_status "3. Create new app from GitHub repo"
    print_status "4. Use the generated .do/app.yaml spec"
    
    cd ..
}

deploy_aws() {
    print_status "☁️ Deploying to AWS (Elastic Beanstalk)..."
    
    if ! command -v eb &> /dev/null; then
        print_error "AWS EB CLI not installed. Install from: https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html"
        return 1
    fi
    
    cd nodebb_backend
    
    # Initialize EB
    eb init big-love-nodebb --platform node.js --region us-east-1
    
    # Create environment
    eb create big-love-prod --database.engine redis
    
    # Deploy
    eb deploy
    
    BACKEND_URL=$(eb status | grep "CNAME" | awk '{print $2}')
    if [ -n "$BACKEND_URL" ]; then
        print_success "✅ Deployed to AWS: https://$BACKEND_URL"
        echo "https://$BACKEND_URL" > ../backend_url.txt
    fi
    
    cd ..
}

deploy_gcp() {
    print_status "🔵 Deploying to Google Cloud (App Engine)..."
    
    if ! command -v gcloud &> /dev/null; then
        print_error "Google Cloud CLI not installed. Install from: https://cloud.google.com/sdk/docs/install"
        return 1
    fi
    
    cd nodebb_backend
    
    # Create app.yaml
    cat > app.yaml << EOF
runtime: nodejs18

env_variables:
  NODE_ENV: production
  REDIS_HOST: \${REDIS_HOST}
  REDIS_PORT: 6379

automatic_scaling:
  min_instances: 1
  max_instances: 10
EOF
    
    # Deploy
    gcloud app deploy
    
    BACKEND_URL=$(gcloud app describe --format="value(defaultHostname)")
    if [ -n "$BACKEND_URL" ]; then
        print_success "✅ Deployed to GCP: https://$BACKEND_URL"
        echo "https://$BACKEND_URL" > ../backend_url.txt
    fi
    
    cd ..
}

deploy_tencent() {
    print_status "🐧 Deploying to Tencent Cloud..."
    
    print_status "For Tencent Cloud deployment:"
    print_status "1. Use Serverless Framework with tencent-scf"
    print_status "2. Or deploy via Docker to CVM instances"
    print_status "3. Manual setup required - see Tencent Cloud documentation"
    
    # Create docker deployment for Tencent CVM
    cd nodebb_backend
    
    print_status "Creating Docker setup for Tencent CVM..."
    cat > tencent-deploy.md << EOF
# Tencent Cloud Deployment Guide

## Option 1: CVM (Cloud Virtual Machine)
1. Create CVM instance (Ubuntu 20.04)
2. Install Docker: curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
3. Clone repo: git clone <your-repo>
4. Run: docker-compose up -d

## Option 2: Serverless (SCF)
1. Install Serverless: npm install -g serverless
2. Configure: serverless config credentials --provider tencent
3. Deploy: serverless deploy

## Option 3: Container Service (TKE)
1. Build image: docker build -t big-love-nodebb .
2. Push to TCR registry
3. Deploy to TKE cluster
EOF
    
    cd ..
}

deploy_alibaba() {
    print_status "🟠 Deploying to Alibaba Cloud..."
    
    print_status "For Alibaba Cloud deployment:"
    print_status "1. Use Function Compute for serverless"
    print_status "2. Or ECS instances with Docker"
    print_status "3. Manual setup required - see Alibaba Cloud documentation"
    
    cd nodebb_backend
    
    cat > alibaba-deploy.md << EOF
# Alibaba Cloud Deployment Guide

## Option 1: ECS (Elastic Compute Service)
1. Create ECS instance
2. Install Docker and Docker Compose
3. Clone repository
4. Run: docker-compose up -d

## Option 2: Function Compute
1. Install Fun CLI: npm install @alicloud/fun -g
2. Configure: fun config
3. Deploy serverless functions

## Option 3: Container Service (ACK)
1. Build and push to ACR registry
2. Deploy to ACK cluster
EOF
    
    cd ..
}

# Main menu
show_menu() {
    echo ""
    echo "🌐 Big Love App - Cloud Deployment Options"
    echo "=========================================="
    echo ""
    echo "🏆 RECOMMENDED (Easy & Affordable):"
    echo "1) Railway          - Free tier, easiest setup"
    echo "2) Heroku           - $7/month, simple deployment"
    echo "3) DigitalOcean     - $12/month, good performance"
    echo ""
    echo "🏢 ENTERPRISE (More Complex):"
    echo "4) AWS              - $15-50+/month, full control"
    echo "5) Google Cloud     - $20-40+/month, good docs"
    echo ""
    echo "🌏 ASIA/CHINA FOCUSED:"
    echo "6) Tencent Cloud    - Manual setup guide"
    echo "7) Alibaba Cloud    - Manual setup guide"
    echo ""
    echo "🐳 UNIVERSAL:"
    echo "8) Docker (Any Cloud) - Use on any provider"
    echo ""
    read -p "Choose deployment option (1-8): " choice
}

# Main execution
main() {
    print_status "🚀 Big Love App - Extended Cloud Deployment"
    
    show_menu
    
    case $choice in
        1)
            deploy_railway
            ;;
        2)
            deploy_heroku
            ;;
        3)
            deploy_digitalocean
            ;;
        4)
            deploy_aws
            ;;
        5)
            deploy_gcp
            ;;
        6)
            deploy_tencent
            ;;
        7)
            deploy_alibaba
            ;;
        8)
            print_status "🐳 Docker deployment files already created!"
            print_status "Use docker-compose.yml with any cloud provider"
            print_status "Or use Dockerfile for container services"
            ;;
        *)
            print_error "Invalid choice. Please run again."
            exit 1
            ;;
    esac
    
    # Build Flutter app if backend was deployed
    if [ -f "backend_url.txt" ]; then
        print_status "📱 Building Flutter app with cloud backend..."
        cd big_love_flutter
        
        # Update API URL
        BACKEND_URL=$(cat ../backend_url.txt)
        sed -i.bak "s|https://biglove-nodebb.railway.app|$BACKEND_URL|g" lib/config/api_config.dart
        rm -f lib/config/api_config.dart.bak
        
        # Build APK
        if command -v flutter &> /dev/null; then
            flutter pub get
            flutter build apk --release
            cp build/app/outputs/flutter-apk/app-release.apk ../big_love_app.apk
            print_success "📱 Android APK ready: big_love_app.apk"
        else
            print_warning "Flutter not installed. Install Flutter to build mobile app."
        fi
        
        cd ..
    fi
    
    print_success "🎉 Deployment completed!"
    
    if [ -f "backend_url.txt" ]; then
        echo ""
        echo "🌐 Backend URL: $(cat backend_url.txt)"
        echo "📱 Android APK: big_love_app.apk"
        echo ""
        echo "Next steps:"
        echo "1. Install big_love_app.apk on your Android device"
        echo "2. Create an account and test the app"
        echo "3. Share with friends!"
    fi
}

main
