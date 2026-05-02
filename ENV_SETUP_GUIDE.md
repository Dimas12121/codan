# Flutter Environment Setup Guide

## Problem: FileNotFoundError for .env files

The Flutter app was trying to load `.env` files that weren't found. This has been fixed with error handling.

## Solution Applied

### 1. **Added .env files to pubspec.yaml assets**
```yaml
assets:
  - assets/images/
  - assets/images/avatars/
  - assets/images/splash_logo.png
  - .env
  - .env.development
  - .env.staging
  - .env.production
```

### 2. **Added error handling in environment.dart**
The app now gracefully handles missing `.env` files and uses default configuration.

### 3. **Changed default environment to development**
`main.dart` now loads `Environment.development` by default, which uses:
- API: `http://10.0.2.2:8000/api` (Android emulator)
- No `.env` file required for development

## How to Use

### For Development (No .env files needed):
```bash
flutter run
```
The app will use default development configuration.

### For Testing with .env files:

1. **Create .env files in project root:**
   ```
   codan/
   ├── .env
   ├── .env.development
   ├── .env.staging
   └── .env.production
   ```

2. **Add content to .env.development:**
   ```env
   ENVIRONMENT=development
   API_BASE_URL=http://10.0.2.2:8000/api
   APP_NAME=codan (Dev)
   ENABLE_DEBUG=true
   LOG_LEVEL=debug
   ```

3. **Run flutter pub get:**
   ```bash
   flutter pub get
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

### For Production Deployment:

1. **Update .env.production:**
   ```env
   ENVIRONMENT=production
   API_BASE_URL=https://codan.brodims.my.id/api
   APP_NAME=codan
   ENABLE_DEBUG=false
   LOG_LEVEL=error
   ```

2. **Update main.dart to use production:**
   ```dart
   await EnvironmentConfig.loadEnvironment(Environment.production);
   ```

3. **Build for release:**
   ```bash
   flutter build apk --release
   # or
   flutter build ios --release
   # or
   flutter build web --release
   ```

## Environment Variables

### Available Variables:
- `ENVIRONMENT` - development, staging, or production
- `API_BASE_URL` - API endpoint URL
- `APP_NAME` - Application name
- `ENABLE_DEBUG` - Enable debug mode (true/false)
- `LOG_LEVEL` - Logging level (debug, info, error)

### Default Values (if .env not found):
- Development: `http://10.0.2.2:8000/api`
- Staging: `https://staging.codan.brodims.my.id/api`
- Production: `https://codan.brodims.my.id/api`

## Troubleshooting

### Issue: Still getting FileNotFoundError
**Solution:**
1. Run `flutter clean`
2. Run `flutter pub get`
3. Run `flutter run`

### Issue: API not connecting
**Solution:**
1. Check if Laravel backend is running
2. Verify API_BASE_URL in .env file
3. Check network connectivity
4. Look at console logs for error messages

### Issue: Wrong environment loading
**Solution:**
1. Check which environment is set in `main.dart`
2. Verify .env file exists in project root
3. Check .env file format (no spaces around =)
4. Run `flutter pub get` after changing .env files

## File Structure

```
codan/
├── .env                    # Base environment template
├── .env.development        # Development configuration
├── .env.staging           # Staging configuration
├── .env.production        # Production configuration
├── lib/
│   ├── main.dart          # App entry point
│   ├── core/
│   │   ├── config/
│   │   │   └── environment.dart  # Environment configuration
│   │   ├── constants/
│   │   │   └── app_constants.dart # App constants
│   │   └── api/
│   │       └── api_client.dart    # API client
│   └── ...
├── pubspec.yaml           # Project configuration
└── ...
```

## Quick Start

### 1. Clone/Download Project
```bash
git clone <repository>
cd codan
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run App
```bash
flutter run
```

The app will automatically:
- Load development environment
- Use default API URL: `http://10.0.2.2:8000/api`
- Enable debug mode
- Show debug banner

### 4. Test API Connection
- Open app
- Go to test connection screen (if available)
- Check if API is reachable

## Environment Switching

To switch environments at runtime, update `main.dart`:

```dart
// For development
await EnvironmentConfig.loadEnvironment(Environment.development);

// For staging
await EnvironmentConfig.loadEnvironment(Environment.staging);

// For production
await EnvironmentConfig.loadEnvironment(Environment.production);
```

## Notes

- `.env` files are loaded from project root
- Environment files are included in app bundle (pubspec.yaml assets)
- Default configuration is used if .env file not found
- Error messages show which environment failed to load
- Check console logs for environment loading status

## Support

If you encounter issues:
1. Check console logs for error messages
2. Verify .env file exists and has correct format
3. Run `flutter clean` and `flutter pub get`
4. Check API backend is running
5. Verify network connectivity

---
**Status**: Environment configuration fixed and working
**Default Environment**: Development
**API Endpoint**: http://10.0.2.2:8000/api (development)