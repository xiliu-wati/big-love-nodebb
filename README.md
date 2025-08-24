# Big Love Community App

A complete community platform with Flutter mobile app and NodeBB backend, designed for sharing, interaction, and building connections.

## 🌟 Features

### Mobile App (Flutter)
- **Cross-platform**: iOS and Android support
- **Authentication**: Email/password registration and login
- **Feed**: Unified timeline with posts, images, and videos
- **Post Creation**: Rich text posts with image upload
- **Engagement**: Like, comment, and share posts
- **User Profiles**: Customizable profiles with stats
- **Real-time**: Live updates and notifications
- **Moderation**: Report content and user blocking

### Backend (NodeBB)
- **Scalable**: Handles millions of users
- **Real-time**: WebSocket support for live interactions
- **API-first**: RESTful API for mobile integration
- **User Management**: Roles, groups, and permissions
- **Content Management**: Posts, comments, media uploads
- **Moderation Tools**: Admin panel and content filtering
- **Extensible**: Plugin system for custom features

## 🚀 Quick Start

### Prerequisites

- **Node.js** 18+ (for backend)
- **Flutter SDK** 3.10+ (for mobile app)
- **Docker** (optional, for containerized deployment)
- **Redis** (for NodeBB database)

### One-Click Deployment

```bash
# Clone the repository
git clone <your-repo-url>
cd big_love_app

# Run the deployment script
./deploy.sh
```

The script will:
1. Deploy NodeBB backend to Railway (or run locally)
2. Build Flutter APK for Android
3. Configure API endpoints automatically

### Manual Setup

#### 1. Backend Setup

```bash
cd nodebb_backend
./setup.sh
npm start
```

Backend will be available at: http://localhost:4567

#### 2. Flutter App Setup

```bash
cd big_love_flutter

# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Or build APK
flutter build apk --release
```

## 📱 Installation on Android

1. **Download APK**: Get `big_love_app.apk` from the build output
2. **Enable Unknown Sources**: 
   - Go to Settings > Security
   - Enable "Install from unknown sources"
3. **Install**: Open the APK file and follow installation prompts

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │   NodeBB API    │
│                 │◄──►│                 │
│  • Authentication│    │  • User Mgmt    │
│  • Feed Display │    │  • Posts/Topics │
│  • Post Creation│    │  • Comments     │
│  • User Profile │    │  • Moderation   │
└─────────────────┘    └─────────────────┘
                              │
                       ┌─────────────────┐
                       │     Redis       │
                       │   Database      │
                       └─────────────────┘
```

## 🔧 Configuration

### Backend Configuration

Edit `nodebb_backend/config.json`:

```json
{
  "url": "https://your-domain.com",
  "database": "redis",
  "redis": {
    "host": "localhost",
    "port": 6379
  },
  "port": 4567
}
```

### Flutter Configuration

Edit `big_love_flutter/lib/config/api_config.dart`:

```dart
class ApiConfig {
  static const String baseUrl = 'https://your-backend-url.com/api/v3';
}
```

## 🌐 Deployment Options

### Railway (Recommended)

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login and deploy
railway login
cd nodebb_backend
railway init
railway add redis
railway up
```

### DigitalOcean App Platform

1. Connect GitHub repository
2. Choose Node.js environment
3. Add Redis database addon
4. Deploy automatically

### Docker

```bash
cd nodebb_backend
docker-compose up -d
```

## 📊 User Roles & Permissions

| Role | Permissions |
|------|-------------|
| **Regular User** | Post, comment, like, report content |
| **MVP User** | Premium features, priority support, exclusive content |
| **Special User** | Advanced posting, extended limits, priority moderation |
| **Moderator** | Content moderation, user warnings, report handling |
| **Admin** | Full system access, user management, configuration |

## 🔌 API Endpoints

### Authentication
- `POST /api/v3/utilities/login` - User login
- `POST /api/v3/users` - User registration

### Posts
- `GET /api/v3/topics` - Get posts feed
- `POST /api/v3/topics` - Create new post
- `GET /api/v3/topics/{id}` - Get post details

### Users
- `GET /api/v3/users/{id}` - Get user profile
- `PUT /api/v3/users/{id}` - Update profile

### Moderation
- `POST /api/v3/flags` - Report content

## 🎨 Customization

### Mobile App Theming

Edit `big_love_flutter/lib/utils/theme.dart`:

```dart
static const Color primaryColor = Color(0xFF6B46C1); // Purple
static const Color secondaryColor = Color(0xFF10B981); // Green
```

### Backend Plugins

```bash
cd nodebb_backend
npm install nodebb-plugin-mentions
npm install nodebb-plugin-emoji
./nodebb build
```

## 📈 Monitoring & Analytics

### Health Checks
- Backend: `GET /api/config`
- Mobile: Built-in crash reporting

### Logs
```bash
# Docker logs
docker-compose logs -f

# Railway logs
railway logs

# Flutter logs
flutter logs
```

## 🔒 Security Features

- **HTTPS**: All API communication encrypted
- **Input Validation**: Server-side validation and sanitization
- **Rate Limiting**: API rate limiting by user level
- **Content Moderation**: User reporting and admin tools
- **Secure Storage**: Encrypted local storage for tokens

## 🧪 Testing

### Backend Testing
```bash
cd nodebb_backend
npm test
```

### Flutter Testing
```bash
cd big_love_flutter
flutter test
```

## 📚 Documentation

- [NodeBB Documentation](https://docs.nodebb.org)
- [Flutter Documentation](https://docs.flutter.dev)
- [API Reference](./API.md)
- [Deployment Guide](./DEPLOYMENT.md)

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Issues**: Create GitHub issue
- **Discussions**: Use GitHub Discussions
- **Email**: support@biglove.app

## 🎉 Acknowledgments

- [NodeBB](https://nodebb.org) - Forum platform
- [Flutter](https://flutter.dev) - Mobile framework
- [Railway](https://railway.app) - Deployment platform

---

**Built with ❤️ for the Big Love Community**
