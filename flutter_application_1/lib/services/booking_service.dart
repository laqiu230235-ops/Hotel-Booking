import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';

class BookingService extends ChangeNotifier {
  static const String _historyKey = 'booking_history';
  List<List<CartItem>> _bookingHistory = [];

  List<List<CartItem>> get bookingHistory => _bookingHistory;

  BookingService() {
    _loadHistory();
  }

  // Method to save a booking
  Future<void> addBooking(List<CartItem> items) async {
    if (items.isEmpty) return;

    // Add new booking to the list
    _bookingHistory.add(List.from(items));

    // Save to disk
    await _saveHistory();
    notifyListeners();
  }

  // Clear history
  Future<void> clearHistory() async {
    _bookingHistory = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    notifyListeners();
  }

  // Save history to SharedPreferences
  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Converts List<List<CartItem>> to a JSON-compatible string
      final String encodedData = jsonEncode(
        _bookingHistory
            .map((order) => order.map((item) => item.toJson()).toList())
            .toList(),
      );
      await prefs.setString(_historyKey, encodedData);
    } catch (e) {
      debugPrint("Error saving booking history: $e");
    }
  }

  // Load history from SharedPreferences
  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString(_historyKey);

      if (data != null) {
        final List<dynamic> decoded = jsonDecode(data);
        _bookingHistory = decoded.map((order) {
          return (order as List<dynamic>)
              .map((itemJson) => CartItem.fromJson(itemJson))
              .toList();
        }).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading booking history: $e");
      // If corruption occurs, clear the corrupted data
      await _clearCorruptedData();
    }
  }

  Future<void> _clearCorruptedData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    _bookingHistory = [];
    notifyListeners();
  }
}
