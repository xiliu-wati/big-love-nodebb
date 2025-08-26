# Big Love Community App

A modern community platform with Flutter mobile app and Node.js backend.

## Project Structure

```
big_love_app/
├── mobile/                 # Flutter mobile application
│   ├── lib/               # Flutter source code
│   ├── android/           # Android platform files
│   ├── ios/               # iOS platform files
│   ├── web/               # Web platform files
│   ├── pubspec.yaml       # Flutter dependencies
│   └── test/              # Flutter tests
├── backend/               # Express.js backend server
│   ├── server.js          # Main server file
│   ├── package.json       # Node.js dependencies
│   ├── Dockerfile         # Docker configuration
│   ├── tests/             # Backend API tests
│   └── run_tests.sh       # Test runner script
├── docs/                  # Project documentation
│   ├── big_love_app_prd.md           # Product Requirements
│   ├── big_love_tech_design.md       # Technical Design
│   ├── README.md                     # Original README
│   └── FLUTTER_INTEGRATION_SUMMARY.md # Integration docs
├── deployment/            # Deployment configurations
│   ├── deploy.sh          # Main deployment script
│   ├── render_deploy/     # Render.com config
│   └── digitalocean_deploy/ # DigitalOcean config
└── archive/               # Old/unused files
    ├── big_love_flutter/  # Original Flutter project
    ├── nodebb_backend/    # NodeBB attempt
    └── nodebb_minimal/    # Minimal NodeBB
```

## Quick Start

### Backend (Express.js API)
```bash
cd backend
npm install
npm start
# Server runs on http://localhost:4567
```

### Mobile App (Flutter)
```bash
cd mobile
flutter pub get
flutter run
# For Android APK: flutter build apk --release
```

### Testing
```bash
# Backend API tests
cd backend
./run_tests.sh

# Flutter integration test
cd mobile
dart test_flutter_integration.dart
```

## Live Backend
- **URL**: https://kind-vibrancy-production.up.railway.app
- **API Docs**: https://kind-vibrancy-production.up.railway.app/api
- **Health Check**: https://kind-vibrancy-production.up.railway.app/health

## Features
- User authentication (register/login)
- Post creation and viewing
- User profiles
- Real-time community feed
- Cross-platform mobile support (iOS/Android)

## Development Status
- ✅ Backend API deployed and working
- ✅ Flutter app connected to backend
- ✅ User authentication flow
- ✅ Post creation and feed
- 🔄 Android APK build (in progress)
- ⏳ iOS build (pending)
- ⏳ App store deployment (pending)

## Tech Stack
- **Mobile**: Flutter (Dart)
- **Backend**: Express.js (Node.js)
- **Database**: In-memory (development)
- **Deployment**: Railway (backend), Local build (mobile)
- **Testing**: Curl scripts, Dart tests

## Next Steps
1. Complete Android APK build
2. Test on physical Android device
3. Implement additional features (comments, likes, etc.)
4. Add persistent database
5. Deploy to app stores
