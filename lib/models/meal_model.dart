// lib/models/meal_model.dart

class MealParseException implements Exception {
  final String message;
  final dynamic originalError;

  MealParseException(this.message, {this.originalError});

  @override
  String toString() => 'MealParseException: $message';
}

class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final String? category;
  final String? area;
  final String? instructions;
  final Map<String, String>? ingredients; // ingredient -> measure

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.category,
    this.area,
    this.instructions,
    this.ingredients,
  });

  // Validate required fields
  static void _validateRequiredFields(
      Map<String, dynamic> json,
      List<String> requiredFields,
      ) {
    for (final field in requiredFields) {
      if (json[field] == null ||
          (json[field] is String && (json[field] as String).trim().isEmpty)) {
        throw MealParseException(
          'Missing required field: $field',
          originalError: 'Field "$field" is null or empty',
        );
      }
    }
  }

  // Safe string extraction
  static String _extractString(
      Map<String, dynamic> json,
      String key, {
        String defaultValue = '',
      }) {
    try {
      final value = json[key];
      if (value == null) return defaultValue;
      return value.toString().trim();
    } catch (e) {
      return defaultValue;
    }
  }

  // Created from filter.php / results that include idMeal, strMeal, strMealThumb
  factory Meal.fromFilterJson(Map<String, dynamic> json) {
    try {
      // Validate required fields
      _validateRequiredFields(json, ['idMeal', 'strMeal', 'strMealThumb']);

      final id = _extractString(json, 'idMeal');
      final name = _extractString(json, 'strMeal');
      final thumbnail = _extractString(json, 'strMealThumb');

      // Additional validation for empty strings
      if (id.isEmpty || name.isEmpty || thumbnail.isEmpty) {
        throw MealParseException(
          'One or more required fields are empty',
        );
      }

      // Validate thumbnail URL format
      if (!_isValidUrl(thumbnail)) {
        throw MealParseException(
          'Invalid thumbnail URL format',
          originalError: thumbnail,
        );
      }

      return Meal(
        id: id,
        name: name,
        thumbnail: thumbnail,
        category: null,
        area: null,
        instructions: null,
        ingredients: null,
      );
    } catch (e) {
      if (e is MealParseException) {
        rethrow;
      }
      throw MealParseException(
        'Failed to parse meal from filter data',
        originalError: e,
      );
    }
  }

  // Created from lookup.php (detailed meal)
  factory Meal.fromDetailJson(Map<String, dynamic> json) {
    try {
      // Validate required fields
      _validateRequiredFields(json, ['idMeal', 'strMeal', 'strMealThumb']);

      final id = _extractString(json, 'idMeal');
      final name = _extractString(json, 'strMeal');
      final thumbnail = _extractString(json, 'strMealThumb');

      // Additional validation
      if (id.isEmpty || name.isEmpty || thumbnail.isEmpty) {
        throw MealParseException(
          'One or more required fields are empty',
        );
      }

      // Validate thumbnail URL
      if (!_isValidUrl(thumbnail)) {
        throw MealParseException(
          'Invalid thumbnail URL format',
          originalError: thumbnail,
        );
      }

      // Extract optional fields
      final category = _extractString(json, 'strCategory');
      final area = _extractString(json, 'strArea');
      final instructions = _extractString(json, 'strInstructions');

      // Gather ingredients + measures (up to 20 fields in TheMealDB)
      final Map<String, String> ingr = {};

      try {
        for (int i = 1; i <= 20; i++) {
          final ingKey = 'strIngredient$i';
          final measureKey = 'strMeasure$i';

          final ing = _extractString(json, ingKey);
          final measure = _extractString(json, measureKey);

          if (ing.isNotEmpty) {
            // Store with measure or empty string if no measure
            ingr[ing] = measure.isNotEmpty ? measure : '';
          }
        }
      } catch (e) {
        // If ingredient parsing fails, continue without ingredients
        // but log the error for debugging
        print('Warning: Failed to parse ingredients - $e');
      }

      return Meal(
        id: id,
        name: name,
        thumbnail: thumbnail,
        category: category.isNotEmpty ? category : null,
        area: area.isNotEmpty ? area : null,
        instructions: instructions.isNotEmpty ? instructions : null,
        ingredients: ingr.isNotEmpty ? ingr : null,
      );
    } catch (e) {
      if (e is MealParseException) {
        rethrow;
      }
      throw MealParseException(
        'Failed to parse detailed meal data',
        originalError: e,
      );
    }
  }

  // Validate URL format
  static bool _isValidUrl(String url) {
    if (url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);
      return uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  // Helper method to get formatted ingredients list
  List<String> getFormattedIngredients() {
    if (ingredients == null || ingredients!.isEmpty) {
      return [];
    }

    return ingredients!.entries.map((entry) {
      final ingredient = entry.key;
      final measure = entry.value;

      if (measure.isNotEmpty) {
        return '$measure $ingredient';
      }
      return ingredient;
    }).toList();
  }

  // Helper method to check if meal has full details
  bool get hasFullDetails {
    return category != null &&
        area != null &&
        instructions != null &&
        ingredients != null;
  }

  // Copy with method for updating meal data
  Meal copyWith({
    String? id,
    String? name,
    String? thumbnail,
    String? category,
    String? area,
    String? instructions,
    Map<String, String>? ingredients,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      category: category ?? this.category,
      area: area ?? this.area,
      instructions: instructions ?? this.instructions,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  // Convert to JSON (useful for caching)
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': thumbnail,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
    };

    // Add ingredients and measures
    if (ingredients != null) {
      int index = 1;
      ingredients!.forEach((ingredient, measure) {
        result['strIngredient$index'] = ingredient;
        result['strMeasure$index'] = measure;
        index++;
      });
    }

    return result;
  }

  @override
  String toString() {
    return 'Meal(id: $id, name: $name, category: $category, area: $area, '
        'hasIngredients: ${ingredients != null}, hasInstructions: ${instructions != null})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Meal && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}