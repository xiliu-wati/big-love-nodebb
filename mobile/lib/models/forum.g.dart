// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumTag _$ForumTagFromJson(Map<String, dynamic> json) => ForumTag(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      color: json['color'] as String,
    );

Map<String, dynamic> _$ForumTagToJson(ForumTag instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
    };

ForumSettings _$ForumSettingsFromJson(Map<String, dynamic> json) =>
    ForumSettings(
      allowImages: json['allowImages'] as bool? ?? true,
      allowFiles: json['allowFiles'] as bool? ?? true,
      allowPolls: json['allowPolls'] as bool? ?? true,
      requireApproval: json['requireApproval'] as bool? ?? false,
      maxMessageLength: (json['maxMessageLength'] as num?)?.toInt() ?? 10000,
      allowedFileTypes: (json['allowedFileTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['jpg', 'png', 'gif', 'pdf', 'doc', 'docx'],
    );

Map<String, dynamic> _$ForumSettingsToJson(ForumSettings instance) =>
    <String, dynamic>{
      'allowImages': instance.allowImages,
      'allowFiles': instance.allowFiles,
      'allowPolls': instance.allowPolls,
      'requireApproval': instance.requireApproval,
      'maxMessageLength': instance.maxMessageLength,
      'allowedFileTypes': instance.allowedFileTypes,
    };

Forum _$ForumFromJson(Map<String, dynamic> json) => Forum(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      type: $enumDecode(_$ForumTypeEnumMap, json['type']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActivity: DateTime.parse(json['lastActivity'] as String),
      memberCount: (json['memberCount'] as num).toInt(),
      onlineCount: (json['onlineCount'] as num).toInt(),
      totalPosts: (json['totalPosts'] as num).toInt(),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      isMuted: json['isMuted'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => ForumTag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      settings:
          ForumSettings.fromJson(json['settings'] as Map<String, dynamic>),
      userPermission:
          $enumDecode(_$ForumPermissionEnumMap, json['userPermission']),
    );

Map<String, dynamic> _$ForumToJson(Forum instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'avatarUrl': instance.avatarUrl,
      'bannerUrl': instance.bannerUrl,
      'type': _$ForumTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastActivity': instance.lastActivity.toIso8601String(),
      'memberCount': instance.memberCount,
      'onlineCount': instance.onlineCount,
      'totalPosts': instance.totalPosts,
      'unreadCount': instance.unreadCount,
      'isMuted': instance.isMuted,
      'isPinned': instance.isPinned,
      'tags': instance.tags,
      'settings': instance.settings,
      'userPermission': _$ForumPermissionEnumMap[instance.userPermission]!,
    };

const _$ForumTypeEnumMap = {
  ForumType.public: 'public',
  ForumType.private: 'private',
  ForumType.adminOnly: 'adminOnly',
  ForumType.announcement: 'announcement',
};

const _$ForumPermissionEnumMap = {
  ForumPermission.read: 'read',
  ForumPermission.write: 'write',
  ForumPermission.moderate: 'moderate',
  ForumPermission.admin: 'admin',
};
