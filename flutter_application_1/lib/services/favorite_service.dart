import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class FavoriteService extends ChangeNotifier {
  static const String _key = 'favorite_hotels';
  List<String> _favoriteIds = [];

  List<String> get favoriteIds => _favoriteIds;

  FavoriteService() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteIds = prefs.getStringList(_key) ?? [];
    notifyListeners();
  }

  Future<void> toggleFavorite(String hotelId) async {
    final prefs = await SharedPreferences.getInstance();

    if (_favoriteIds.contains(hotelId)) {
      _favoriteIds.remove(hotelId);
    } else {
      _favoriteIds.add(hotelId);
    }

    await prefs.setStringList(_key, _favoriteIds);
    notifyListeners();
  }
}
