# NodeBB Deployment Guide

This directory contains production-ready deployment configurations for your Big Love NodeBB community platform.

## 🚀 Quick Start

### Option 1: Render.com (Recommended - Easiest)
```bash
# 1. Build and test locally first
./deployment/deploy.sh local

# 2. Deploy to Render
./deployment/deploy.sh render
```

### Option 2: DigitalOcean App Platform
```bash
# 1. Install doctl CLI
# 2. Deploy
./deployment/deploy.sh digitalocean
```

### Option 3: Local Development
```bash
./deployment/deploy.sh local
```

## 📁 File Structure

```
deployment/
├── Dockerfile               # Production-optimized Docker image
├── entrypoint.sh           # Smart startup script with database detection
├── deploy.sh               # Universal deployment script
├── docker-compose.cloud.yml # Local/cloud Docker Compose
├── render.yaml             # Render.com configuration
├── digitalocean-app.yaml   # DigitalOcean App Platform config
└── README.md               # This file
```

## 🛠 Pre-Deployment Checklist

- [ ] Docker installed locally
- [ ] Git repository connected to cloud provider
- [ ] Environment variables configured
- [ ] Database service configured
- [ ] Domain name ready (optional)

## 🌟 Cloud Provider Comparison

| Provider | Cost/Month | Setup Time | Ease of Use | Database Included |
|----------|------------|------------|-------------|-------------------|
| **Render** | $14 | 5 min | ⭐⭐⭐⭐⭐ | ✅ PostgreSQL |
| **DigitalOcean** | $20 | 10 min | ⭐⭐⭐⭐ | ✅ PostgreSQL |
| **Vultr VPS** | $6+ | 30 min | ⭐⭐⭐ | Setup required |

## 🔧 Detailed Setup Instructions

### Render.com Deployment

1. **Create Render Account**: Sign up at [render.com](https://render.com)
2. **Connect GitHub**: Link your repository
3. **Create Web Service**:
   - Runtime: Docker
   - Build Command: `docker build -f deployment/Dockerfile .`
   - Start Command: Leave empty (uses Dockerfile)
4. **Add PostgreSQL Database**: 
   - Name: `big-love-postgres`
   - Plan: Starter ($7/month)
5. **Environment Variables**:
   ```
   NODE_ENV=production
   NODEBB_SECRET=your-32-character-secret-key
   LOG_LEVEL=info
   ```
6. **Deploy**: Click "Create Web Service"

### DigitalOcean App Platform

1. **Install doctl CLI**:
   ```bash
   # macOS
   brew install doctl
   
   # Ubuntu/Debian
   snap install doctl
   ```

2. **Authenticate**:
   ```bash
   doctl auth init
   ```

3. **Update configuration**:
   - Edit `deployment/digitalocean-app.yaml`
   - Change `your-username/big_love_app` to your repo
   - Update the secret key

4. **Deploy**:
   ```bash
   doctl apps create deployment/digitalocean-app.yaml
   ```

### Local Development

1. **Run deployment**:
   ```bash
   ./deployment/deploy.sh local
   ```

2. **Access NodeBB**:
   - URL: http://localhost:4567
   - First visit will trigger setup wizard

3. **View logs**:
   ```bash
   docker-compose -f deployment/docker-compose.cloud.yml logs -f nodebb
   ```

## 🔒 Security Configuration

### Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `NODEBB_SECRET` | JWT secret (32+ chars) | `your-super-secret-key-here` |
| `DATABASE_URL` | Full database connection | `postgres://user:pass@host:5432/db` |
| `URL` | Your domain URL | `https://yoursite.com` |
| `LOG_LEVEL` | Logging level | `info` |

### Security Best Practices

1. **Generate strong secrets**:
   ```bash
   # Generate random secret
   openssl rand -hex 32
   ```

2. **Use environment variables** for all sensitive data
3. **Enable HTTPS** on your domain
4. **Regular backups** of your database
5. **Keep NodeBB updated** regularly

## 🗄 Database Configuration

The deployment supports both PostgreSQL and Redis:

### PostgreSQL (Recommended)
- Better for large communities
- ACID compliance
- Built-in with cloud providers
- Automatic backups

### Redis
- Faster for small communities
- In-memory storage
- Requires persistence configuration

## 🚨 Troubleshooting

### Common Issues

1. **Port conflicts**:
   ```bash
   # Change port in .env file
   PORT=4568
   ```

2. **Database connection failed**:
   ```bash
   # Check DATABASE_URL format
   # postgres://username:password@host:port/database
   ```

3. **Build failures**:
   ```bash
   # Clear Docker cache
   docker system prune -a
   ```

4. **Memory issues**:
   ```bash
   # Increase Docker memory limit to 2GB+
   ```

### Debug Commands

```bash
# Check container logs
docker-compose -f deployment/docker-compose.cloud.yml logs nodebb

# Access container shell
docker-compose -f deployment/docker-compose.cloud.yml exec nodebb bash

# Check NodeBB status
docker-compose -f deployment/docker-compose.cloud.yml exec nodebb ./nodebb status
```

## 📊 Performance Optimization

### Production Recommendations

1. **Scale settings**:
   - Minimum 1GB RAM
   - 1+ CPU cores
   - SSD storage

2. **NodeBB configuration**:
   ```json
   {
     "logLevel": "warn",
     "session_store": {
       "name": "connect-pg-simple"
     }
   }
   ```

3. **Database tuning**:
   - Enable connection pooling
   - Set appropriate work_mem
   - Regular VACUUM

## 🔄 Updates and Maintenance

### Updating NodeBB

1. **Local testing**:
   ```bash
   # Test update locally first
   ./deployment/deploy.sh local
   ```

2. **Production update**:
   ```bash
   # Rebuild and redeploy
   git push origin main  # Triggers auto-deploy on most platforms
   ```

### Backup Strategy

1. **Database backups**: Use cloud provider's backup service
2. **File uploads**: Backup `/usr/src/app/public/uploads` volume
3. **Configuration**: Keep `config.json` in version control (without secrets)

## 📞 Support

- **NodeBB Docs**: https://docs.nodebb.org
- **Docker Issues**: Check container logs first
- **Cloud Provider Support**: Use their documentation and support channels

---

**Happy Deploying! 🎉**


