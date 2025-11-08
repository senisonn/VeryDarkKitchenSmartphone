# Android Emulator Connection Fix

## Problem
```
Error: ClientException with SocketException: Connection failed (OS Error: Operation not permitted)
address = 10.0.2.2, port = 8000
```

The Android emulator **cannot access your FastAPI backend** running in Docker because macOS is blocking the connection.

## ✅ Backend Status
- ✅ FastAPI is running on port 8000
- ✅ Accessible from host: http://localhost:8000
- ❌ Not accessible from emulator: http://10.0.2.2:8000

## Solutions (Choose One)

### Solution 1: Use Host IP Address (EASIEST - Recommended)

Instead of using `10.0.2.2`, use your Mac's actual IP address.

#### Step 1: Find Your IP Address

```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

You should see something like:
```
inet 192.168.1.XXX netmask 0xffffff00 broadcast 192.168.1.255
```

The IP is `192.168.1.XXX`

#### Step 2: Update Flutter Configuration

Edit: `mobile/lib/config/api_config.dart`

```dart
class ApiConfig {
  // CHANGE THIS to your Mac's IP address
  static const String _hostIP = '192.168.1.XXX';  // ← Put your IP here

  // FastAPI Backend
  static const String _fastapiBaseUrl = 'http://$_hostIP:8000/api';

  // Spring Boot Backend
  static const String _springBootBaseUrl = 'http://$_hostIP:8080/api';

  // Rest of the code stays the same...
  static const bool useFastAPI = true;
  static String get baseUrl => useFastAPI ? _fastapiBaseUrl : _springBootBaseUrl;
}
```

#### Step 3: Restart the Flutter App

```bash
# Stop the app (press 'q' in terminal or stop in IDE)
# Then run again:
flutter run
```

#### Step 4: Test

The app should now connect successfully!

---

### Solution 2: Configure macOS Firewall

If you want to keep using `10.0.2.2`, you need to configure the firewall.

#### Step 1: Check Firewall Status

```bash
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
```

#### Step 2: Allow Docker

```bash
# Add Docker to allowed applications
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /Applications/Docker.app/Contents/MacOS/Docker

# Allow incoming connections
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblock /Applications/Docker.app/Contents/MacOS/Docker
```

#### Step 3: Restart Docker

```bash
# Stop FastAPI
docker-compose -f api_fastapi/docker-compose.yml down

# Start FastAPI
docker-compose -f api_fastapi/docker-compose.yml up
```

#### Step 4: Test Connection

```bash
# From terminal
curl http://localhost:8000/api/plats

# From another terminal, simulate emulator (won't work if firewall blocks)
curl http://10.0.2.2:8000/api/plats
```

---

### Solution 3: Run FastAPI Locally (No Docker)

If you don't want to deal with Docker networking:

#### Step 1: Stop Docker

```bash
cd api_fastapi
docker-compose down
```

#### Step 2: Run FastAPI Locally

```bash
cd api_fastapi

# Create virtual environment (if not exists)
python3 -m venv venv

# Activate
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Initialize database
python init_db.py

# Run FastAPI
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

#### Step 3: Update Flutter Config

Edit: `mobile/lib/config/api_config.dart`

```dart
// For local FastAPI (no Docker)
static const String _fastapiBaseUrl = 'http://localhost:8000/api';
```

#### Step 4: Restart Flutter

```bash
flutter run
```

---

## Quick Fix Script

Here's a script to automatically find your IP and show you the configuration:

```bash
#!/bin/bash

echo "==================================="
echo "Flutter App Network Configuration"
echo "==================================="
echo ""

# Get Mac IP address
IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)

echo "Your Mac IP Address: $IP"
echo ""
echo "Update this in mobile/lib/config/api_config.dart:"
echo ""
echo "static const String _fastapiBaseUrl = 'http://$IP:8000/api';"
echo ""
echo "Then run: flutter run"
echo ""
```

Save this as `get_ip.sh` and run:
```bash
chmod +x get_ip.sh
./get_ip.sh
```

---

## Verification

### Test Backend Accessibility

```bash
# Test from host (should work)
curl http://localhost:8000/health
curl http://localhost:8000/api/plats

# Test with your IP (should work if firewall allows)
curl http://YOUR_IP:8000/health

# Test 10.0.2.2 (might not work due to firewall)
curl http://10.0.2.2:8000/health
```

### Check Docker

```bash
# View running containers
docker ps

# View logs
docker logs restaurant_api_fastapi

# Check port binding
netstat -an | grep 8000
```

---

## Common Issues

### Issue: "Connection refused"
**Cause**: Backend not running
**Fix**: Start FastAPI with `docker-compose up`

### Issue: "Operation not permitted"
**Cause**: Firewall blocking connection
**Fix**: Use Solution 1 (host IP) or Solution 2 (configure firewall)

### Issue: "No route to host"
**Cause**: Wrong IP address
**Fix**: Verify IP with `ifconfig`

### Issue: Works on localhost but not on IP
**Cause**: FastAPI not binding to all interfaces
**Fix**: Ensure FastAPI uses `--host 0.0.0.0`

---

## Why This Happens

The Android emulator creates a virtual network where:
- `10.0.2.2` = Host machine's loopback interface
- Emulator's network = `10.0.2.15`

When FastAPI runs in Docker:
1. Docker exposes port 8000 on `0.0.0.0:8000`
2. macOS maps this to `localhost:8000`
3. But `10.0.2.2` is a special emulator address
4. macOS firewall might block this special address

**Solution**: Use your actual network IP instead of the emulator's special address.

---

## Recommended: Solution 1

✅ **Easiest and most reliable**
✅ Works without firewall changes
✅ Works with Docker
✅ No security concerns

Just update the IP in `api_config.dart` and restart!
