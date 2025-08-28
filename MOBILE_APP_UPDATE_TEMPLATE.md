# 📱 Mobile App Configuration Update

## Files to Update After Render Deployment

Once your NodeBB is deployed to Render and you have the new URL, update these files:

### 1. Main API Configuration
**File:** `mobile/lib/config/api_config.dart`

**Current Configuration:**
```dart
static const String baseUrl = 'https://extraordinary-heart-production-3220.up.railway.app';
```

**Update to:**
```dart
static const String baseUrl = 'https://YOUR-NEW-RENDER-URL.onrender.com';
```

### 2. Test Integration File
**File:** `mobile/test_flutter_integration.dart` (line 12)

**Current:**
```dart
final baseUrl = 'https://kind-vibrancy-production.up.railway.app';
```

**Update to:**
```dart
final baseUrl = 'https://YOUR-NEW-RENDER-URL.onrender.com';
```

## 🔄 How to Update

Once you have your Render URL (after deployment):

1. **Update API Config:**
```bash
# Replace YOUR-RENDER-URL with your actual Render URL
sed -i '' 's|https://extraordinary-heart-production-3220.up.railway.app|https://YOUR-RENDER-URL.onrender.com|g' mobile/lib/config/api_config.dart
```

2. **Update Test File:**
```bash
# Replace YOUR-RENDER-URL with your actual Render URL  
sed -i '' 's|https://kind-vibrancy-production.up.railway.app|https://YOUR-RENDER-URL.onrender.com|g' mobile/test_flutter_integration.dart
```

3. **Test the Mobile App:**
```bash
cd mobile
flutter clean
flutter pub get
flutter test
```

## 📋 Checklist After Update

- [ ] Updated `mobile/lib/config/api_config.dart`
- [ ] Updated `mobile/test_flutter_integration.dart`  
- [ ] Tested Flutter app builds successfully
- [ ] Verified API connection works
- [ ] Tested login/registration functionality
- [ ] Confirmed posts loading correctly

## 🧪 Testing Commands

```bash
# Test API connection
cd mobile
dart test_flutter_integration.dart

# Run Flutter tests
flutter test

# Test on device/simulator
flutter run
```

## 🎯 Expected Render URL Format

Your Render URL will look like:
- `https://big-love-nodebb.onrender.com` (if you named the service "big-love-nodebb")
- Or `https://your-service-name.onrender.com`

## 📱 API Endpoints That Will Work

After the update, these endpoints will be available:
- `GET /api/config` - App configuration
- `POST /api/login` - User authentication  
- `POST /api/register` - User registration
- `GET /api/posts` - Forum posts
- `GET /api/categories` - Forum categories
- `GET /api/user/profile` - User profile

---

**Note:** Save this file for reference after your Render deployment is complete!
