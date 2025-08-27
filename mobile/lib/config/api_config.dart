class ApiConfig {
  // Updated to use our working backend
  static const String baseUrl = 'https://extraordinary-heart-production-3220.up.railway.app';
  
  // For local development, uncomment this:
  // static const String baseUrl = 'http://localhost:4567/api';
  
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // API Endpoints - Updated for our backend
    static const String login = '/api/login';
    static const String register = '/api/register';
    static const String posts = '/api/posts';
  static const String users = '/users';
  static const String config = '/config';
    static const String userProfile = '/api/user/profile';
  static const String comments = '/comments';
    static const String categories = '/api/categories';
}
