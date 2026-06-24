import 'package:flutter/material.dart';
import '../models/hotel.dart';

class HotelService extends ChangeNotifier {
  List<Hotel> _hotels = [];
  final List<int> _favorites = [];

  HotelService() {
    _hotels = Hotel.getHotels();
  }

  List<Hotel> get allHotels => _hotels;
  List<int> get favorites => _favorites;

  Hotel? getHotelById(int id) {
    try {
      return _hotels.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Hotel> getFavoriteHotels() {
    return _hotels.where((h) => _favorites.contains(h.id)).toList();
  }

  void toggleFavorite(int hotelId) {
    if (_favorites.contains(hotelId)) {
      _favorites.remove(hotelId);
    } else {
      _favorites.add(hotelId);
    }
    notifyListeners();
  }

  bool isFavorite(int hotelId) {
    return _favorites.contains(hotelId);
  }

  List<Hotel> searchHotels(String query) {
    return _hotels.where((h) =>
      h.name.toLowerCase().contains(query.toLowerCase()) ||
      h.location.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}