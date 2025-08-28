# 🚀 NodeBB Deployment to Render.com

## Overview
This guide will help you deploy your NodeBB forum from Railway to Render.com using PostgreSQL database.

## ✅ Pre-Deployment Checklist

### 1. GitHub Repository ✅ 
- [x] Code committed to Git
- [x] Configuration updated for Render
- [ ] Repository pushed to GitHub (you'll do this)

### 2. Render Account Setup
- [ ] Create account at [render.com](https://render.com)
- [ ] Connect your GitHub account
- [ ] Verify email if required

## 🎯 Deployment Steps

### Step 1: Push Code to GitHub
Once you have your GitHub repository URL:
```bash
git remote add origin YOUR_GITHUB_REPO_URL
git push -u origin main
```

### Step 2: Deploy on Render
1. Log into [Render.com](https://render.com)
2. Click "New +" → "Blueprint"
3. Connect your GitHub repository
4. Select the repository with your NodeBB code
5. Render will automatically detect the `deployment/render.yaml` file
6. Click "Apply" to start deployment

### Step 3: Configure Environment Variables
Render will automatically set up these environment variables:
- `NODE_ENV=production`
- `LOG_LEVEL=info`
- `NODEBB_SECRET` (auto-generated)
- `URL` (auto-generated based on your Render URL)
- `DATABASE_URL` (auto-generated from PostgreSQL database)
- `PORT=4567`

### Step 4: Monitor Deployment
- Deployment takes about 5-10 minutes
- Watch the build logs in Render dashboard
- First build might take longer due to npm install

### Step 5: Access Your Forum
Once deployed, you'll get a URL like: `https://big-love-nodebb.onrender.com`

## 💰 Costs
- **Web Service**: $7/month (Starter plan)
- **PostgreSQL Database**: $7/month (Starter plan)
- **Total**: $14/month

## 🔧 Post-Deployment Setup

### 1. Complete NodeBB Setup
1. Visit your new Render URL
2. Complete the NodeBB installation wizard
3. Create admin account
4. Configure forum settings

### 2. Update Mobile App
Update these files in your Flutter app:
- `mobile/lib/config/app_config.dart` (if exists)
- Update API base URL to your new Render URL

### 3. Configure Domain (Optional)
1. In Render dashboard, go to your web service
2. Add custom domain under "Settings" → "Custom Domains"
3. Update DNS records as instructed by Render

## 🛠 Troubleshooting

### Common Issues:
1. **Build Fails**: Check Docker logs in Render dashboard
2. **Database Connection**: Verify DATABASE_URL environment variable
3. **404 Errors**: Check that URL environment variable is correct

### Health Check:
Your NodeBB health is monitored at: `https://your-url.onrender.com/api`

## 📱 Mobile App Updates Needed

After deployment, update your Flutter app to point to the new URL:

```dart
// In mobile/lib/config/app_config.dart (or similar)
const String API_BASE_URL = 'https://big-love-nodebb.onrender.com';
```

## 🔒 Security Features

✅ **Enabled by Default:**
- HTTPS encryption (automatic)
- Non-root Docker container
- Database SSL connections
- Environment-based secrets
- Health monitoring

## 📊 Monitoring & Maintenance

### Render Dashboard Features:
- Real-time logs
- Performance metrics
- Automatic scaling
- SSL certificate management
- Backup & restore (database)

### Recommended Monitoring:
1. Set up Render email alerts for downtime
2. Monitor database usage
3. Check logs weekly for errors

## 🎉 What's Different from Railway?

| Feature | Railway | Render |
|---------|---------|---------|
| Database | Redis | PostgreSQL |
| SSL | Manual | Automatic |
| Domain | Subdomain | Custom domain support |
| Monitoring | Basic | Advanced dashboard |
| Cost | Variable | Fixed $14/month |
| Reliability | Good | Excellent |

## 📞 Support

- **Render Docs**: https://render.com/docs
- **NodeBB Docs**: https://docs.nodebb.org
- **This deployment**: All configuration files in `/deployment/` folder

---

**Your NodeBB is now ready for Render deployment! 🎉**
