import 'package:shared_preferences/shared_preferences.dart';

class BaseSharedPrefsSingleton {
  static SharedPreferences? _prefs;

  /// Initialise the [BaseSharedPrefsSingleton] in the main function to the
  /// create the single instance of the same that will be used through out the
  /// application.
  static Future<SharedPreferences?> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  /// To save a value in the local storage using shared prefs.
  static Future<bool>? setValue(String key, dynamic value) {
    switch (value.runtimeType) {
      case int:
        return _prefs?.setInt(key, value);
      case double:
        return _prefs?.setDouble(key, value);
      case bool:
        return _prefs?.setBool(key, value);
      case String:
        return _prefs?.setString(key, value);
      case List<String>:
        return _prefs?.setStringList(key, value);
    }
    return null;
  }

  /// To retrieve values from the shared prefs.
  static bool? getBool(String key) => _prefs?.getBool(key);

  static int? getInt(String key) => _prefs?.getInt(key);

  static String? getString(String key) => _prefs?.getString(key);

  static double? getDouble(String key) => _prefs?.getDouble(key);

  static List<String>? getStringList(String key) => _prefs?.getStringList(key);

  /// Delete operations.
  static Future<bool?> delete(String key) async => await _prefs?.remove(key);

  static Future<bool?> clear(String key) async => await _prefs?.clear();

  /// Check whether a key exists already in the shared prefs.
  static bool? checkKey(String key) => _prefs?.containsKey(key);
}
