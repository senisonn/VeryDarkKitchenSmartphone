import 'package:shared_preferences/shared_preferences.dart';

class DebugService {
  static const String _debugKey = 'debug_enabled';

  /// Check if debug mode is enabled
  static Future<bool> isDebugEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_debugKey) ?? false;
  }

  /// Enable or disable debug mode
  static Future<void> setDebugEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_debugKey, enabled);
  }
}
