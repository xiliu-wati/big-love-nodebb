// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostMetadata _$PostMetadataFromJson(Map<String, dynamic> json) => PostMetadata(
      views: (json['views'] as num?)?.toInt() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      mentions: (json['mentions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      hashtags: (json['hashtags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      linkPreview: json['linkPreview'] as String?,
    );

Map<String, dynamic> _$PostMetadataToJson(PostMetadata instance) =>
    <String, dynamic>{
      'views': instance.views,
      'shares': instance.shares,
      'isBookmarked': instance.isBookmarked,
      'mentions': instance.mentions,
      'hashtags': instance.hashtags,
      'linkPreview': instance.linkPreview,
    };

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      content: json['content'] as String,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      forumId: (json['forumId'] as num).toInt(),
      type:
          $enumDecodeNullable(_$PostTypeEnumMap, json['type']) ?? PostType.text,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
          MessageStatus.sent,
      isPinned: json['isPinned'] as bool? ?? false,
      isEdited: json['isEdited'] as bool? ?? false,
      isSystem: json['isSystem'] as bool? ?? false,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => MediaAttachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      reactions: (json['reactions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k,
                (e as List<dynamic>)
                    .map((e) => Reaction.fromJson(e as Map<String, dynamic>))
                    .toList()),
          ) ??
          const {},
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => Post.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      parentPost: json['parentPost'] == null
          ? null
          : Post.fromJson(json['parentPost'] as Map<String, dynamic>),
      replyToPostId: (json['replyToPostId'] as num?)?.toInt(),
      metadata: PostMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      upvotes: (json['upvotes'] as num?)?.toInt() ?? 0,
      downvotes: (json['downvotes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'author': instance.author,
      'forumId': instance.forumId,
      'type': _$PostTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'status': _$MessageStatusEnumMap[instance.status]!,
      'isPinned': instance.isPinned,
      'isEdited': instance.isEdited,
      'isSystem': instance.isSystem,
      'attachments': instance.attachments,
      'reactions': instance.reactions,
      'replies': instance.replies,
      'parentPost': instance.parentPost,
      'replyToPostId': instance.replyToPostId,
      'metadata': instance.metadata,
      'tags': instance.tags,
      'upvotes': instance.upvotes,
      'downvotes': instance.downvotes,
    };

const _$PostTypeEnumMap = {
  PostType.text: 'text',
  PostType.image: 'image',
  PostType.file: 'file',
  PostType.poll: 'poll',
  PostType.announcement: 'announcement',
  PostType.system: 'system',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
  MessageStatus.failed: 'failed',
};
