// lib/helpers/debug_error_helper.dart
import '../services/api_service.dart';

/// Helper untuk simulate berbagai error saat development/testing
/// JANGAN LUPA DISABLE DI PRODUCTION!
class DebugErrorHelper {
  // Flag untuk enable/disable error simulation
  static bool enableErrorSimulation = true; // SET FALSE DI PRODUCTION!

  // Tipe error yang akan disimulate
  static ErrorSimulationType currentError = ErrorSimulationType.none;

  // Counter untuk simulate error setelah N kali success
  static int _callCount = 0;
  static int errorAfterCalls = 0; // 0 = immediate error

  /// Reset counter
  static void reset() {
    _callCount = 0;
  }

  /// Check apakah harus throw error
  static bool shouldThrowError() {
    if (!enableErrorSimulation) return false;
    if (currentError == ErrorSimulationType.none) return false;

    _callCount++;

    if (errorAfterCalls > 0 && _callCount <= errorAfterCalls) {
      return false;
    }

    return true;
  }

  /// Throw error sesuai tipe yang dipilih
  static void throwSimulatedError() {
    switch (currentError) {
      case ErrorSimulationType.network:
        throw ApiException(
          type: ApiErrorType.network,
          message: 'Simulated: No internet connection',
        );

      case ErrorSimulationType.timeout:
        throw ApiException(
          type: ApiErrorType.timeout,
          message: 'Simulated: Connection timeout',
        );

      case ErrorSimulationType.server:
        throw ApiException(
          type: ApiErrorType.server,
          message: 'Simulated: Server error (500)',
        );

      case ErrorSimulationType.notFound:
        throw ApiException(
          type: ApiErrorType.notFound,
          message: 'Simulated: Resource not found',
        );

      case ErrorSimulationType.parse:
        throw ApiException(
          type: ApiErrorType.parse,
          message: 'Simulated: Invalid response format',
        );

      case ErrorSimulationType.unknown:
        throw ApiException(
          type: ApiErrorType.unknown,
          message: 'Simulated: Unknown error occurred',
        );

      case ErrorSimulationType.none:
        break;
    }
  }

  /// Quick setup untuk testing scenario tertentu
  static void setupScenario(TestScenario scenario) {
    enableErrorSimulation = true;
    reset();

    switch (scenario) {
      case TestScenario.immediateNetworkError:
        currentError = ErrorSimulationType.network;
        errorAfterCalls = 0;
        break;

      case TestScenario.timeoutAfter2Calls:
        currentError = ErrorSimulationType.timeout;
        errorAfterCalls = 2;
        break;

      case TestScenario.serverError:
        currentError = ErrorSimulationType.server;
        errorAfterCalls = 0;
        break;

      case TestScenario.randomErrors:
      // Will randomize in shouldThrowError
        errorAfterCalls = 0;
        break;

      case TestScenario.normal:
        currentError = ErrorSimulationType.none;
        enableErrorSimulation = false;
        break;
    }
  }

  /// Get user-friendly description untuk UI
  static String getErrorDescription(ErrorSimulationType type) {
    switch (type) {
      case ErrorSimulationType.network:
        return '📡 No Internet Connection';
      case ErrorSimulationType.timeout:
        return '⏱️ Connection Timeout';
      case ErrorSimulationType.server:
        return '🔧 Server Error';
      case ErrorSimulationType.notFound:
        return '🔍 Not Found';
      case ErrorSimulationType.parse:
        return '⚠️ Invalid Data';
      case ErrorSimulationType.unknown:
        return '❌ Unknown Error';
      case ErrorSimulationType.none:
        return '✅ Normal';
    }
  }
}

/// Enum untuk tipe error simulation
enum ErrorSimulationType {
  none,
  network,
  timeout,
  server,
  notFound,
  parse,
  unknown,
}

/// Enum untuk test scenarios
enum TestScenario {
  normal,
  immediateNetworkError,
  timeoutAfter2Calls,
  serverError,
  randomErrors,
}