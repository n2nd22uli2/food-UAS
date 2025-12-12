// lib/cart_service.dart
import '../models/meal_model.dart';
import 'package:flutter/foundation.dart';

class CartService extends ChangeNotifier {
  CartService._privateConstructor();
  static final CartService instance = CartService._privateConstructor();

  final List<Meal> _items = [];

  List<Meal> get items => List.unmodifiable(_items);

  void addToCart(Meal meal) {
    _items.add(meal);
    notifyListeners();
  }

  void removeFromCart(Meal meal) {
    _items.remove(meal);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int get count => _items.length;
}
