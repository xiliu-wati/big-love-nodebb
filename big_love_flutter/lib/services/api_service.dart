import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import '../models/post.dart';

class ApiService {
  late final Dio _dio;
  static const _storage = FlutterSecureStorage();

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Token expired, clear storage
          _storage.delete(key: 'auth_token');
          _storage.delete(key: 'user_id');
        }
        handler.next(error);
      },
    ));
  }

  // Authentication
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(ApiConfig.login, data: {
        'username': username,
        'password': password,
      });
      
      // NodeBB returns user data and sets cookies
      if (response.data['uid'] != null) {
        await _storage.write(key: 'user_id', value: response.data['uid'].toString());
        
        // Extract session token from cookies if available
        final cookies = response.headers['set-cookie'];
        if (cookies != null) {
          for (final cookie in cookies) {
            if (cookie.contains('express.sid=')) {
              final sessionId = cookie.split('express.sid=')[1].split(';')[0];
              await _storage.write(key: 'auth_token', value: sessionId);
              break;
            }
          }
        }
      }
      
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    try {
      final response = await _dio.post(ApiConfig.register, data: {
        'username': username,
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_id');
  }

  // User Profile
  Future<User> getUserProfile(int uid) async {
    try {
      final response = await _dio.get('${ApiConfig.users}/$uid');
      return User.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> updateProfile(int uid, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('${ApiConfig.users}/$uid', data: data);
      return User.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Posts/Topics
  Future<List<Post>> getPosts({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(ApiConfig.topics, queryParameters: {
        'page': page,
        'limit': limit,
      });
      
      final List<dynamic> topicsData = response.data['topics'] ?? [];
      return topicsData.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Post> createPost(String title, String content, {String? imageUrl}) async {
    try {
      String finalContent = content;
      if (imageUrl != null) {
        finalContent = '$content\n\n<img src="$imageUrl" alt="User uploaded image" />';
      }

      final response = await _dio.post(ApiConfig.topics, data: {
        'title': title,
        'content': finalContent,
        'cid': 1, // Default category ID - you may need to adjust this
      });
      return Post.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Post> getPost(int tid) async {
    try {
      final response = await _dio.get('${ApiConfig.topics}/$tid');
      return Post.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Comments/Replies
  Future<void> addComment(int tid, String content) async {
    try {
      await _dio.post('${ApiConfig.topics}/$tid', data: {
        'content': content,
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Likes/Votes
  Future<void> likePost(int pid) async {
    try {
      await _dio.put('/posts/$pid/vote', data: {
        'delta': 1,
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Reports
  Future<void> reportContent(int id, String type, String reason) async {
    try {
      await _dio.post(ApiConfig.flags, data: {
        'type': type,
        'id': id,
        'reason': reason,
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  // File Upload
  Future<String> uploadImage(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'files[]': await MultipartFile.fromFile(filePath),
      });
      
      final response = await _dio.post(ApiConfig.upload, data: formData);
      
      // NodeBB typically returns an array of uploaded files
      if (response.data is List && response.data.isNotEmpty) {
        return response.data[0]['url'];
      } else if (response.data['url'] != null) {
        return response.data['url'];
      }
      
      throw 'Upload failed: No URL returned';
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final data = error.response?.data;
        if (data is Map<String, dynamic>) {
          return data['message'] ?? data['error'] ?? 'An error occurred';
        } else if (data is String) {
          return data;
        }
        return 'Server error: ${error.response?.statusCode}';
      } else {
        return 'Network error. Please check your connection.';
      }
    }
    return error.toString();
  }
}
