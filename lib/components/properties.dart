import 'package:flutter/material.dart';

class Properties {

  static const Color primaryColor = Color(0xFF0D47A1); // Blue
  static const Color secondaryColor = Color(0xFF00C853); // Green
  static const Color accentColor = Color(0xFFFF5252); // Red
  static const Color backgroundColor = Color(0xFFF1F8E9); // Light Greenish
  static const Color textColor = Color(0xFF212121); // Dark Grey

  // Method to get a color by name
  static Color getColor(String colorName) {
    switch (colorName) {
      case 'primary':
        return primaryColor;
      case 'secondary':
        return secondaryColor;
      case 'accent':
        return accentColor;
      case 'background':
        return backgroundColor;
      case 'text':
        return textColor;
      default:
        return Colors.black; // Default color if no match found
    }
  }

}