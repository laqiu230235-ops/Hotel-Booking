import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveFavorites(List<String> hotelIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', hotelIds);
  }

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? [];
  }
}
