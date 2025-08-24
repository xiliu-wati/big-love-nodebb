# Big Love NodeBB Backend - Organized Structure

A clean, organized NodeBB setup for the Big Love community app.

## 📁 Directory Structure

```
nodebb_organized/
├── 📂 config/              # Configuration files
│   ├── config.json         # NodeBB configuration
│   └── environment/        # Environment-specific configs
├── 📂 deployment/          # Deployment files
│   ├── docker/            # Docker configurations
│   ├── railway/           # Railway deployment
│   └── scripts/           # Deployment scripts
├── 📂 nodebb/             # NodeBB source code
│   ├── src/               # NodeBB core source
│   ├── public/            # Static assets
│   ├── app.js             # Main application
│   └── package.json       # Dependencies
├── 📂 customizations/     # Our customizations
│   ├── plugins/           # Custom plugins
│   ├── themes/            # Custom themes
│   └── api/               # API extensions
└── 📂 docs/               # Documentation
    ├── setup.md           # Setup instructions
    ├── api.md             # API documentation
    └── deployment.md      # Deployment guide
```

## 🚀 Quick Start

```bash
# Setup NodeBB
cd nodebb/
npm install
./nodebb setup

# Start development
npm run dev

# Deploy to cloud
cd ../deployment/
./deploy.sh
```

## 📖 Documentation

- [Setup Guide](docs/setup.md)
- [API Documentation](docs/api.md)
- [Deployment Guide](docs/deployment.md)
