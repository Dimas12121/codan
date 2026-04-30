// Environment Configuration
// Untuk switching antara development dan production
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { development, staging, production }

class EnvironmentConfig {
  static Environment _environment = Environment.development;
  static Map<String, String>? _envVars;

  static Environment get current => _environment;

  static Future<void> loadEnvironment(Environment env) async {
    _environment = env;

    String envFile;
    switch (env) {
      case Environment.development:
        envFile = '.env.development';
        break;
      case Environment.staging:
        envFile = '.env.staging';
        break;
      case Environment.production:
        envFile = '.env.production';
        break;
    }

    try {
      await dotenv.load(fileName: envFile);
      _envVars = dotenv.env;
      debugPrint('✅ Environment loaded: $env from $envFile');
      debugPrint('📍 API Base URL: $baseUrl');
    } catch (e) {
      debugPrint('⚠️  Could not load $envFile: $e');
      debugPrint('📍 Using default configuration for: $env');
      _envVars = {};
    }
  }

  static String get baseUrl {
    // Priority 1: Direct API_BASE_URL from .env
    final envBaseUrl = _envVars?['API_BASE_URL'] ?? 
                       _envVars?['API_BASE_URL_${_environment.name.toUpperCase()}'];
    
    if (envBaseUrl != null) return envBaseUrl;

    // Priority 2: Hardcoded defaults based on environment and platform
    return switch (_environment) {
      Environment.development => _getDevelopmentBaseUrl(),
      Environment.staging => 'https://staging.codean.brodims.my.id/api',
      Environment.production => 'https://codean.brodims.my.id/api',
    };
  }

  static String _getDevelopmentBaseUrl() {
    // If running on Android emulator, use 10.0.2.2
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api';
    }
    // Default for iOS emulator, web, and desktop
    return 'http://127.0.0.1:8000/api';
  }

  static String get appName {
    return _envVars?['APP_NAME'] ?? 'CODean';
  }

  static bool get enableDebug {
    return _envVars?['ENABLE_DEBUG'] == 'true' || isDevelopment;
  }

  static String get logLevel {
    return _envVars?['LOG_LEVEL'] ?? 'debug';
  }

  static bool get isDevelopment => _environment == Environment.development;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProduction => _environment == Environment.production;

  static Map<String, dynamic> get debugSettings {
    return {
      'showDebugBanner': enableDebug,
      'enableLogging': enableDebug,
      'mockApi': false,
    };
  }

  // Get any environment variable
  static String? getEnv(String key) {
    return _envVars?[key];
  }
}

// Helper untuk logging berdasarkan environment
class AppLogger {
  static void debug(String message) {
    if (EnvironmentConfig.isDevelopment) {
      debugPrint('[DEBUG] $message');
    }
  }

  static void info(String message) {
    debugPrint('[INFO] $message');
  }

  static void error(String message, [dynamic error]) {
    debugPrint('[ERROR] $message');
    if (error != null) {
      debugPrint('[ERROR DETAILS] $error');
    }
  }

  static void apiRequest(String method, String endpoint, [dynamic data]) {
    if (EnvironmentConfig.isDevelopment) {
      debugPrint('[API REQUEST] $method $endpoint');
      if (data != null) {
        debugPrint('[REQUEST DATA] $data');
      }
    }
  }

  static void apiResponse(String method, String endpoint, dynamic response) {
    if (EnvironmentConfig.isDevelopment) {
      debugPrint('[API RESPONSE] $method $endpoint');
      debugPrint('[RESPONSE DATA] $response');
    }
  }
}
