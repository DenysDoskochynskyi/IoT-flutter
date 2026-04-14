import 'package:my_project/data/local/key_value_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SharedPrefsStorage implements KeyValueStorage {
  const SharedPrefsStorage();

  Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  @override
  Future<bool?> readBool(String key) async {
    final prefs = await _prefs();
    return prefs.getBool(key);
  }

  @override
  Future<String?> readString(String key) async {
    final prefs = await _prefs();
    return prefs.getString(key);
  }

  @override
  Future<void> writeBool(String key, bool value) async {
    final prefs = await _prefs();
    await prefs.setBool(key, value);
  }

  @override
  Future<void> writeString(String key, String value) async {
    final prefs = await _prefs();
    await prefs.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    final prefs = await _prefs();
    await prefs.remove(key);
  }
}
