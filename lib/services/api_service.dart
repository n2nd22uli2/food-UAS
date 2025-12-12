// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/meal_model.dart';
import '../helpers/debug_error_helper.dart'; // IMPORT DEBUG HELPER

// Enum untuk tipe error
enum ApiErrorType {
  network,
  timeout,
  notFound,
  server,
  parse,
  unknown,
}

// Custom Exception untuk API
class ApiException implements Exception {
  final ApiErrorType type;
  final String message;
  final dynamic originalError;

  ApiException({
    required this.type,
    required this.message,
    this.originalError,
  });

  @override
  String toString() => message;

  // User-friendly message
  String getUserMessage() {
    switch (type) {
      case ApiErrorType.timeout:
        return 'Connection timeout. Please check your internet and try again.';
      case ApiErrorType.network:
        return 'Unable to connect to the server. Please check your internet.';
      case ApiErrorType.server:
        return 'Server is busy. Please try again later.';
      case ApiErrorType.notFound:
        return 'Meal not found.';
      case ApiErrorType.parse:
        return 'Something went wrong. Please try again.';
      case ApiErrorType.unknown:
        return 'An error occurred. Please try again.';
    }
  }
}

class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1/';
  static const Duration _timeout = Duration(seconds: 15);
  static const int _maxRetries = 3;

  // 🎯 CHECK FOR SIMULATED ERRORS
  static void _checkSimulatedError() {
    if (DebugErrorHelper.shouldThrowError()) {
      DebugErrorHelper.throwSimulatedError();
    }
  }

  // Helper untuk retry logic
  static Future<T> _executeWithRetry<T>(
      Future<T> Function() operation, {
        int retries = 0,
      }) async {
    try {
      // 🎯 SIMULATE ERROR DI SINI
      _checkSimulatedError();

      return await operation();
    } on SocketException {
      // Network error - don't retry
      throw ApiException(
        type: ApiErrorType.network,
        message: 'No internet connection',
      );
    } on TimeoutException {
      // Timeout - retry
      if (retries < _maxRetries) {
        await Future.delayed(Duration(seconds: 1 << retries));
        return _executeWithRetry(operation, retries: retries + 1);
      }
      throw ApiException(
        type: ApiErrorType.timeout,
        message: 'Connection timeout after $retries retries',
      );
    } on ApiException catch (e) {
      // API error - selective retry
      if (retries < _maxRetries &&
          e.type != ApiErrorType.notFound &&
          e.type != ApiErrorType.parse) {
        await Future.delayed(Duration(seconds: 1 << retries));
        return _executeWithRetry(operation, retries: retries + 1);
      }
      rethrow;
    } catch (e) {
      // Unknown error
      throw ApiException(
        type: ApiErrorType.unknown,
        message: 'Unexpected error occurred',
        originalError: e,
      );
    }
  }

  // Get list of categories
  static Future<List<String>> getCategories() async {
    return _executeWithRetry(() async {
      try {
        final url = Uri.parse('${_baseUrl}categories.php');
        final response = await http.get(url).timeout(
          _timeout,
          onTimeout: () => throw TimeoutException('Categories request timeout'),
        );

        return _handleResponse(response, (json) {
          final List categories = json['categories'] ?? [];
          return categories
              .map<String>((c) => c['strCategory'] as String)
              .toList();
        });
      } on SocketException {
        rethrow;
      } on TimeoutException {
        rethrow;
      } on ApiException {
        rethrow;
      } catch (e) {
        throw ApiException(
          type: ApiErrorType.unknown,
          message: 'Failed to load categories',
          originalError: e,
        );
      }
    });
  }

  // Get meals filtered by category
  static Future<List<Meal>> getMealsByCategory(String category) async {
    if (category.trim().isEmpty) {
      throw ApiException(
        type: ApiErrorType.unknown,
        message: 'Category cannot be empty',
      );
    }

    return _executeWithRetry(() async {
      try {
        final url = Uri.parse(
          '${_baseUrl}filter.php?c=${Uri.encodeComponent(category)}',
        );
        final response = await http.get(url).timeout(
          _timeout,
          onTimeout: () => throw TimeoutException('Meals by category timeout'),
        );

        return _handleResponse(response, (json) {
          final List? meals = json['meals'];
          if (meals == null || meals.isEmpty) {
            return [];
          }
          return meals.map<Meal>((m) => Meal.fromFilterJson(m)).toList();
        });
      } on SocketException {
        rethrow;
      } on TimeoutException {
        rethrow;
      } on ApiException {
        rethrow;
      } catch (e) {
        throw ApiException(
          type: ApiErrorType.unknown,
          message: 'Failed to load meals for category $category',
          originalError: e,
        );
      }
    });
  }

  // Search meals by name
  static Future<List<Meal>> searchMeals(String name) async {
    if (name.trim().isEmpty) {
      throw ApiException(
        type: ApiErrorType.unknown,
        message: 'Search query cannot be empty',
      );
    }

    return _executeWithRetry(() async {
      try {
        final url = Uri.parse(
          '${_baseUrl}search.php?s=${Uri.encodeComponent(name)}',
        );
        final response = await http.get(url).timeout(
          _timeout,
          onTimeout: () => throw TimeoutException('Search request timeout'),
        );

        return _handleResponse(response, (json) {
          final List? meals = json['meals'];
          if (meals == null) {
            throw ApiException(
              type: ApiErrorType.notFound,
              message: 'No meals found for "$name"',
            );
          }
          return meals.map<Meal>((m) => Meal.fromDetailJson(m)).toList();
        });
      } on SocketException {
        rethrow;
      } on TimeoutException {
        rethrow;
      } on ApiException {
        rethrow;
      } catch (e) {
        throw ApiException(
          type: ApiErrorType.unknown,
          message: 'Failed to search meals',
          originalError: e,
        );
      }
    });
  }

  // Get meal detail by id
  static Future<Meal?> getMealDetail(String id) async {
    if (id.trim().isEmpty) {
      throw ApiException(
        type: ApiErrorType.unknown,
        message: 'Meal ID cannot be empty',
      );
    }

    return _executeWithRetry(() async {
      try {
        final url = Uri.parse(
          '${_baseUrl}lookup.php?i=${Uri.encodeComponent(id)}',
        );
        final response = await http.get(url).timeout(
          _timeout,
          onTimeout: () => throw TimeoutException('Meal detail timeout'),
        );

        return _handleResponse(response, (json) {
          final List? meals = json['meals'];
          if (meals == null || meals.isEmpty) {
            throw ApiException(
              type: ApiErrorType.notFound,
              message: 'Meal not found',
            );
          }
          return Meal.fromDetailJson(meals[0]);
        });
      } on SocketException {
        rethrow;
      } on TimeoutException {
        rethrow;
      } on ApiException {
        rethrow;
      } catch (e) {
        throw ApiException(
          type: ApiErrorType.unknown,
          message: 'Failed to load meal detail',
          originalError: e,
        );
      }
    });
  }

  // Get random meals
  static Future<List<Meal>> getRandomMeals({int count = 6}) async {
    if (count <= 0) {
      throw ApiException(
        type: ApiErrorType.unknown,
        message: 'Count must be greater than 0',
      );
    }

    return _executeWithRetry(() async {
      try {
        final List<Meal> meals = [];
        final List<Future<Meal?>> futures = [];

        // Parallel requests untuk performa lebih baik
        for (int i = 0; i < count; i++) {
          futures.add(_fetchSingleRandomMeal());
        }

        final results = await Future.wait(futures);

        // Filter out nulls
        for (var meal in results) {
          if (meal != null) {
            meals.add(meal);
          }
        }

        if (meals.isEmpty) {
          throw ApiException(
            type: ApiErrorType.unknown,
            message: 'Failed to load any random meals',
          );
        }

        return meals;
      } on SocketException {
        rethrow;
      } on TimeoutException {
        rethrow;
      } on ApiException {
        rethrow;
      } catch (e) {
        throw ApiException(
          type: ApiErrorType.unknown,
          message: 'Failed to load random meals',
          originalError: e,
        );
      }
    });
  }

  // Helper untuk fetch single random meal
  static Future<Meal?> _fetchSingleRandomMeal() async {
    try {
      final url = Uri.parse('${_baseUrl}random.php');
      final response = await http.get(url).timeout(
        _timeout,
        onTimeout: () => throw TimeoutException('Random meal timeout'),
      );

      return _handleResponse(response, (json) {
        final List? mealsList = json['meals'];
        if (mealsList != null && mealsList.isNotEmpty) {
          return Meal.fromDetailJson(mealsList[0]);
        }
        return null;
      });
    } catch (e) {
      // Return null instead of throwing for individual failures
      return null;
    }
  }

  // Helper untuk handle HTTP response
  static T _handleResponse<T>(
      http.Response response,
      T Function(Map<String, dynamic>) parser,
      ) {
    if (response.statusCode == 200) {
      try {
        final jsonBody = _parseJson(response.body);
        return parser(jsonBody);
      } on FormatException {
        throw ApiException(
          type: ApiErrorType.parse,
          message: 'Invalid response format',
        );
      }
    } else if (response.statusCode == 404) {
      throw ApiException(
        type: ApiErrorType.notFound,
        message: 'Resource not found',
      );
    } else if (response.statusCode >= 500) {
      throw ApiException(
        type: ApiErrorType.server,
        message: 'Server error (${response.statusCode})',
      );
    } else {
      throw ApiException(
        type: ApiErrorType.unknown,
        message: 'HTTP Error: ${response.statusCode}',
      );
    }
  }

  // Helper untuk parse JSON dengan error handling
  static Map<String, dynamic> _parseJson(String body) {
    try {
      final decoded = json.decode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      throw ApiException(
        type: ApiErrorType.parse,
        message: 'Invalid JSON structure',
      );
    } catch (e) {
      throw ApiException(
        type: ApiErrorType.parse,
        message: 'Failed to parse response',
        originalError: e,
      );
    }
  }
}