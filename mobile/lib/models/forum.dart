import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forum.g.dart';

enum ForumType {
  @JsonValue('public')
  public,
  @JsonValue('private') 
  private,
  @JsonValue('adminOnly')
  adminOnly,
  @JsonValue('announcement')
  announcement
}

enum ForumPermission {
  @JsonValue('read')
  read,
  @JsonValue('write')
  write,
  @JsonValue('moderate')
  moderate,
  @JsonValue('admin')
  admin
}

@JsonSerializable()
class ForumTag extends Equatable {
  final int id;
  final String name;
  final String color;

  const ForumTag({
    required this.id,
    required this.name,
    required this.color,
  });

  factory ForumTag.fromJson(Map<String, dynamic> json) => _$ForumTagFromJson(json);
  Map<String, dynamic> toJson() => _$ForumTagToJson(this);

  @override
  List<Object?> get props => [id, name, color];
}

@JsonSerializable()
class ForumSettings extends Equatable {
  final bool allowImages;
  final bool allowFiles;
  final bool allowPolls;
  final bool requireApproval;
  final int maxMessageLength;
  final List<String> allowedFileTypes;

  const ForumSettings({
    this.allowImages = true,
    this.allowFiles = true,
    this.allowPolls = true,
    this.requireApproval = false,
    this.maxMessageLength = 10000,
    this.allowedFileTypes = const ['jpg', 'png', 'gif', 'pdf', 'doc', 'docx'],
  });

  factory ForumSettings.fromJson(Map<String, dynamic> json) => _$ForumSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$ForumSettingsToJson(this);

  @override
  List<Object?> get props => [
    allowImages, allowFiles, allowPolls, requireApproval, 
    maxMessageLength, allowedFileTypes
  ];
}

@JsonSerializable()
class Forum extends Equatable {
  final int id;
  final String name;
  final String description;
  final String? avatarUrl;
  final String? bannerUrl;
  final ForumType type;
  final DateTime createdAt;
  final DateTime lastActivity;
  final int memberCount;
  final int onlineCount;
  final int totalPosts;
  final int unreadCount;
  final bool isMuted;
  final bool isPinned;
  final List<ForumTag> tags;
  final ForumSettings settings;
  final ForumPermission userPermission;

  const Forum({
    required this.id,
    required this.name,
    required this.description,
    this.avatarUrl,
    this.bannerUrl,
    required this.type,
    required this.createdAt,
    required this.lastActivity,
    required this.memberCount,
    required this.onlineCount,
    required this.totalPosts,
    this.unreadCount = 0,
    this.isMuted = false,
    this.isPinned = false,
    this.tags = const [],
    required this.settings,
    required this.userPermission,
  });

  factory Forum.fromJson(Map<String, dynamic> json) => _$ForumFromJson(json);
  Map<String, dynamic> toJson() => _$ForumToJson(this);

  // Helper getters
  String get displayName => name;
  
  String get lastActivityText => _formatRelativeTime(lastActivity);
  
  bool get hasUnread => unreadCount > 0;
  
  bool get canPost => userPermission.index >= ForumPermission.write.index;
  
  bool get canModerate => userPermission.index >= ForumPermission.moderate.index;

  bool get isPublic => type == ForumType.public;
  
  bool get isPrivate => type == ForumType.private;
  
  bool get isAdminOnly => type == ForumType.adminOnly;

  String get typeDisplayName {
    switch (type) {
      case ForumType.public:
        return 'Public';
      case ForumType.private:
        return 'Private';
      case ForumType.adminOnly:
        return 'Admin Only';
      case ForumType.announcement:
        return 'Announcements';
    }
  }

  String get permissionDisplayName {
    switch (userPermission) {
      case ForumPermission.read:
        return 'Read Only';
      case ForumPermission.write:
        return 'Can Post';
      case ForumPermission.moderate:
        return 'Moderator';
      case ForumPermission.admin:
        return 'Admin';
    }
  }

  static String _formatRelativeTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}d';
    return '${difference.inDays ~/ 7}w';
  }

  Forum copyWith({
    int? id,
    String? name,
    String? description,
    String? avatarUrl,
    String? bannerUrl,
    ForumType? type,
    DateTime? createdAt,
    DateTime? lastActivity,
    int? memberCount,
    int? onlineCount,
    int? totalPosts,
    int? unreadCount,
    bool? isMuted,
    bool? isPinned,
    List<ForumTag>? tags,
    ForumSettings? settings,
    ForumPermission? userPermission,
  }) {
    return Forum(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      lastActivity: lastActivity ?? this.lastActivity,
      memberCount: memberCount ?? this.memberCount,
      onlineCount: onlineCount ?? this.onlineCount,
      totalPosts: totalPosts ?? this.totalPosts,
      unreadCount: unreadCount ?? this.unreadCount,
      isMuted: isMuted ?? this.isMuted,
      isPinned: isPinned ?? this.isPinned,
      tags: tags ?? this.tags,
      settings: settings ?? this.settings,
      userPermission: userPermission ?? this.userPermission,
    );
  }

  @override
  List<Object?> get props => [
    id, name, description, avatarUrl, bannerUrl, type, createdAt,
    lastActivity, memberCount, onlineCount, totalPosts, unreadCount,
    isMuted, isPinned, tags, settings, userPermission,
  ];
}
