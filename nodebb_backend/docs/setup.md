# NodeBB Setup Guide

## Quick Start

```bash
# From the root directory
cd deployment/scripts/
./deploy.sh development

# Or for production
./deploy.sh production
```

## Manual Setup

### 1. Install Dependencies
```bash
cd nodebb/
npm install
```

### 2. Configure NodeBB
```bash
# Copy appropriate config
cp ../config/environment/development.json config.json

# Run interactive setup
./nodebb setup
```

### 3. Build and Start
```bash
./nodebb build
./nodebb start
```

## Configuration

### Development
- URL: http://localhost:4567
- Database: Local Redis
- Config: `config/environment/development.json`

### Production  
- URL: https://your-domain.com
- Database: Cloud Redis
- Config: `config/environment/production.json`

## Troubleshooting

### Common Issues

1. **Redis Connection Failed**
   - Check Redis is running: `redis-cli ping`
   - Verify connection settings in config.json

2. **Build Errors**
   - Clear node_modules: `rm -rf node_modules && npm install`
   - Rebuild: `./nodebb build`

3. **Permission Errors**
   - Make nodebb executable: `chmod +x nodebb`
   - Check file permissions: `ls -la`
