# Flutter App with FastAPI Backend - Setup Guide

This guide explains how to use the Flutter mobile app with the new FastAPI backend.

## What Changed

The Flutter app has been updated to work seamlessly with both the **Spring Boot** and **FastAPI** backends:

### ✅ Updates Made

1. **New Configuration System** (`lib/config/api_config.dart`)
   - Easy switching between FastAPI and Spring Boot
   - Configurable for different environments (emulator/simulator/physical device)
   - Simple one-line change to switch backends

2. **Updated Models** (`lib/models/reservation.dart`)
   - Compatible with both backend response formats
   - Added support for `userId` field (FastAPI)
   - Backward compatible with `idClient` (Spring Boot)
   - Added `dateCreation` and `plats` fields

3. **Improved Error Handling** (`lib/services/api_service.dart`)
   - Supports both FastAPI (`detail`) and Spring Boot (`message`) error formats
   - Better error messages showing which backend is being used
   - Improved connection error handling

## Quick Start

### 1. Start the FastAPI Backend

```bash
cd api_fastapi
docker-compose up
```

Or run locally:
```bash
cd api_fastapi
./run.sh
```

The API will be running at http://localhost:8000

### 2. Configure the Flutter App

Open `mobile/lib/config/api_config.dart` and ensure FastAPI is enabled:

```dart
// Set this to true to use FastAPI
static const bool useFastAPI = true;
```

### 3. Run the Flutter App

**For Android Emulator:**
```bash
cd mobile
flutter run
```

**For iOS Simulator:**
```bash
cd mobile
flutter run
```

**For Physical Device:**
1. Find your computer's IP address:
   - macOS/Linux: `ifconfig | grep "inet "`
   - Windows: `ipconfig`

2. Update `api_config.dart`:
   ```dart
   static const String? _physicalDeviceIP = '192.168.1.xxx'; // Your IP
   ```

3. Update the configuration to use physical device URL in the config file.

## Configuration Options

### Switch Between Backends

Edit `mobile/lib/config/api_config.dart`:

```dart
// Use FastAPI (port 8000)
static const bool useFastAPI = true;

// Use Spring Boot (port 8080)
static const bool useFastAPI = false;
```

### Change Base URL for Different Platforms

The app automatically detects the platform and uses the appropriate URL:

- **Android Emulator**: `10.0.2.2` (special IP for host machine)
- **iOS Simulator**: `localhost`
- **Physical Device**: Your computer's IP address

Current configuration uses `10.0.2.2` which works for Android emulator.

For iOS simulator, change:
```dart
static const String _fastapiBaseUrl = 'http://localhost:8000/api';
```

## Testing the Integration

### 1. Test Authentication

1. Launch the app
2. Tap "Se connecter" (Login)
3. Use default credentials:
   - Username: `admin`
   - Password: `admin`

### 2. Test Menu Display

1. The menu should load automatically on the main screen
2. You should see 8 dishes across different categories

### 3. Test Reservations

1. Select some dishes
2. Tap "Réserver une table"
3. Fill in the form:
   - Email
   - Phone number
   - Date and time
   - Number of people (1-20)
4. Submit the reservation
5. Check "Mes Réservations" to see your reservation

### 4. Test Admin Features

1. Login as admin (admin/admin)
2. Access admin panel
3. View pending reservations
4. Approve or reject reservations

## Troubleshooting

### "Connection Refused" Error

**For Android Emulator:**
- Make sure you're using `10.0.2.2` in the config
- FastAPI must be running on your host machine
- Check firewall settings

**For iOS Simulator:**
- Change to `localhost` in the config
- FastAPI must be running on your host machine

**For Physical Device:**
- Make sure device and computer are on the same network
- Set your computer's IP in `_physicalDeviceIP`
- Check firewall allows incoming connections on port 8000

### "Token Invalid" or Auth Errors

1. Logout and login again
2. Make sure the backend is running
3. Check if the token is being saved correctly

### Data Not Loading

1. Check the terminal/console for error messages
2. Verify the backend is running: http://localhost:8000/docs
3. Test the API directly in the browser or Postman
4. Clear app data and try again

### Wrong Backend Being Used

Check the console output - the error messages will show which backend is active:
```
Erreur de connexion au serveur FastAPI: ...
```
or
```
Erreur de connexion au serveur Spring Boot: ...
```

## API Endpoint Compatibility

Both backends use identical endpoints:

| Endpoint | FastAPI | Spring Boot | Compatible |
|----------|---------|-------------|------------|
| POST /api/auth/register | ✅ | ✅ | ✅ |
| POST /api/auth/login | ✅ | ✅ | ✅ |
| GET /api/plats | ✅ | ✅ | ✅ |
| POST /api/reservations | ✅ | ✅ | ✅ |
| GET /api/reservations/user/{id} | ✅ | ✅ | ✅ |
| PUT /api/reservations/{id} | ✅ | ✅ | ✅ |
| DELETE /api/reservations/{id} | ✅ | ✅ | ✅ |
| POST /api/reservations/availability | ✅ | ✅ | ✅ |
| GET /api/reservations/pending | ✅ | ✅ | ✅ |
| PUT /api/reservations/{id}/approve | ✅ | ✅ | ✅ |
| PUT /api/reservations/{id}/reject | ✅ | ✅ | ✅ |

## Development Tips

### Enable Debug Logging

Add print statements in `api_service.dart` to see requests:

```dart
Future<AuthResponse> login(LoginRequest request) async {
  print('Logging in to: $baseUrl/auth/login');
  print('Using backend: ${ApiConfig.backendName}');
  // ... rest of code
}
```

### Test API Directly

Before running the app, test the API:

```bash
# Test login
curl -X POST "http://localhost:8000/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin"}'

# Test menu
curl "http://localhost:8000/api/plats"
```

### Compare Responses

To verify compatibility, compare responses from both backends:

```bash
# FastAPI
curl "http://localhost:8000/api/plats" | jq

# Spring Boot
curl "http://localhost:8080/api/plats" | jq
```

They should be identical!

## Advanced Configuration

### Using Environment Variables

You can make the configuration even more dynamic by using environment variables:

```dart
// In api_config.dart
static String get baseUrl {
  final envBackend = const String.fromEnvironment('BACKEND', defaultValue: 'fastapi');
  return envBackend == 'fastapi' ? _fastapiBaseUrl : _springBootBaseUrl;
}
```

Then run:
```bash
flutter run --dart-define=BACKEND=fastapi
# or
flutter run --dart-define=BACKEND=springboot
```

### Multiple Environments

Create different configurations for dev, staging, production:

```dart
enum Environment { dev, staging, prod }

static const Environment currentEnv = Environment.dev;

static String get baseUrl {
  switch (currentEnv) {
    case Environment.dev:
      return useFastAPI ? 'http://10.0.2.2:8000/api' : 'http://10.0.2.2:8080/api';
    case Environment.staging:
      return 'https://staging-api.example.com/api';
    case Environment.prod:
      return 'https://api.example.com/api';
  }
}
```

## Summary

The Flutter app now:
- ✅ Works with both FastAPI and Spring Boot backends
- ✅ Easy to switch between backends (one line change)
- ✅ Better error handling
- ✅ Compatible response parsing
- ✅ Configurable for all platforms (Android/iOS/Physical devices)

You can now develop with FastAPI's fast reload and automatic docs, or use Spring Boot's enterprise features - the choice is yours!
