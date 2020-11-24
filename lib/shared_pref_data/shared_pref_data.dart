import 'package:shared_preferences/shared_preferences.dart';

class _SharedPrefData {
  Future<void> storeStringData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String> getStringData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool> deleteData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}

// Global variables section
_SharedPrefData sharedPrefDataManager = _SharedPrefData();
