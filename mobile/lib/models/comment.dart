import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user.dart';
import 'reaction.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment extends Equatable {
  final int id;
  final String content;
  final User author;
  final int postId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isEdited;
  final int upvotes;
  final int downvotes;
  final List<Comment> replies;
  final Comment? parentComment;
  final int? replyToCommentId;
  final Map<String, List<Reaction>> reactions;

  const Comment({
    required this.id,
    required this.content,
    required this.author,
    required this.postId,
    required this.createdAt,
    this.updatedAt,
    this.isEdited = false,
    this.upvotes = 0,
    this.downvotes = 0,
    this.replies = const [],
    this.parentComment,
    this.replyToCommentId,
    this.reactions = const {},
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);

  // Helper getters
  String get timeAgo => _formatRelativeTime(createdAt);
  
  int get netVotes => upvotes - downvotes;
  
  bool get hasReplies => replies.isNotEmpty;
  
  bool get isReply => parentComment != null || replyToCommentId != null;
  
  int get totalReactions => reactions.values.fold(0, (sum, list) => sum + list.length);

  // Get user's reaction to this comment
  String? getUserReaction(int userId) {
    for (final entry in reactions.entries) {
      if (entry.value.any((reaction) => reaction.user.id == userId)) {
        return entry.key;
      }
    }
    return null;
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

  Comment copyWith({
    int? id,
    String? content,
    User? author,
    int? postId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEdited,
    int? upvotes,
    int? downvotes,
    List<Comment>? replies,
    Comment? parentComment,
    int? replyToCommentId,
    Map<String, List<Reaction>>? reactions,
  }) {
    return Comment(
      id: id ?? this.id,
      content: content ?? this.content,
      author: author ?? this.author,
      postId: postId ?? this.postId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEdited: isEdited ?? this.isEdited,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      replies: replies ?? this.replies,
      parentComment: parentComment ?? this.parentComment,
      replyToCommentId: replyToCommentId ?? this.replyToCommentId,
      reactions: reactions ?? this.reactions,
    );
  }

  @override
  List<Object?> get props => [
    id, content, author, postId, createdAt, updatedAt, isEdited,
    upvotes, downvotes, replies, parentComment, replyToCommentId, reactions,
  ];
}