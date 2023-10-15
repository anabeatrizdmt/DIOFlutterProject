import 'package:dioproject/shared/utils/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorageService {
  Future<void> _setString(STORAGE_KEYS key, String value) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString(key.toString(), value);
  }

  Future<String> _getString(STORAGE_KEYS key) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getString(key.toString()) ?? 'Not set';
  }

  Future<void> setUserName(String name) async {
    await _setString(STORAGE_KEYS.NAME_KEY, name);
  }

  Future<String> getUserName() async {
    return _getString(STORAGE_KEYS.NAME_KEY);
  }

  Future<void> setUserEmail(String email) async {
    await _setString(STORAGE_KEYS.EMAIL_KEY, email);
  }

  Future<String> getUserEmail() async {
    return _getString(STORAGE_KEYS.EMAIL_KEY);
  }
}
