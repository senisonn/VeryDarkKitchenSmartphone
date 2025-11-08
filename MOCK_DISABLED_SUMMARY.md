# Mock Services Disabled - Real API Enabled ✅

## What Was Changed

All Flutter screens have been updated to use the **real API service** instead of mock services. The app is now ready to test with your actual backend!

## Files Updated

### ✅ Screens Changed from Mock to Real API

1. **`lib/screens/menu_screen.dart`**
   - ❌ Was: `final _apiService = MockApiService();`
   - ✅ Now: `final _apiService = ApiService();`
   - Removed unused import

2. **`lib/screens/login_screen.dart`**
   - ❌ Was: `import '../services/mock_api_service.dart'` + `MockApiService()`
   - ✅ Now: `import '../services/api_service.dart'` + `ApiService()`

3. **`lib/screens/register_screen.dart`**
   - ❌ Was: `import '../services/mock_api_service.dart'` + `MockApiService()`
   - ✅ Now: `import '../services/api_service.dart'` + `ApiService()`

4. **`lib/screens/reservation_screen.dart`**
   - ❌ Was: `import '../services/mock_api_service.dart'` + `MockApiService()`
   - ✅ Now: `import '../services/api_service.dart'` + `ApiService()`

### ✅ Already Using Real API (No Changes)

These screens were already using the real API:
- `lib/screens/admin_reservations_screen.dart`
- `lib/screens/my_reservations_screen.dart`
- `lib/screens/edit_reservation_screen.dart`

## Verification

All screens now use the real API service:

```bash
$ grep "= ApiService()" lib/screens/*.dart
lib/screens/admin_reservations_screen.dart:15:  final ApiService _apiService = ApiService();
lib/screens/edit_reservation_screen.dart:18:  final ApiService _apiService = ApiService();
lib/screens/login_screen.dart:17:  final _apiService = ApiService();
lib/screens/menu_screen.dart:15:  final _apiService = ApiService();
lib/screens/my_reservations_screen.dart:14:  final ApiService _apiService = ApiService();
lib/screens/register_screen.dart:17:  final _apiService = ApiService();
lib/screens/reservation_screen.dart:18:  final _apiService = ApiService();
```

✅ **No MockApiService references found!**

## Build Status

```bash
$ flutter analyze
Analyzing mobile...

4 issues found. (ran in 1.4s)
```

Only **informational warnings** remain (not errors):
- Some async BuildContext warnings (standard Flutter pattern)
- One field could be final

✅ **No errors, ready to run!**

## How to Test with Real API

### Option 1: Test with FastAPI Backend

1. **Start FastAPI backend:**
   ```bash
   cd api_fastapi
   docker-compose up
   ```
   API will be at: http://localhost:8000

2. **Verify backend is running:**
   ```bash
   curl http://localhost:8000/health
   # Should return: {"status":"healthy"}
   ```

3. **Configure Flutter (already set by default):**
   File: `lib/config/api_config.dart`
   ```dart
   static const bool useFastAPI = true;  // ✅ Already set
   ```

4. **Run Flutter app:**
   ```bash
   cd mobile
   flutter run
   ```

### Option 2: Test with Spring Boot Backend

1. **Start Spring Boot backend:**
   ```bash
   cd api
   ./mvnw spring-boot:run
   ```
   API will be at: http://localhost:8080

2. **Configure Flutter:**
   File: `lib/config/api_config.dart`
   ```dart
   static const bool useFastAPI = false;  // Switch to Spring Boot
   ```

3. **Run Flutter app:**
   ```bash
   cd mobile
   flutter run
   ```

## Test Credentials

Both backends have the same test users:

| Username | Password | Role  |
|----------|----------|-------|
| admin    | admin    | ADMIN |
| user     | user     | USER  |

## Full Test Flow

### 1. Test Menu Loading
- Launch app
- Menu should load automatically from API
- Should see 8+ dishes

### 2. Test Registration
- Tap "S'inscrire" (Register)
- Create new account
- Should receive JWT token
- Should navigate to menu

### 3. Test Login
- Tap "Se connecter" (Login)
- Use: `admin` / `admin`
- Should receive JWT token
- Should navigate to menu

