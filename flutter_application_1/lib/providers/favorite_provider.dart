import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/hotel.dart';

class FavoriteProvider with ChangeNotifier {
  List<Hotel> _favoriteHotels = [];
  List<String> _favoriteIds = []; // Local storage tracks IDs

  List<Hotel> get favoriteHotels => _favoriteHotels;

  // Constructor calls initialization
  FavoriteProvider() {
    _loadFavorites();
  }

  bool isFavorite(int hotelId) {
    return _favoriteIds.contains(hotelId.toString());
  }

  Future<void> toggleFavorite(Hotel hotel) async {
    final String idStr = hotel.id.toString();

    if (_favoriteIds.contains(idStr)) {
      _favoriteIds.remove(idStr);
      _favoriteHotels.removeWhere((item) => item.id == hotel.id);
    } else {
      _favoriteIds.add(idStr);
      _favoriteHotels.add(hotel);
    }

    // Persist to disk
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favoriteIds);

    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteIds = prefs.getStringList('favorites') ?? [];

    // Note: In a real app, you would filter your full hotel list
    // to populate _favoriteHotels based on the loaded _favoriteIds.
    notifyListeners();
  }
}
