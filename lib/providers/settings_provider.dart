import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  String _readerTheme = 'sepia'; // claro, escuro, sepia, amoled
  String _fontFamily = 'Lora'; // Lora, Merriweather, Inter
  double _fontSize = 18.0;
  bool _isPageMode = true; // true = Passar Página (Horizontal), false = Rolagem (Vertical)

  String get readerTheme => _readerTheme;
  String get fontFamily => _fontFamily;
  double get fontSize => _fontSize;
  bool get isPageMode => _isPageMode;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _readerTheme = prefs.getString('reader_theme') ?? 'sepia';
    _fontFamily = prefs.getString('font_family') ?? 'Lora';
    _fontSize = prefs.getDouble('font_size') ?? 18.0;
    _isPageMode = prefs.getBool('page_mode') ?? true;
    notifyListeners();
  }

  Future<void> setTheme(String theme) async {
    _readerTheme = theme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reader_theme', theme);
  }

  Future<void> setFont(String font) async {
    _fontFamily = font;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('font_family', font);
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('font_size', size);
  }

  Future<void> setPageMode(bool isPage) async {
    _isPageMode = isPage;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('page_mode', isPage);
  }
}
