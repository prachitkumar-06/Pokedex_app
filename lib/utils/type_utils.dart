import 'package:flutter/material.dart';

class TypeUtils {
  static const Map<String, Color> _colors = {
    'normal': Color(0xFF8A8A8A),
    'fire': Color(0xFFE85D04),
    'water': Color(0xFF1976D2),
    'electric': Color(0xFFF2B705),
    'grass': Color(0xFF43A047),
    'ice': Color(0xFF26A69A),
    'fighting': Color(0xFFD84315),
    'poison': Color(0xFF8E44AD),
    'ground': Color(0xFFA66A3F),
    'flying': Color(0xFF5C8DDE),
    'psychic': Color(0xFFE91E63),
    'bug': Color(0xFF7CB342),
    'rock': Color(0xFF827717),
    'ghost': Color(0xFF5E35B1),
    'dragon': Color(0xFF3949AB),
    'dark': Color(0xFF37474F),
    'steel': Color(0xFF607D8B),
    'fairy': Color(0xFFD81B60),
  };

  static Color color(String type) {
    return _colors[type.toLowerCase()] ?? Colors.grey;
  }

  static String capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  static String formatStatName(String value) {
    return value
        .split('-')
        .map(capitalize)
        .join(' ');
  }
}
