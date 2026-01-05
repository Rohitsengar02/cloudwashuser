class AppConfig {
  static const String devBaseUrl = 'http://localhost:5001/api';
  static const String prodBaseUrl = 'https://cloudwashapi.onrender.com/api';

  // Toggle this to switch environments
  static const bool isProduction = true;

  static String get baseUrl => isProduction ? prodBaseUrl : devBaseUrl;
}
