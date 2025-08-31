// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: (json['id'] as num).toInt(),
      content: json['content'] as String,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      postId: (json['postId'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isEdited: json['isEdited'] as bool? ?? false,
      upvotes: (json['upvotes'] as num?)?.toInt() ?? 0,
      downvotes: (json['downvotes'] as num?)?.toInt() ?? 0,
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      parentComment: json['parentComment'] == null
          ? null
          : Comment.fromJson(json['parentComment'] as Map<String, dynamic>),
      replyToCommentId: (json['replyToCommentId'] as num?)?.toInt(),
      reactions: (json['reactions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k,
                (e as List<dynamic>)
                    .map((e) => Reaction.fromJson(e as Map<String, dynamic>))
                    .toList()),
          ) ??
          const {},
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'author': instance.author,
      'postId': instance.postId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isEdited': instance.isEdited,
      'upvotes': instance.upvotes,
      'downvotes': instance.downvotes,
      'replies': instance.replies,
      'parentComment': instance.parentComment,
      'replyToCommentId': instance.replyToCommentId,
      'reactions': instance.reactions,
    };
