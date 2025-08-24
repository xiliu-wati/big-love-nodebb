import 'user.dart';

class Post {
  final int tid;
  final int uid;
  final String title;
  final String content;
  final DateTime timestamp;
  final int postcount;
  final int viewcount;
  final int votes;
  final bool locked;
  final bool pinned;
  final bool deleted;
  final User? user;
  final List<Comment> comments;
  final String? imageUrl;
  final bool isLiked;

  Post({
    required this.tid,
    required this.uid,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.postcount,
    required this.viewcount,
    required this.votes,
    required this.locked,
    required this.pinned,
    required this.deleted,
    this.user,
    required this.comments,
    this.imageUrl,
    required this.isLiked,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      tid: json['tid'] ?? 0,
      uid: json['uid'] ?? 0,
      title: json['title'] ?? '',
      content: _cleanContent(json['content'] ?? ''),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000) * 1000,
      ),
      postcount: json['postcount'] ?? 0,
      viewcount: json['viewcount'] ?? 0,
      votes: json['votes'] ?? 0,
      locked: json['locked'] == 1,
      pinned: json['pinned'] == 1,
      deleted: json['deleted'] == 1,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      comments: (json['posts'] as List<dynamic>?)
              ?.skip(1) // Skip the first post which is the topic itself
              ?.map((commentJson) => Comment.fromJson(commentJson))
              .toList() ??
          [],
      imageUrl: _extractImageUrl(json['content'] ?? ''),
      isLiked: json['upvoted'] == true,
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
    final imgRegex = RegExp(r'<img[^>]+src="([^"]+)"', caseSensitive: false);
    final match = imgRegex.firstMatch(content);
    return match?.group(1);
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

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

  Post copyWith({
    int? tid,
    int? uid,
    String? title,
    String? content,
    DateTime? timestamp,
    int? postcount,
    int? viewcount,
    int? votes,
    bool? locked,
    bool? pinned,
    bool? deleted,
    User? user,
    List<Comment>? comments,
    String? imageUrl,
    bool? isLiked,
  }) {
    return Post(
      tid: tid ?? this.tid,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      postcount: postcount ?? this.postcount,
      viewcount: viewcount ?? this.viewcount,
      votes: votes ?? this.votes,
      locked: locked ?? this.locked,
      pinned: pinned ?? this.pinned,
      deleted: deleted ?? this.deleted,
      user: user ?? this.user,
      comments: comments ?? this.comments,
      imageUrl: imageUrl ?? this.imageUrl,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class Comment {
  final int pid;
  final int tid;
  final int uid;
  final String content;
  final DateTime timestamp;
  final int votes;
  final bool deleted;
  final User? user;
  final bool isLiked;

  Comment({
    required this.pid,
    required this.tid,
    required this.uid,
    required this.content,
    required this.timestamp,
    required this.votes,
    required this.deleted,
    this.user,
    required this.isLiked,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      pid: json['pid'] ?? 0,
      tid: json['tid'] ?? 0,
      uid: json['uid'] ?? 0,
      content: Post._cleanContent(json['content'] ?? ''),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000) * 1000,
      ),
      votes: json['votes'] ?? 0,
      deleted: json['deleted'] == 1,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      isLiked: json['upvoted'] == true,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

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
}
