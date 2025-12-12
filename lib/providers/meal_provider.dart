// lib/providers/meal_provider.dart
import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';

class MealProvider extends ChangeNotifier {
  // Categories
  List<String> _categories = [];
  bool _isLoadingCategories = false;
  String? _categoriesError;

  // Random Meals
  List<Meal> _randomMeals = [];
  bool _isLoadingRandomMeals = false;
  String? _randomMealsError;

  // Selected Category
  String _selectedCategory = 'All';

  // Getters
  List<String> get categories => _categories;
  bool get isLoadingCategories => _isLoadingCategories;
  String? get categoriesError => _categoriesError;

  List<Meal> get randomMeals => _randomMeals;
  bool get isLoadingRandomMeals => _isLoadingRandomMeals;
  String? get randomMealsError => _randomMealsError;

  String get selectedCategory => _selectedCategory;

  // Load Categories
  Future<void> loadCategories() async {
    _isLoadingCategories = true;
    _categoriesError = null;
    notifyListeners();

    try {
      _categories = await ApiService.getCategories();
      _categoriesError = null;
    } catch (e) {
      _categoriesError = 'Failed to load categories';
      _categories = [];
    }

    _isLoadingCategories = false;
    notifyListeners();
  }

  // Load Random Meals
  Future<void> loadRandomMeals({int count = 6}) async {
    _isLoadingRandomMeals = true;
    _randomMealsError = null;
    notifyListeners();

    try {
      _randomMeals = await ApiService.getRandomMeals(count: count);
      _randomMealsError = null;
    } catch (e) {
      _randomMealsError = 'Failed to load meals';
      _randomMeals = [];
    }

    _isLoadingRandomMeals = false;
    notifyListeners();
  }

  // Set Selected Category
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Refresh All Data
  Future<void> refreshData() async {
    await Future.wait([
      loadCategories(),
      loadRandomMeals(count: 6),
    ]);
  }

  // Get Meal Detail
  Future<Meal?> getMealDetail(String id) async {
    try {
      return await ApiService.getMealDetail(id);
    } catch (e) {
      return null;
    }
  }
}