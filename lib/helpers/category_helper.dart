// lib/helpers/category_helper.dart
import 'package:flutter/material.dart';

class CategoryHelper {
  static IconData getIcon(String category) {
    final catLower = category.toLowerCase();

    if (catLower.contains('coffee') || catLower.contains('tea')) {
      return Icons.coffee;
    } else if (catLower.contains('dessert') || catLower.contains('sweet')) {
      return Icons.cake;
    } else if (catLower.contains('chicken') || catLower.contains('beef')) {
      return Icons.lunch_dining;
    } else if (catLower.contains('vegetable') || catLower.contains('vegan')) {
      return Icons.eco;
    } else if (catLower.contains('seafood')) {
      return Icons.set_meal;
    }

    return Icons.restaurant;
  }

  static Color getColor(String category) {
    final catLower = category.toLowerCase();

    if (catLower.contains('coffee') || catLower.contains('tea')) {
      return Colors.brown;
    } else if (catLower.contains('dessert') || catLower.contains('sweet')) {
      return Colors.pink;
    } else if (catLower.contains('chicken') || catLower.contains('beef')) {
      return Colors.red;
    } else if (catLower.contains('vegetable') || catLower.contains('vegan')) {
      return Colors.green;
    } else if (catLower.contains('seafood')) {
      return Colors.blue;
    }

    return Colors.orange;
  }
}