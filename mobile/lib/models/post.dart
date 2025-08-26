import 'user.dart';

class Post {
  final int id;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final String? imageUrl;
  final bool isLiked;
  final int? categoryId;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.likes,
    required this.comments,
    this.imageUrl,
    this.isLiked = false,
    this.categoryId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? 'Unknown',
      createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      imageUrl: _extractImageUrl(json['content'] ?? ''),
      isLiked: json['isLiked'] ?? false,
      categoryId: json['categoryId'],
    );
  }

  static String _cleanContent(String content) {
    // Remove HTML tags for display
    return content
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .trim();
  }

  static String? _extractImageUrl(String content) {
    // Extract image URLs from markdown or HTML
    final imgRegex = RegExp(r'!\[.*?\]\(([^)]+)\)|<img[^>]+src="([^"]+)"', caseSensitive: false);
    final match = imgRegex.firstMatch(content);
    return match?.group(1) ?? match?.group(2);
  }

  String get cleanContent => _cleanContent(content);

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // Compatibility properties for post card
  User? get user => User(
    id: 1,
    username: author,
    email: '$author@example.com',
    role: 'user',
    joinedAt: DateTime.now(),
  ); // Mock user object
  int get votes => likes; // Use likes as votes

  Post copyWith({
    int? id,
    String? title,
    String? content,
    String? author,
    DateTime? createdAt,
    int? likes,
    int? comments,
    String? imageUrl,
    bool? isLiked,
    int? categoryId,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      imageUrl: imageUrl ?? this.imageUrl,
      isLiked: isLiked ?? this.isLiked,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}

// Comment class will be added later when we implement comments feature
