class ApiConfig {
  // This will be updated when we deploy NodeBB
  static const String baseUrl = 'https://biglove-nodebb.railway.app/api/v3';
  
  // For local development, uncomment this:
  // static const String baseUrl = 'http://localhost:4567/api/v3';
  
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // API Endpoints
  static const String login = '/utilities/login';
  static const String register = '/users';
  static const String topics = '/topics';
  static const String users = '/users';
  static const String upload = '/util/upload';
  static const String flags = '/flags';
}
