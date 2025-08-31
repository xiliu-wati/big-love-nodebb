import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user.dart';
import 'reaction.dart';
import 'media_attachment.dart';

part 'post.g.dart';

enum PostType {
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('file')
  file,
  @JsonValue('poll')
  poll,
  @JsonValue('announcement')
  announcement,
  @JsonValue('system')
  system
}

enum MessageStatus {
  @JsonValue('sending')
  sending,
  @JsonValue('sent')
  sent,
  @JsonValue('delivered')
  delivered,
  @JsonValue('read')
  read,
  @JsonValue('failed')
  failed
}

@JsonSerializable()
class PostMetadata extends Equatable {
  final int views;
  final int shares;
  final bool isBookmarked;
  final List<String> mentions;
  final List<String> hashtags;
  final String? linkPreview;

  const PostMetadata({
    this.views = 0,
    this.shares = 0,
    this.isBookmarked = false,
    this.mentions = const [],
    this.hashtags = const [],
    this.linkPreview,
  });

  factory PostMetadata.fromJson(Map<String, dynamic> json) => _$PostMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$PostMetadataToJson(this);

  @override
  List<Object?> get props => [views, shares, isBookmarked, mentions, hashtags, linkPreview];
}

@JsonSerializable()
class Post extends Equatable {
  final int id;
  final String title;
  final String content;
  final User author;
  final int forumId;
  final PostType type;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final MessageStatus status;
  final bool isPinned;
  final bool isEdited;
  final bool isSystem;
  final List<MediaAttachment> attachments;
  final Map<String, List<Reaction>> reactions;
  final List<Post> replies;
  final Post? parentPost;
  final int? replyToPostId;
  final PostMetadata metadata;
  final List<String> tags;
  final int upvotes;
  final int downvotes;

  const Post({
    required this.id,
    this.title = '',
    required this.content,
    required this.author,
    required this.forumId,
    this.type = PostType.text,
    required this.createdAt,
    this.updatedAt,
    this.status = MessageStatus.sent,
    this.isPinned = false,
    this.isEdited = false,
    this.isSystem = false,
    this.attachments = const [],
    this.reactions = const {},
    this.replies = const [],
    this.parentPost,
    this.replyToPostId,
    required this.metadata,
    this.tags = const [],
    this.upvotes = 0,
    this.downvotes = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);

  // Helper getters
  String get timeAgo => _formatRelativeTime(createdAt);
  
  bool get hasAttachments => attachments.isNotEmpty;
  
  bool get hasReplies => replies.isNotEmpty;
  
  int get totalReactions => reactions.values.fold(0, (sum, list) => sum + list.length);
  
  int get netVotes => upvotes - downvotes;
  
  int get replyCount => replies.length;
  
  String get displayContent => isSystem ? _formatSystemMessage() : content;

  // Legacy compatibility for existing widgets
  int get likes => upvotes;
  int get comments => replies.length;  
  bool get isLiked => false; // Will be determined by current user context
  int get votes => netVotes;
  String? get imageUrl => attachments.isNotEmpty && attachments.first.isImage 
      ? attachments.first.url 
      : null;

  String get cleanContent => _cleanContent(content);
  
  // Get user's reaction to this post
  String? getUserReaction(int userId) {
    for (final entry in reactions.entries) {
      if (entry.value.any((reaction) => reaction.user.id == userId)) {
        return entry.key;
      }
    }
    return null;
  }

  // Get top reactions (most used)
  List<MapEntry<String, int>> get topReactions {
    final reactionCounts = reactions.map((emoji, reactionsList) =>
      MapEntry(emoji, reactionsList.length));
    final sorted = reactionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(3).toList();
  }

  bool get isReply => parentPost != null || replyToPostId != null;

  bool get canEdit => !isSystem;

  String get typeDisplayName {
    switch (type) {
      case PostType.text:
        return 'Discussion';
      case PostType.image:
        return 'Image Post';
      case PostType.file:
        return 'File Share';
      case PostType.poll:
        return 'Poll';
      case PostType.announcement:
        return 'Announcement';
      case PostType.system:
        return 'System Message';
    }
  }

  String _formatSystemMessage() {
    // Format system messages like "User joined the forum"
    return content;
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

  static String _formatRelativeTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${difference.inDays ~/ 7}w ago';
  }

  Post copyWith({
    int? id,
    String? title,
    String? content,
    User? author,
    int? forumId,
    PostType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    MessageStatus? status,
    bool? isPinned,
    bool? isEdited,
    bool? isSystem,
    List<MediaAttachment>? attachments,
    Map<String, List<Reaction>>? reactions,
    List<Post>? replies,
    Post? parentPost,
    int? replyToPostId,
    PostMetadata? metadata,
    List<String>? tags,
    int? upvotes,
    int? downvotes,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      forumId: forumId ?? this.forumId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      isPinned: isPinned ?? this.isPinned,
      isEdited: isEdited ?? this.isEdited,
      isSystem: isSystem ?? this.isSystem,
      attachments: attachments ?? this.attachments,
      reactions: reactions ?? this.reactions,
      replies: replies ?? this.replies,
      parentPost: parentPost ?? this.parentPost,
      replyToPostId: replyToPostId ?? this.replyToPostId,
      metadata: metadata ?? this.metadata,
      tags: tags ?? this.tags,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
    );
  }

  @override
  List<Object?> get props => [
    id, title, content, author, forumId, type, createdAt, updatedAt,
    status, isPinned, isEdited, isSystem, attachments, reactions, replies,
    parentPost, replyToPostId, metadata, tags, upvotes, downvotes,
  ];
}