### 4. Test Reservation Creation
- Select some dishes from menu
- Tap "Réserver une table"
- Fill in form:
  - Email
  - Phone
  - Date (must be future)
  - Number of people (1-20)
- Submit
- Should create reservation on backend
- Check "Mes Réservations" to verify

### 5. Test Admin Features (login as admin)
- Login as admin/admin
- Navigate to admin panel
- Should see pending reservations
- Test approve/reject functions

## Troubleshooting

### "Connection Refused" Error

**Problem:** App can't connect to backend

**Solutions:**

**For Android Emulator:**
- Backend must be running
- URL should use `10.0.2.2` (not localhost)
- Check `lib/config/api_config.dart`:
  ```dart
  static const String _fastapiBaseUrl = 'http://10.0.2.2:8000/api';
  ```

**For iOS Simulator:**
- Backend must be running
- URL should use `localhost`
- Change in `lib/config/api_config.dart`:
  ```dart
  static const String _fastapiBaseUrl = 'http://localhost:8000/api';
  ```

**For Physical Device:**
- Find your computer's IP address:
  ```bash
  # macOS/Linux
  ifconfig | grep "inet "

  # Windows
  ipconfig
  ```
- Update in `lib/config/api_config.dart`:
  ```dart
  static const String? _physicalDeviceIP = '192.168.1.xxx';
  ```

### Backend Not Responding

**Check if backend is running:**

```bash
# FastAPI
curl http://localhost:8000/health

# Spring Boot
curl http://localhost:8080/actuator/health
```

**View backend logs:**

```bash
# FastAPI with Docker
docker-compose logs -f api

# Spring Boot
# Check terminal where mvnw is running
```

### "Invalid Token" or Auth Errors

**Solution:**
1. Logout from app
2. Login again
3. New token will be generated

### No Data Loading

**Debug steps:**
1. Check Flutter console for errors
2. Verify backend is running
3. Test API directly with curl
4. Check network logs in Flutter DevTools

### Wrong Backend Being Used

**Check error messages** - they show which backend:
```
Erreur de connexion au serveur FastAPI: ...
```
or
```
Erreur de connexion au serveur Spring Boot: ...
```

**Verify configuration:**
```bash
grep "useFastAPI" lib/config/api_config.dart
# Should show: static const bool useFastAPI = true;  (or false)
```

## API Documentation

### FastAPI (when running on port 8000)
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **Health**: http://localhost:8000/health

### Spring Boot (when running on port 8080)
- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **Health**: http://localhost:8080/actuator/health

## Quick Reference Commands

```bash
# Start FastAPI backend
cd api_fastapi && docker-compose up

# Start Spring Boot backend
cd api && ./mvnw spring-boot:run

# Run Flutter app
cd mobile && flutter run

# Clean and rebuild Flutter
cd mobile && flutter clean && flutter pub get && flutter run

# Test API (FastAPI)
curl http://localhost:8000/api/plats

# Test API (Spring Boot)
curl http://localhost:8080/api/plats

# Check Flutter for errors
cd mobile && flutter analyze
```

## What's Next

Now that mock services are disabled, you can:

1. ✅ **Test real authentication** - Login/register with actual backend
2. ✅ **Test database persistence** - Data is saved to PostgreSQL
3. ✅ **Test JWT tokens** - Real token generation and validation
4. ✅ **Test business logic** - Availability checking, validations, etc.
5. ✅ **Test admin features** - Approve/reject reservations
6. ✅ **Compare backends** - Switch between FastAPI and Spring Boot
7. ✅ **Monitor API calls** - See requests/responses in backend logs
8. ✅ **Test error handling** - See how app handles API errors

## Summary

✅ **Mock services are now disabled**
✅ **All screens use real API**
✅ **No build errors**
✅ **Ready to test with FastAPI or Spring Boot**
✅ **Easy backend switching via config**

Your Flutter app is now fully connected to the real backend! 🚀

---

For more information:
- **Setup Guide**: `FLUTTER_FASTAPI_SETUP.md`
- **FastAPI Guide**: `api_fastapi/QUICKSTART.md`
- **Update Summary**: `FLUTTER_UPDATE_COMPLETE.md`
