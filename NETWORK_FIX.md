# Network Connection Fix

## Problem
Android app was unable to connect to backend API with error:
```
SocketException: Connection failed (OS Error: Operation not permitted, errno = 1)
```

## Root Causes

1. **Incorrect URL for Android Emulator**
   - Used: `http://localhost:8080`
   - Problem: `localhost` in Android emulator refers to the emulator itself, not the host machine

2. **Missing Internet Permission**
   - Android requires explicit permission for network access

3. **Cleartext Traffic Blocked**
   - Android 9+ blocks HTTP (non-HTTPS) traffic by default for security

4. **Restricted API Endpoints**
   - `/api/plats` endpoint required authentication but should be public

## Solutions Applied

### 1. Updated API URL
**File**: `mobile/lib/services/api_service.dart`

```dart
static const String baseUrl = 'http://10.0.2.2:8080/api';
```

**Platform-Specific URLs**:
- Android Emulator: `http://10.0.2.2:8080/api` ✅
- iOS Simulator: `http://localhost:8080/api`
- Physical Device: `http://YOUR_COMPUTER_IP:8080/api`

### 2. Added Internet Permission
**File**: `mobile/android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### 3. Enabled Cleartext Traffic
**File**: `mobile/android/app/src/main/res/xml/network_security_config.xml`

Created new file:
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">10.0.2.2</domain>
        <domain includeSubdomains="true">localhost</domain>
        <domain includeSubdomains="true">127.0.0.1</domain>
    </domain-config>
</network-security-config>
```

**File**: `mobile/android/app/src/main/AndroidManifest.xml`

Added to `<application>` tag:
```xml
android:networkSecurityConfig="@xml/network_security_config"
```

### 4. Made Menu Endpoint Public
**File**: `api/src/main/java/.../config/SecurityConfig.java`

```java
.authorizeHttpRequests(auth -> auth
    .requestMatchers("/api/auth/**").permitAll()
    .requestMatchers("/api/plats/**").permitAll()  // Added this line
    .requestMatchers("/api/admin/**").hasRole("ADMIN")
    .anyRequest().authenticated()
)
```

## Testing Steps

1. **Verify backend is running**:
   ```bash
   docker ps
   ```
   Should show `restaurant-api` and `restaurant-postgres` containers

2. **Test API endpoint**:
   ```bash
   curl http://localhost:8080/api/plats
   ```
   Should return list of dishes (not 403 Forbidden)

3. **Run Flutter app**:
   ```bash
   cd mobile
   flutter clean
   flutter run
   ```

4. **Expected Result**:
   - Menu screen loads successfully
   - Dishes are displayed from database
   - No connection errors

## Network Architecture

```
┌─────────────────────────┐
│  Android Emulator       │
│  (10.0.0.2)             │
│                         │
│  Flutter App            │
│  └─> 10.0.2.2:8080     │ ← Special IP to access host
└─────────────────────────┘
           ↓ HTTP
┌─────────────────────────┐
│  Host Machine           │
│  (macOS)                │
│                         │
│  localhost:8080         │
│  └─> Spring Boot API   │
└─────────────────────────┘
           ↓ JDBC
┌─────────────────────────┐
│  Docker Container       │
│  restaurant-postgres    │
│  └─> PostgreSQL         │
└─────────────────────────┘
```

## Important Notes

### For Production

The cleartext traffic configuration is **ONLY for development**. For production:

1. Use HTTPS with proper SSL certificates
2. Remove the network security config or restrict it:
   ```xml
   <network-security-config>
       <base-config cleartextTrafficPermitted="false" />
   </network-security-config>
   ```

### For Physical Devices

If testing on a real phone:

1. Find your computer's IP:
   ```bash
   ifconfig | grep "inet " | grep -v 127.0.0.1
   ```

2. Update `api_service.dart`:
   ```dart
   static const String baseUrl = 'http://YOUR_IP:8080/api';
   ```

3. Ensure phone and computer are on same WiFi network

4. Update network security config to include your IP:
   ```xml
   <domain includeSubdomains="true">192.168.1.100</domain>
   ```

## Verification

After applying all fixes, you should see:

✅ App launches without errors
✅ Menu screen displays dishes from database
✅ Navigation works properly
✅ Reservations can be created/viewed/edited
✅ Admin features accessible

## Troubleshooting

### Still getting connection errors?

1. **Check backend is running**:
   ```bash
   docker logs restaurant-api --tail 50
   ```
   Look for "Started VerydarkkitchensmartphoneApplication"

2. **Verify database is healthy**:
   ```bash
   docker ps
   ```
   Status should show "Up" and "healthy"

3. **Test API directly**:
   ```bash
   curl http://localhost:8080/api/plats
   ```
   Should return JSON array of dishes

4. **Check Flutter app uses correct URL**:
   ```bash
   grep "baseUrl" mobile/lib/services/api_service.dart
   ```
   Should show `http://10.0.2.2:8080/api`

5. **Rebuild Flutter app completely**:
   ```bash
   cd mobile
   flutter clean
   rm -rf build/
   flutter pub get
   flutter run
   ```

### Getting 403 Forbidden?

The `/api/plats` endpoint requires authentication. Make sure:
- Backend has been rebuilt with updated SecurityConfig
- Container shows recent timestamp (should be current time, not hours ago)

### iOS-specific issues?

iOS uses different networking:
- Change `baseUrl` to `http://localhost:8080/api`
- No network security config needed
- May need to add to `Info.plist`:
  ```xml
  <key>NSAppTransportSecurity</key>
  <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
  </dict>
  ```

## Summary

All network connectivity issues have been resolved with 4 key changes:

1. ✅ Correct Android emulator IP (`10.0.2.2`)
2. ✅ Internet permission in manifest
3. ✅ Cleartext traffic allowed for development
4. ✅ Public access to menu endpoint

The app should now connect successfully to the backend API!
