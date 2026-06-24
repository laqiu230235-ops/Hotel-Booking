import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  static const String _key = 'user_data';

  // In a real app, you would fetch these from a database/API
  static final List<User> _users = [
    User(
      id: '1',
      name: 'Demo User',
      email: 'demo@horizon.com',
      password: 'password123',
    ),
    User(
      id: '2',
      name: 'Alex Rivera',
      email: 'alex@horizon.com',
      password: 'secure123',
    ),
  ];

  User? _currentUser;
  User? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    try {
      final user = _users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      _currentUser = user;
      await _saveUser(user);
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception('Invalid email or password');
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    if (_users.any((u) => u.email == email)) {
      throw Exception('Email already registered');
    }

    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
    );

    _users.add(user);
    _currentUser = user;
    await _saveUser(user);
    notifyListeners();
    return true;
  }

  // --- UPDATED: Added method to update name ---
  Future<void> updateName(String newName) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(name: newName);
      await _saveUser(_currentUser!);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    notifyListeners();
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(user.toJson()));
  }

  // --- UPDATED: Added try-catch for data safety ---
  Future<bool> isLoggedIn() async {
    if (_currentUser != null) return true;

    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);

    if (data != null) {
      try {
        _currentUser = User.fromJson(jsonDecode(data));
        return true;
      } catch (e) {
        debugPrint("Error loading user: $e");
        await prefs.remove(_key); // Clear corrupted data
        return false;
      }
    }
    return false;
  }
}
