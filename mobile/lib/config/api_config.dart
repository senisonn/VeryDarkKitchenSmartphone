class ApiConfig {
  // API Configuration
  // Change this to switch between backends or environments

  // Host IP Address - Use this for Android Emulator on macOS
  // If you get connection errors, update this to your current IP:
  // Run: ifconfig | grep "inet " | grep -v 127.0.0.1
  static const String _hostIP = '192.168.1.143';

  // FastAPI Backend (Port 8000)
  static const String _fastapiBaseUrl = 'http://$_hostIP:8000/api';

  // Spring Boot Backend (Port 8080)
  static const String _springBootBaseUrl = 'http://$_hostIP:8080/api';

  // Active backend - Change this to switch between backends
  static const bool useFastAPI = false;

  // Get the active base URL
  static String get baseUrl => useFastAPI ? _fastapiBaseUrl : _springBootBaseUrl;

  // Get the active backend name (for debugging)
  static String get backendName => useFastAPI ? 'FastAPI' : 'Spring Boot';

  // Get the active port
  static int get port => useFastAPI ? 8000 : 8080;

  // For physical devices, use your computer's IP address
  // Example: static const String _physicalDeviceIP = '192.168.1.134';
  static const String? _physicalDeviceIP = null; // Set this if using physical device

  // Get URL for physical device
  static String get physicalDeviceUrl {
    if (_physicalDeviceIP == null) {
      throw Exception('Physical device IP not configured. Set _physicalDeviceIP in api_config.dart');
    }
    return 'http://$_physicalDeviceIP:$port/api';
  }
}
