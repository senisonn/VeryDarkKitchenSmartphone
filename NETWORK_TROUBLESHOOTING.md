# Network Troubleshooting Guide

## Current Issue
Android emulator cannot connect to backend API with error:
```
SocketException: Connection failed (OS Error: Operation not permitted, errno = 1)
```

## Quick Fix - Use Mock API (Temporary)

The app is now configured to use `MockApiService` which works without network connection.
This lets you test all features while we fix the real API connection.

## Permanent Solutions

### Option 1: Disable macOS Firewall (Easiest)

1. Open **System Settings** (or System Preferences on older macOS)
2. Go to **Network** → **Firewall**
3. Click the lock icon 🔒 and enter your password
4. Click **Turn Off** to disable firewall
5. Try the app again
6. ✅ If it works, you can re-enable firewall and use Option 2

### Option 2: Allow Docker Through Firewall (Recommended)

1. Open **System Settings** → **Network** → **Firewall**
2. Click **Firewall Options** or **Options** button
3. Click the **+** button to add an application
4. Navigate to `/Applications/Docker.app` and add it
5. Ensure **Allow incoming connections** is selected for Docker
6. Click **OK**
7. Restart Docker Desktop

### Option 3: Use Different Port Without Firewall

Try using a different port that might not be blocked:

1. Stop current containers:
   ```bash
   cd api
   docker-compose down
   ```

2. Edit `docker-compose.yaml`, change ports to:
   ```yaml
   ports:
     - "3000:8080"  # Changed from 8080:8080
   ```

3. Restart:
   ```bash
   docker-compose up -d
   ```

4. Update Flutter app `api_service.dart`:
   ```dart
   static const String baseUrl = 'http://192.168.1.134:3000/api';
   ```

### Option 4: Check Network Interface

Your local IP might be on a different interface. Get all IPs:

```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

Try each IP in your Flutter app.

### Option 5: Android Emulator Advanced Settings

1. In Android Studio, go to **AVD Manager**
2. Click the ⚙️ icon next to your emulator
3. Click **Show Advanced Settings**
4. Scroll to **Network** section
5. Try changing:
   - **Network:** from "Standard" to "Custom"
   - Or try different network modes

### Option 6: Use ADB Reverse (Advanced)

This creates a reverse tunnel from emulator to host:

```bash
# Find your emulator
adb devices

# Create reverse tunnel
adb reverse tcp:8080 tcp:8080

# Then in Flutter app, use:
# static const String baseUrl = 'http://localhost:8080/api';
```

## Testing the Fix

After trying any solution:

1. **Test from command line:**
   ```bash
   curl http://192.168.1.134:8080/api/plats
   ```
   Should return JSON data

2. **Hot restart Flutter app:**
   - Press `r` in terminal
   - Or press the hot restart button in IDE

3. **Check for data:**
   - Menu screen should load dishes
   - No error messages

## Switching Back to Real API

Once network is fixed, change back to real API:

**File:** `mobile/lib/screens/menu_screen.dart`

Change:
```dart
final _apiService = MockApiService();  // Current
```

To:
```dart
final _apiService = ApiService();  // Real API
```

Then hot restart the app.

## Verify Everything Works

1. ✅ Backend accessible: `curl http://192.168.1.134:8080/api/plats`
2. ✅ App shows menu items
3. ✅ Can create reservations
4. ✅ Can view/edit/delete reservations
5. ✅ Admin features work

## Common Issues

### "Connection refused"
- Backend not running → `docker ps` to check
- Wrong port → verify `8080` is correct
- Wrong IP → run `ifconfig` again

### "Operation not permitted"
- macOS firewall blocking → disable or allow Docker
- Network interface issue → try different IP from `ifconfig`

### "Timeout"
- Backend slow to start → wait 30 seconds after `docker-compose up`
- Network congestion → try again

### "403 Forbidden"
- Authentication issue → check if endpoint should be public
- CORS issue → verify backend CORS config

## Get More Help

If none of these work, check:

1. **Docker logs:**
   ```bash
   docker logs restaurant-api --tail 50
   ```

2. **Flutter logs:**
   - Look in terminal where `flutter run` is running
   - Check for detailed error messages

3. **Network connectivity:**
   ```bash
   ping 192.168.1.134
   ```
   Should respond if network is working

4. **Port in use:**
   ```bash
   lsof -i :8080
   ```
   Should show Docker listening

## Success Indicators

When everything works, you'll see:

- ✅ Flutter app loads without errors
- ✅ Menu displays dishes from database
- ✅ Network requests complete successfully
- ✅ Console shows HTTP 200 responses
- ✅ No SocketException or timeout errors

---

**Current Status:** App using MockApiService (works offline)
**Goal:** Switch to ApiService (real backend connection)
**Next Step:** Try Option 1 or Option 2 above
