import 'package:shared_preferences/shared_preferences.dart';

class DefaultSharedPreferences {
  /// KEYS
  static const String _isFirstUse = 'isFirstUse';
  static const String _isLogged = 'isLogged';
  static const String _email = 'email';
  static const String _password = 'password';
  static const String _provider = 'provider';
  static const String _userData = 'data';
  static const String _lang = 'lang';

  /// Setters
  static Future<bool> setIsFirstUse(bool isFirstUse) async {
    final prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setBool(_isFirstUse, isFirstUse);
    return result;
  }

  static Future<bool> setIsLogged(bool isLogged) async {
    final prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setBool(_isLogged, isLogged);
    return result;
  }

  static Future<bool> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setString(_email, email);
    return result;
  }

  static Future<bool> setPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setString(_password, password);
    return result;
  }

  static Future<bool> setLoginProvider(String provider) async {
    final prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setString(_provider, provider);
    return result;
  }

  static Future<bool> setUserData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setString(_userData, data);
    return result;
  }

  static Future<bool> setLang(String data) async {
    final prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setString(_lang, data);
    return result;
  }

  /// Getters
  static Future<bool?> getIsLogged() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isLogged = prefs.getBool(_isLogged);
    return isLogged;
  }

  static Future<bool?> getIsFirstUse() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isLogged = prefs.getBool(_isFirstUse);
    return isLogged;
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString(_email);
    return email;
  }

  static Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    String? password = prefs.getString(_password);
    return password;
  }

  static Future<String?> getProvider() async {
    final prefs = await SharedPreferences.getInstance();
    String? provider = prefs.getString(_provider);
    return provider;
  }

  static Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? provider = prefs.getString(_userData);
    return provider;
  }

  static Future<String?> getLang() async {
    final prefs = await SharedPreferences.getInstance();
    String? provider = prefs.getString(_lang);
    return provider;
  }
}
