class ApiConfig {
  // Updated to use our working backend
  static const String baseUrl = 'https://kind-vibrancy-production.up.railway.app/api';
  
  // For local development, uncomment this:
  // static const String baseUrl = 'http://localhost:4567/api';
  
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // API Endpoints - Updated for our backend
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String posts = '/posts';
  static const String users = '/users';
  static const String config = '/config';
  static const String userProfile = '/users/me';
  static const String comments = '/comments';
  static const String categories = '/categories';
}
