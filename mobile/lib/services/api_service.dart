import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/post.dart';
import '../models/forum.dart';
import '../models/comment.dart';

class ApiService {
  // Base URL - not used, see apiUrl getter below
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Try multiple endpoints for different environments - PRIORITIZE Android emulator
  static List<String> get apiUrls {
    return [
      'https://surprising-exploration-production.up.railway.app/api', // Railway deployment - TRY FIRST
      'http://10.0.2.2:3000/api',      // For Android emulator (local fallback)
      'http://localhost:3000/api',     // For iOS simulator and web
      'http://127.0.0.1:3000/api',     // Alternative localhost
    ];
  }

  static String get apiUrl => apiUrls.first;

  static final http.Client _client = http.Client();

  // Users
  static Future<List<User>> getUsers() async {
    for (String url in apiUrls) {
      try {
        final response = await _client.get(Uri.parse('$url/users'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          return data.map((json) => User.fromJson(json)).toList();
        }
      } catch (e) {
        print('Failed to connect to $url: $e');
        continue; // Try next URL
      }
    }
    throw Exception('Failed to connect to any API endpoint');
  }

  static Future<User?> getUser(int id) async {
    try {
      final response = await _client.get(Uri.parse('$apiUrl/users/$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Forums
  static Future<List<Forum>> getForums() async {
    print('🔧 DEBUG: Attempting to fetch forums from API...');
    for (String url in apiUrls) {
      try {
        print('🌐 Trying API endpoint: $url');
        final response = await _client.get(Uri.parse('$url/forums')).timeout(Duration(seconds: 5));
        print('📡 Response status: ${response.statusCode}');
        if (response.statusCode == 200) {
          print('✅ SUCCESS: Forums fetched from $url');
          final List<dynamic> data = json.decode(response.body);
          final forums = data.map((json) => _mapApiForumToModel(json)).toList();
          print('📋 Loaded ${forums.length} forums');
          return forums;
        }
      } catch (e) {
        print('❌ Failed to connect to $url: $e');
        continue; // Try next URL
      }
    }
    print('💥 CRITICAL ERROR: Could not connect to any API endpoint!');
    throw Exception('Failed to connect to any API endpoint for forums');
  }

  static Future<Forum?> getForum(int id) async {
    try {
      final response = await _client.get(Uri.parse('$apiUrl/forums/$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Forum.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Posts
  static Future<List<Post>> getPosts({int? forumId, int limit = 50, int offset = 0}) async {
    try {
      String url = '$apiUrl/posts?limit=$limit&offset=$offset';
      if (forumId != null) {
        url += '&forumId=$forumId';
      }
      
      final response = await _client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => _postFromApiJson(json)).toList();
      }
      throw Exception('Failed to load posts: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }

  static Future<Post?> getPost(int id) async {
    try {
      final response = await _client.get(Uri.parse('$apiUrl/posts/$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _postFromApiJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Comments
  static Future<List<Comment>> getComments(int postId) async {
    try {
      final response = await _client.get(Uri.parse('$apiUrl/posts/$postId/comments'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => _commentFromApiJson(json)).toList();
      }
      throw Exception('Failed to load comments: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load comments: $e');
    }
  }

  // Create new post
  static Future<Post> createPost({
    required String title,
    required String content,
    required int forumId,
    required int authorId,
    List<String>? tags,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$apiUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': title,
          'content': content,
          'forumId': forumId,
          'authorId': authorId,
          'tags': tags ?? [],
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return _postFromApiJson(data);
      }
      throw Exception('Failed to create post: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  // Create new comment
  static Future<Comment> createComment({
    required int postId,
    required String content,
    required int authorId,
    int? parentId,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$apiUrl/posts/$postId/comments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'content': content,
          'authorId': authorId,
          'parentId': parentId,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return _commentFromApiJson(data);
      }
      throw Exception('Failed to create comment: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to create comment: $e');
    }
  }

  // Vote on post
  static Future<Map<String, int>> votePost(int postId, String type) async {
    try {
      final response = await _client.post(
        Uri.parse('$apiUrl/posts/$postId/vote'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'type': type}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'upvotes': data['upvotes'] as int,
          'downvotes': data['downvotes'] as int,
        };
      }
      throw Exception('Failed to vote: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to vote: $e');
    }
  }

  // Add reaction to post
  static Future<Map<String, int>> reactToPost(int postId, String emoji) async {
    try {
      final response = await _client.post(
        Uri.parse('$apiUrl/posts/$postId/react'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'emoji': emoji}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Map<String, int>.from(data);
      }
      throw Exception('Failed to react: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to react: $e');
    }
  }

  // Helper method to convert API JSON to Post model
  static Post _postFromApiJson(Map<String, dynamic> json) {
    // Convert API format to our model format
    final author = json['author'] as Map<String, dynamic>;
    
    return Post(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      author: User(
        id: author['id'] is String ? int.parse(author['id']) : author['id'] as int,
        username: author['username'] as String,
        email: author['email'] as String,
        displayName: author['displayName'] as String,
        bio: author['bio'] as String? ?? '',
        avatarUrl: author['avatarUrl'] as String? ?? '',
        role: _parseUserRole(author['role'] as String),
        status: _parseUserStatus(author['status'] as String),
        joinedAt: DateTime.parse(author['joinedAt'] as String),
        preferences: const UserPreferences(),
        stats: UserStats.fromJson(author['stats'] as Map<String, dynamic>),
      ),
      forumId: json['forumId'] is String ? int.parse(json['forumId']) : json['forumId'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      upvotes: json['upvotes'] as int? ?? 0,
      downvotes: json['downvotes'] as int? ?? 0,
      reactions: {}, // Simplified for now - TODO: Convert from server format
      tags: List<String>.from(json['tags'] as List? ?? []),
      isPinned: json['isPinned'] as bool? ?? false,
      attachments: [],
      metadata: const PostMetadata(), // Simplified for now
    );
  }

  // Helper method to convert API JSON to Comment model  
  static Comment _commentFromApiJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>;
    
    return Comment(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      postId: json['postId'] is String ? int.parse(json['postId']) : json['postId'] as int,
      author: User(
        id: author['id'] is String ? int.parse(author['id']) : author['id'] as int,
        username: author['username'] as String,
        email: author['email'] as String,
        displayName: author['displayName'] as String,
        bio: author['bio'] as String? ?? '',
        avatarUrl: author['avatarUrl'] as String? ?? '',
        role: _parseUserRole(author['role'] as String),
        status: _parseUserStatus(author['status'] as String),
        joinedAt: DateTime.parse(author['joinedAt'] as String),
        preferences: const UserPreferences(),
        stats: UserStats.fromJson(author['stats'] as Map<String, dynamic>),
      ),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      upvotes: json['upvotes'] as int? ?? 0,
      downvotes: json['downvotes'] as int? ?? 0,
      reactions: {}, // Simplified for now - TODO: Convert from server format
      // parentId: json['parentId'] as int?, // TODO: Add parent support later
    );
  }

  static UserRole _parseUserRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'moderator':
        return UserRole.moderator;
      case 'vip':
        return UserRole.user; // VIP treated as regular user for now
      case 'user':
      default:
        return UserRole.user;
    }
  }

  static UserStatus _parseUserStatus(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return UserStatus.online;
      case 'away':
        return UserStatus.away;
      case 'offline':
      default:
        return UserStatus.offline;
    }
  }

  // Health check
  static Future<bool> isHealthy() async {
    try {
      final response = await _client.get(Uri.parse('$apiUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static void dispose() {
    _client.close();
  }

  // Map API forum data to Forum model
  static Forum _mapApiForumToModel(Map<String, dynamic> apiData) {
    // Convert API category to ForumType
    String getForumType() {
      final category = apiData['category'] as String? ?? 'general';
      final isPrivate = apiData['isPrivate'] as bool? ?? false;
      
      if (isPrivate) return 'private';
      if (category.toLowerCase().contains('admin')) return 'adminOnly';
      if (category.toLowerCase().contains('announcement')) return 'announcement';
      return 'public'; // Default for general, support, feedback, etc.
    }

    // Create properly formatted data for Forum.fromJson
    final forumData = <String, dynamic>{
      'id': apiData['id'],
      'name': apiData['name'],
      'description': apiData['description'],
      'avatarUrl': null,
      'bannerUrl': null,
      'type': getForumType(),
      'createdAt': DateTime.now().toIso8601String(),
      'lastActivity': DateTime.now().toIso8601String(),
      'memberCount': apiData['memberCount'] ?? 0,
      'onlineCount': 0, // API doesn't provide this
      'totalPosts': apiData['postCount'] ?? 0,
      'unreadCount': 0,
      'isMuted': false,
      'isPinned': false,
      'tags': (apiData['tags'] as List<dynamic>?)?.map((tag) => {
        'id': tag.hashCode,
        'name': tag as String,
        'color': '#007AFF', // Default blue color
      }).toList() ?? [],
      'settings': {
        'allowImages': true,
        'allowFiles': true,
        'allowPolls': false,
        'requireApproval': false,
        'maxMessageLength': 1000,
        'allowedFileTypes': <String>[],
      },
      'userPermission': 'write',
    };

    return Forum.fromJson(forumData);
  }
}
