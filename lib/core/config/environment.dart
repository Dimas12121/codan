// Environment Configuration
// Untuk switching antara development dan production
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
      print('✅ Environment loaded: $env from $envFile');
      print('📍 API Base URL: $baseUrl');
    } catch (e) {
      print('⚠️  Could not load $envFile: $e');
      print('📍 Using default configuration for: $env');
      _envVars = {};
    }
  }

  static String get baseUrl {
    return _envVars?['API_BASE_URL'] ??
        switch (_environment) {
          Environment.development => 'http://127.0.0.1:8000/api',
          Environment.staging => 'https://staging.codean.brodims.my.id/api',
          Environment.production => 'https://codean.brodims.my.id/api',
        };
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
      print('[DEBUG] $message');
    }
  }

  static void info(String message) {
    print('[INFO] $message');
  }

  static void error(String message, [dynamic error]) {
    print('[ERROR] $message');
    if (error != null) {
      print('[ERROR DETAILS] $error');
    }
  }

  static void apiRequest(String method, String endpoint, [dynamic data]) {
    if (EnvironmentConfig.isDevelopment) {
      print('[API REQUEST] $method $endpoint');
      if (data != null) {
        print('[REQUEST DATA] $data');
      }
    }
  }

  static void apiResponse(String method, String endpoint, dynamic response) {
    if (EnvironmentConfig.isDevelopment) {
      print('[API RESPONSE] $method $endpoint');
      print('[RESPONSE DATA] $response');
    }
  }
}
