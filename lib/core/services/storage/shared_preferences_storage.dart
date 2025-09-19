import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage {
  SharedPreferencesStorage({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  Future<void> writeString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? readString(String key) => _prefs.getString(key);

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> writeJson(String key, Object value) async {
    await writeString(key, jsonEncode(value));
  }

  Map<String, dynamic>? readJson(String key) {
    final raw = readString(key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  List<dynamic>? readJsonList(String key) {
    final raw = readString(key);
    if (raw == null) return null;
    return jsonDecode(raw) as List<dynamic>;
  }
}
