import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Professional Dark Theme
  String _selectedCategory = '';

  ThemeMode get themeMode => _themeMode;
  String get selectedCategory => _selectedCategory;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
} 