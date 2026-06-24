import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/hotel.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Add an item to the cart
  void addItem(Hotel hotel, [int nights = 1]) {
    final existingIndex = _items.indexWhere(
      (item) => item.hotel.id == hotel.id,
    );

    if (existingIndex != -1) {
      _items[existingIndex].nights += nights;
    } else {
      _items.add(CartItem(hotel: hotel, nights: nights));
    }
    notifyListeners();
  }

  // Toggle Favorite (Add/Remove from cart)
  void toggleFavorite(Hotel hotel) {
    final existingIndex = _items.indexWhere(
      (item) => item.hotel.id == hotel.id,
    );

    if (existingIndex != -1) {
      // If it exists, remove it
      _items.removeAt(existingIndex);
    } else {
      // If it doesn't exist, add it
      _items.add(CartItem(hotel: hotel, nights: 1));
    }
    notifyListeners();
  }

  // Check if an item is already in the cart (for the heart icon state)
  bool isFavorite(Hotel hotel) {
    return _items.any((item) => item.hotel.id == hotel.id);
  }

  // Remove an item
  void removeItem(int hotelId) {
    _items.removeWhere((item) => item.hotel.id == hotelId);
    notifyListeners();
  }

  // Update quantity (nights)
  void updateQuantity(int hotelId, int nights) {
    final index = _items.indexWhere((item) => item.hotel.id == hotelId);
    if (index != -1) {
      if (nights < 1) nights = 1;
      _items[index].nights = nights;
      notifyListeners();
    }
  }

  // Get total price
  int getTotal() {
    return _items.fold(0, (total, item) => total + item.subtotal);
  }

  // Get total number of nights booked
  int getItemCount() {
    return _items.fold(0, (count, item) => count + item.nights);
  }

  // Clear the cart - Essential for the booking flow
  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool get isEmpty => _items.isEmpty;

  // Helper to convert cart to JSON for storage/API use
  String toJson() {
    return jsonEncode(_items.map((item) => item.toJson()).toList());
  }
}
