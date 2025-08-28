#!/bin/bash

# 🚀 GitHub Setup and Render Deployment Script
# Usage: ./setup_github_and_deploy.sh <github-repo-url>

set -e

if [ -z "$1" ]; then
    echo "❌ Error: Please provide GitHub repository URL"
    echo "Usage: ./setup_github_and_deploy.sh <github-repo-url>"
    echo "Example: ./setup_github_and_deploy.sh https://github.com/yourusername/big-love-app.git"
    exit 1
fi

GITHUB_REPO_URL="$1"

echo "🚀 Setting up GitHub repository and preparing Render deployment..."
echo "Repository URL: $GITHUB_REPO_URL"
echo ""

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "❌ Error: Not a git repository. Please run 'git init' first."
    exit 1
fi

# Check if we have commits
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
    echo "❌ Error: No commits found. Please commit your changes first."
    exit 1
fi

# Add GitHub remote if it doesn't exist
if git remote get-url origin >/dev/null 2>&1; then
    echo "📡 Updating existing remote origin..."
    git remote set-url origin "$GITHUB_REPO_URL"
else
    echo "📡 Adding GitHub remote..."
    git remote add origin "$GITHUB_REPO_URL"
fi

# Push to GitHub
echo "📤 Pushing code to GitHub..."
git push -u origin main

echo ""
echo "✅ Code successfully pushed to GitHub!"
echo ""
echo "🎯 Next Steps for Render Deployment:"
echo ""
echo "1. Go to https://render.com and sign in"
echo "2. Click 'New +' → 'Blueprint'"
echo "3. Connect your GitHub account if not already connected"
echo "4. Select your repository: $(basename "$GITHUB_REPO_URL" .git)"
echo "5. Render will detect the render.yaml file automatically"
echo "6. Click 'Apply' to start deployment"
echo ""
echo "📊 Expected Timeline:"
echo "- Initial deployment: 5-10 minutes"
echo "- Database setup: Automatic"
echo "- SSL certificate: Automatic"
echo ""
echo "💰 Cost: ~$14/month ($7 web service + $7 database)"
echo ""
echo "📱 After deployment, update your mobile app:"
echo "- Check MOBILE_APP_UPDATE_TEMPLATE.md for instructions"
echo "- Replace Railway URLs with your new Render URL"
echo ""
echo "🔍 Monitor deployment at: https://dashboard.render.com"
echo ""
echo "🎉 Your NodeBB will be available at a URL like:"
echo "   https://big-love-nodebb.onrender.com"
echo ""

# Commit and push the helper files
git add setup_github_and_deploy.sh MOBILE_APP_UPDATE_TEMPLATE.md
git commit -m "Add GitHub setup script and mobile app update template" || true
git push || echo "⚠️  Note: Could not push latest changes. Run 'git push' manually if needed."

echo "✨ Setup complete! Follow the steps above to deploy on Render."
