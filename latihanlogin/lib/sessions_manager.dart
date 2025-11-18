import 'package:shared_preferences/shared_preferences.dart';

class SessionsManager {
  static const String keyUsername = 'username';
  static const String keyIsLoggedIn = 'is_logged_in';

  static Future<void> saveSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUsername, username);
    await prefs.setBool(keyIsLoggedIn, true);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUsername);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLoggedIn) ?? false;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
