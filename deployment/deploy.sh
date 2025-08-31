#!/usr/bin/env bash
set -euo pipefail

# NodeBB Deployment Script for Multiple Cloud Providers
# Usage: ./deploy.sh [provider] [options]

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Big Love NodeBB Deployment Script${NC}"
echo "=========================================="

# Function to display usage
show_usage() {
    echo -e "${YELLOW}Usage: $0 [provider] [options]${NC}"
    echo ""
    echo "Providers:"
    echo "  render       Deploy to Render.com (Recommended)"
    echo "  digitalocean Deploy to DigitalOcean App Platform" 
    echo "  vultr        Deploy to Vultr (manual VPS setup)"
    echo "  local        Run locally with Docker Compose"
    echo ""
    echo "Options:"
    echo "  --build-only Build Docker image only"
    echo "  --dry-run    Show what would be deployed"
    echo "  --help       Show this help message"
    echo ""
}

# Function to check prerequisites
check_prerequisites() {
    echo -e "${BLUE}Checking prerequisites...${NC}"
    
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker not found. Please install Docker first.${NC}"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        echo -e "${RED}❌ Docker Compose not found. Please install Docker Compose first.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Prerequisites check passed${NC}"
}

# Function to build Docker image
build_docker_image() {
    echo -e "${BLUE}Building Docker image...${NC}"
    cd "$(dirname "$0")/.."
    
    if ! docker build -f deployment/Dockerfile -t big-love-nodebb:latest .; then
        echo -e "${RED}❌ Docker build failed${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Docker image built successfully${NC}"
}

# Function to deploy to Render
deploy_render() {
    echo -e "${BLUE}Deploying to Render.com...${NC}"
    
    if [[ ! -f "deployment/render.yaml" ]]; then
        echo -e "${RED}❌ render.yaml not found${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Please follow these steps:${NC}"
    echo "1. Create account at https://render.com"
    echo "2. Connect your GitHub repository"
    echo "3. Create a new service using 'deployment/render.yaml'"
    echo "4. Set environment variables as needed"
    echo ""
    echo -e "${GREEN}✅ Render configuration ready at deployment/render.yaml${NC}"
}

# Function to deploy to DigitalOcean
deploy_digitalocean() {
    echo -e "${BLUE}Deploying to DigitalOcean App Platform...${NC}"
    
    if [[ ! -f "deployment/digitalocean-app.yaml" ]]; then
        echo -e "${RED}❌ digitalocean-app.yaml not found${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Please follow these steps:${NC}"
    echo "1. Install doctl CLI: https://github.com/digitalocean/doctl"
    echo "2. Authenticate: doctl auth init"
    echo "3. Deploy: doctl apps create deployment/digitalocean-app.yaml"
    echo ""
    echo -e "${GREEN}✅ DigitalOcean configuration ready at deployment/digitalocean-app.yaml${NC}"
}

# Function to deploy locally
deploy_local() {
    echo -e "${BLUE}Deploying locally...${NC}"
    
    # Create .env file if it doesn't exist
    if [[ ! -f ".env" ]]; then
        echo -e "${YELLOW}Creating .env file...${NC}"
        cat > .env <<EOF
# NodeBB Configuration
NODE_ENV=production
PORT=4567
URL=http://localhost:4567
NODEBB_SECRET=$(openssl rand -hex 32)
LOG_LEVEL=info

# PostgreSQL Configuration
POSTGRES_DB=nodebb
POSTGRES_USER=nodebb
POSTGRES_PASSWORD=nodebb_password_$(openssl rand -hex 8)

# Redis Configuration (optional)
# REDIS_PASSWORD=redis_password_$(openssl rand -hex 8)
EOF
        echo -e "${GREEN}✅ Created .env file with secure passwords${NC}"
    fi
    
    # Start services
    echo -e "${BLUE}Starting services with Docker Compose...${NC}"
    docker-compose -f deployment/docker-compose.cloud.yml up --build -d
    
    echo ""
    echo -e "${GREEN}🎉 NodeBB is starting up!${NC}"
    echo -e "${YELLOW}Access your NodeBB at: http://localhost:4567${NC}"
    echo ""
    echo "To view logs: docker-compose -f deployment/docker-compose.cloud.yml logs -f"
    echo "To stop: docker-compose -f deployment/docker-compose.cloud.yml down"
}

# Function to deploy to Vultr (VPS setup)
deploy_vultr() {
    echo -e "${BLUE}Setting up Vultr VPS deployment...${NC}"
    
    echo -e "${YELLOW}Vultr VPS Deployment Steps:${NC}"
    echo "1. Create Vultr account and deploy Ubuntu 22.04 server"
    echo "2. Connect to your server via SSH"
    echo "3. Run the following commands:"
    echo ""
    echo "# Update system"
    echo "sudo apt update && sudo apt upgrade -y"
    echo ""
    echo "# Install Docker"
    echo "curl -fsSL https://get.docker.com -o get-docker.sh"
    echo "sudo sh get-docker.sh"
    echo "sudo usermod -aG docker \$USER"
    echo ""
    echo "# Clone your repository"
    echo "git clone https://github.com/your-username/big_love_app.git"
    echo "cd big_love_app"
    echo ""
    echo "# Deploy with Docker Compose"
    echo "./deployment/deploy.sh local"
    echo ""
    echo -e "${GREEN}✅ Vultr deployment guide ready${NC}"
}

# Main deployment logic
main() {
    if [[ $# -eq 0 ]]; then
        show_usage
        exit 1
    fi
    
    case "${1:-}" in
        "render")
            check_prerequisites
            if [[ "${2:-}" != "--dry-run" ]]; then
                build_docker_image
            fi
            deploy_render
            ;;
        "digitalocean")
            check_prerequisites
            if [[ "${2:-}" != "--dry-run" ]]; then
                build_docker_image
            fi
            deploy_digitalocean
            ;;
        "vultr")
            deploy_vultr
            ;;
        "local")
            check_prerequisites
            deploy_local
            ;;
        "--build-only")
            check_prerequisites
            build_docker_image
            ;;
        "--help")
            show_usage
            ;;
        *)
            echo -e "${RED}❌ Unknown provider: $1${NC}"
            show_usage
            exit 1
            ;;
    esac
}

# Run the main function with all arguments
main "$@"



