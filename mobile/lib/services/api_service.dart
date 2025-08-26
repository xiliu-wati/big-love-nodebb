import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../models/category.dart';

class ApiService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  // Get stored auth token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Save auth token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Save user ID
  Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  // Get headers with auth token
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Handle HTTP errors
  String _handleError(http.Response response) {
    try {
      final data = json.decode(response.body);
      if (data is Map<String, dynamic>) {
        return data['message'] ?? data['error'] ?? 'An error occurred';
      }
    } catch (e) {
      // If JSON parsing fails, return status message
    }
    return 'Server error: ${response.statusCode}';
  }

  // Authentication
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.login}'),
        headers: await _getHeaders(),
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['token'] != null) {
          await _saveToken(data['token']);
          await _saveUserId(data['user']['id'].toString());
        }
        return data;
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      if (e is String) throw e;
      throw 'Network error. Please check your connection.';
    }
  }

  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.register}'),
        headers: await _getHeaders(),
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      if (e is String) throw e;
      throw 'Network error. Please check your connection.';
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
  }

  // User Profile
  Future<User> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.userProfile}'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      if (e is String) throw e;
      throw 'Network error. Please check your connection.';
    }
  }

  // Posts
  Future<List<Post>> getPosts({int page = 1, int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.posts}'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> postsData = data['posts'] ?? [];
        return postsData.map((json) => Post.fromJson(json)).toList();
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      if (e is String) throw e;
      throw 'Network error. Please check your connection.';
    }
  }

  Future<Post> createPost(String title, String content, {String? imageUrl}) async {
    try {
      String finalContent = content;
      if (imageUrl != null) {
        finalContent = '$content\n\n![User uploaded image]($imageUrl)';
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.posts}'),
        headers: await _getHeaders(),
        body: json.encode({
          'title': title,
          'content': finalContent,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['post'] != null) {
          return Post.fromJson(data['post']);
        } else {
          throw 'Failed to create post';
        }
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      if (e is String) throw e;
      throw 'Network error. Please check your connection.';
    }
  }

  // App Configuration
  Future<Map<String, dynamic>> getConfig() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.config}'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      if (e is String) throw e;
      throw 'Network error. Please check your connection.';
    }
  }

  // Health Check
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl.replaceAll('/api', '')}/health'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'healthy';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  // Get current user ID
  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Get categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.categories}'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> categoriesData = data['categories'] ?? [];
        return categoriesData.map((json) => Category.fromJson(json)).toList();
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      if (e is String) throw e;
      throw 'Network error. Please check your connection.';
    }
  }

  // Get comments for a post
  Future<List<Comment>> getComments(int postId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/posts/$postId/comments'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> commentsData = data['comments'] ?? [];
        return commentsData.map((json) => Comment.fromJson(json)).toList();
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      if (e is String) throw e;
      throw 'Network error. Please check your connection.';
    }
  }

  // Add comment to a post
  Future<Comment> addComment(int postId, String content) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/posts/$postId/comments'),
        headers: await _getHeaders(),
        body: json.encode({
          'content': content,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Comment.fromJson(data['comment']);
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      if (e is String) throw e;
      throw 'Network error. Please check your connection.';
    }
  }

  // Like a comment
  Future<int> likeComment(int commentId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/comments/$commentId/like'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['likes'] ?? 0;
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      if (e is String) throw e;
      throw 'Network error. Please check your connection.';
    }
  }

  // Like a post
  Future<int> likePost(int postId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/posts/$postId/like'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['likes'] ?? 0;
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      if (e is String) throw e;
      throw 'Network error. Please check your connection.';
    }
  }
}
