import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';


class UserPrefs {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<String?> _uid() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await _prefs;
    final uid = await _uid();
    if (uid != null) {
      await prefs.setString('${key}_$uid', value);
    }
  }

  static Future<String?> getString(String key) async {
    final prefs = await _prefs;
    final uid = await _uid();
    if (uid != null) {
      return prefs.getString('${key}_$uid');
    }
    return null;
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs;
    final uid = await _uid();
    if (uid != null) {
      await prefs.setBool('${key}_$uid', value);
    }
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    final uid = await _uid();
    if (uid != null) {
      return prefs.getBool('${key}_$uid');
    }
    return null;
  }

  static Future<void> setInt(String key, int value) async {
    final prefs = await _prefs;
    final uid = await _uid();
    if (uid != null) {
      await prefs.setInt('${key}_$uid', value);
    }
  }

  static Future<int?> getInt(String key) async {
    final prefs = await _prefs;
    final uid = await _uid();
    if (uid != null) {
      return prefs.getInt('${key}_$uid');
    }
    return null;
  }

  static Future<void> setDouble(String key, double value) async {
    final prefs = await _prefs;
    final uid = await _uid();
    if (uid != null) {
      await prefs.setDouble('${key}_$uid', value);
    }
  }

  static Future<double?> getDouble(String key) async {
    final prefs = await _prefs;
    final uid = await _uid();
    if (uid != null) {
      return prefs.getDouble('${key}_$uid');
    }
    return null;
  }

  static Future<void> setStringList(String key, List<String> value) async {
    final prefs = await _prefs;
    final uid = await _uid();
    if (uid != null) {
      await prefs.setStringList('${key}_$uid', value);
    }
  }

  static Future<List<String>?> getStringList(String key) async {
    final prefs = await _prefs;
    final uid = await _uid();
    if (uid != null) {
      return prefs.getStringList('${key}_$uid');
    }
    return null;
  }

  static Future<void> remove(String key) async {
    final prefs = await _prefs;
    final uid = await _uid();
    if (uid != null) {
      await prefs.remove('${key}_$uid');
    }
  }

  static Future<void> clearAllUserData() async {
    final prefs = await _prefs;
    final uid = await _uid();
    if (uid != null) {
      final keys = prefs.getKeys().where((k) => k.endsWith('_$uid')).toList();
      for (var key in keys) {
        await prefs.remove(key);
      }
    }
  }

}
