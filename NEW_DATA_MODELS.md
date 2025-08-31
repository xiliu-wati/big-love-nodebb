# Enhanced Data Models for Telegram-Style App

## Updated Model Definitions

### 1. Forum Model (Enhanced from Category)

```dart
enum ForumType {
  public,
  private,
  adminOnly,
  announcement
}

enum ForumPermission {
  read,
  write,
  moderate,
  admin
}

class Forum {
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

  Forum({
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

  factory Forum.fromJson(Map<String, dynamic> json) {
    return Forum(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      avatarUrl: json['avatarUrl'],
      bannerUrl: json['bannerUrl'],
      type: ForumType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ForumType.public,
      ),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastActivity: DateTime.parse(json['lastActivity'] ?? DateTime.now().toIso8601String()),
      memberCount: json['memberCount'] ?? 0,
      onlineCount: json['onlineCount'] ?? 0,
      totalPosts: json['totalPosts'] ?? 0,
      unreadCount: json['unreadCount'] ?? 0,
      isMuted: json['isMuted'] ?? false,
      isPinned: json['isPinned'] ?? false,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((tag) => ForumTag.fromJson(tag))
          .toList() ?? [],
      settings: ForumSettings.fromJson(json['settings'] ?? {}),
      userPermission: ForumPermission.values.firstWhere(
        (e) => e.name == json['userPermission'],
        orElse: () => ForumPermission.read,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'avatarUrl': avatarUrl,
    'bannerUrl': bannerUrl,
    'type': type.name,
    'createdAt': createdAt.toIso8601String(),
    'lastActivity': lastActivity.toIso8601String(),
    'memberCount': memberCount,
    'onlineCount': onlineCount,
    'totalPosts': totalPosts,
    'unreadCount': unreadCount,
    'isMuted': isMuted,
    'isPinned': isPinned,
    'tags': tags.map((tag) => tag.toJson()).toList(),
    'settings': settings.toJson(),
    'userPermission': userPermission.name,
  };

  String get displayName => name;
  String get lastActivityText => _formatRelativeTime(lastActivity);
  bool get hasUnread => unreadCount > 0;
  bool get canPost => userPermission.index >= ForumPermission.write.index;
  bool get canModerate => userPermission.index >= ForumPermission.moderate.index;

  static String _formatRelativeTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}d';
    return '${difference.inDays ~/ 7}w';
  }
}

class ForumTag {
  final int id;
  final String name;
  final String color;

  ForumTag({
    required this.id,
    required this.name,
    required this.color,
  });

  factory ForumTag.fromJson(Map<String, dynamic> json) {
    return ForumTag(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      color: json['color'] ?? '#6B46C1',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color,
  };
}

class ForumSettings {
  final bool allowImages;
  final bool allowFiles;
  final bool allowPolls;
  final bool requireApproval;
  final int maxMessageLength;
  final List<String> allowedFileTypes;

  ForumSettings({
    this.allowImages = true,
    this.allowFiles = true,
    this.allowPolls = true,
    this.requireApproval = false,
    this.maxMessageLength = 10000,
    this.allowedFileTypes = const ['jpg', 'png', 'gif', 'pdf', 'doc', 'docx'],
  });

  factory ForumSettings.fromJson(Map<String, dynamic> json) {
    return ForumSettings(
      allowImages: json['allowImages'] ?? true,
      allowFiles: json['allowFiles'] ?? true,
      allowPolls: json['allowPolls'] ?? true,
      requireApproval: json['requireApproval'] ?? false,
      maxMessageLength: json['maxMessageLength'] ?? 10000,
      allowedFileTypes: List<String>.from(json['allowedFileTypes'] ?? 
        ['jpg', 'png', 'gif', 'pdf', 'doc', 'docx']),
    );
  }

  Map<String, dynamic> toJson() => {
    'allowImages': allowImages,
    'allowFiles': allowFiles,
    'allowPolls': allowPolls,
    'requireApproval': requireApproval,
    'maxMessageLength': maxMessageLength,
    'allowedFileTypes': allowedFileTypes,
  };
}
```

### 2. Enhanced Post Model (Messages)

```dart
enum PostType {
  text,
  image,
  file,
  poll,
  announcement,
  system
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed
}

class Post {
  final int id;
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

  Post({
    required this.id,
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
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      author: User.fromJson(json['author'] ?? {}),
      forumId: json['forumId'] ?? 0,
      type: PostType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PostType.text,
      ),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      isPinned: json['isPinned'] ?? false,
      isEdited: json['isEdited'] ?? false,
      isSystem: json['isSystem'] ?? false,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((attachment) => MediaAttachment.fromJson(attachment))
          .toList() ?? [],
      reactions: _parseReactions(json['reactions'] ?? {}),
      replies: (json['replies'] as List<dynamic>?)
          ?.map((reply) => Post.fromJson(reply))
          .toList() ?? [],
      parentPost: json['parentPost'] != null ? Post.fromJson(json['parentPost']) : null,
      replyToPostId: json['replyToPostId'],
      metadata: PostMetadata.fromJson(json['metadata'] ?? {}),
    );
  }

  static Map<String, List<Reaction>> _parseReactions(Map<String, dynamic> reactionsJson) {
    final Map<String, List<Reaction>> reactions = {};
    reactionsJson.forEach((emoji, reactionsList) {
      reactions[emoji] = (reactionsList as List<dynamic>)
          .map((reaction) => Reaction.fromJson(reaction))
          .toList();
    });
    return reactions;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'author': author.toJson(),
    'forumId': forumId,
    'type': type.name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'status': status.name,
    'isPinned': isPinned,
    'isEdited': isEdited,
    'isSystem': isSystem,
    'attachments': attachments.map((a) => a.toJson()).toList(),
    'reactions': reactions.map((emoji, reactionsList) =>
      MapEntry(emoji, reactionsList.map((r) => r.toJson()).toList())),
    'replies': replies.map((r) => r.toJson()).toList(),
    'parentPost': parentPost?.toJson(),
    'replyToPostId': replyToPostId,
    'metadata': metadata.toJson(),
  };

  // Helper getters
  String get timeAgo => _formatRelativeTime(createdAt);
  bool get hasAttachments => attachments.isNotEmpty;
  bool get hasReplies => replies.isNotEmpty;
  int get totalReactions => reactions.values.fold(0, (sum, list) => sum + list.length);
  bool get isOwn => false; // Will be determined by current user context
  String get displayContent => isSystem ? _formatSystemMessage() : content;

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

  String _formatSystemMessage() {
    // Format system messages like "User joined the forum"
    return content;
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
}

class PostMetadata {
  final int views;
  final int shares;
  final bool isBookmarked;
  final List<String> mentions;
  final List<String> hashtags;
  final String? linkPreview;

  PostMetadata({
    this.views = 0,
    this.shares = 0,
    this.isBookmarked = false,
    this.mentions = const [],
    this.hashtags = const [],
    this.linkPreview,
  });

  factory PostMetadata.fromJson(Map<String, dynamic> json) {
    return PostMetadata(
      views: json['views'] ?? 0,
      shares: json['shares'] ?? 0,
      isBookmarked: json['isBookmarked'] ?? false,
      mentions: List<String>.from(json['mentions'] ?? []),
      hashtags: List<String>.from(json['hashtags'] ?? []),
      linkPreview: json['linkPreview'],
    );
  }

  Map<String, dynamic> toJson() => {
    'views': views,
    'shares': shares,
    'isBookmarked': isBookmarked,
    'mentions': mentions,
    'hashtags': hashtags,
    'linkPreview': linkPreview,
  };
}
```

### 3. Reaction Model

```dart
class Reaction {
  final int id;
  final String emoji;
  final User user;
  final DateTime createdAt;

  Reaction({
    required this.id,
    required this.emoji,
    required this.user,
    required this.createdAt,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      id: json['id'] ?? 0,
      emoji: json['emoji'] ?? '👍',
      user: User.fromJson(json['user'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'emoji': emoji,
    'user': user.toJson(),
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Reaction &&
    runtimeType == other.runtimeType &&
    id == other.id;

  @override
  int get hashCode => id.hashCode;
}
```

### 4. Media Attachment Model

```dart
enum AttachmentType {
  image,
  video,
  audio,
  document,
  link
}

class MediaAttachment {
  final int id;
  final String filename;
  final String url;
  final String? thumbnailUrl;
  final AttachmentType type;
  final int size;
  final String mimeType;
  final Map<String, dynamic>? metadata;

  MediaAttachment({
    required this.id,
    required this.filename,
    required this.url,
    this.thumbnailUrl,
    required this.type,
    required this.size,
    required this.mimeType,
    this.metadata,
  });

  factory MediaAttachment.fromJson(Map<String, dynamic> json) {
    return MediaAttachment(
      id: json['id'] ?? 0,
      filename: json['filename'] ?? '',
      url: json['url'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
      type: AttachmentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AttachmentType.document,
      ),
      size: json['size'] ?? 0,
      mimeType: json['mimeType'] ?? 'application/octet-stream',
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'filename': filename,
    'url': url,
    'thumbnailUrl': thumbnailUrl,
    'type': type.name,
    'size': size,
    'mimeType': mimeType,
    'metadata': metadata,
  };

  String get displaySize {
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  bool get isImage => type == AttachmentType.image;
  bool get isVideo => type == AttachmentType.video;
  bool get isAudio => type == AttachmentType.audio;
  bool get isDocument => type == AttachmentType.document;
}
```

### 5. Enhanced User Model

```dart
enum UserRole {
  user,
  moderator,
  admin,
  owner
}

enum UserStatus {
  online,
  away,
  busy,
  offline
}

class User {
  final int id;
  final String username;
  final String email;
  final String? displayName;
  final String? bio;
  final String? avatarUrl;
  final String? bannerUrl;
  final UserRole role;
  final UserStatus status;
  final DateTime joinedAt;
  final DateTime? lastSeen;
  final UserPreferences preferences;
  final UserStats stats;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.displayName,
    this.bio,
    this.avatarUrl,
    this.bannerUrl,
    this.role = UserRole.user,
    this.status = UserStatus.offline,
    required this.joinedAt,
    this.lastSeen,
    required this.preferences,
    required this.stats,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'],
      bio: json['bio'],
      avatarUrl: json['avatarUrl'],
      bannerUrl: json['bannerUrl'],
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.user,
      ),
      status: UserStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => UserStatus.offline,
      ),
      joinedAt: DateTime.parse(json['joinedAt'] ?? DateTime.now().toIso8601String()),
      lastSeen: json['lastSeen'] != null ? DateTime.parse(json['lastSeen']) : null,
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
      stats: UserStats.fromJson(json['stats'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'displayName': displayName,
    'bio': bio,
    'avatarUrl': avatarUrl,
    'bannerUrl': bannerUrl,
    'role': role.name,
    'status': status.name,
    'joinedAt': joinedAt.toIso8601String(),
    'lastSeen': lastSeen?.toIso8601String(),
    'preferences': preferences.toJson(),
    'stats': stats.toJson(),
  };

  String get name => displayName ?? username;
  bool get isOnline => status == UserStatus.online;
  bool get canModerate => role.index >= UserRole.moderator.index;
  bool get canAdmin => role.index >= UserRole.admin.index;
  String get roleDisplayName => role.name.toUpperCase();
  String get statusText {
    switch (status) {
      case UserStatus.online:
        return 'Online';
      case UserStatus.away:
        return 'Away';
      case UserStatus.busy:
        return 'Busy';
      case UserStatus.offline:
        return lastSeen != null ? 'Last seen ${_formatLastSeen()}' : 'Offline';
    }
  }

  String _formatLastSeen() {
    if (lastSeen == null) return 'Unknown';
    final now = DateTime.now();
    final difference = now.difference(lastSeen!);
    
    if (difference.inMinutes < 1) return 'just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return 'on ${lastSeen!.day}/${lastSeen!.month}';
  }
}

class UserPreferences {
  final bool darkMode;
  final String language;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool soundEnabled;
  final String timezone;

  UserPreferences({
    this.darkMode = false,
    this.language = 'en',
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.soundEnabled = true,
    this.timezone = 'UTC',
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      darkMode: json['darkMode'] ?? false,
      language: json['language'] ?? 'en',
      emailNotifications: json['emailNotifications'] ?? true,
      pushNotifications: json['pushNotifications'] ?? true,
      soundEnabled: json['soundEnabled'] ?? true,
      timezone: json['timezone'] ?? 'UTC',
    );
  }

  Map<String, dynamic> toJson() => {
    'darkMode': darkMode,
    'language': language,
    'emailNotifications': emailNotifications,
    'pushNotifications': pushNotifications,
    'soundEnabled': soundEnabled,
    'timezone': timezone,
  };
}

class UserStats {
  final int totalPosts;
  final int totalReactions;
  final int forumsJoined;
  final DateTime? lastActive;

  UserStats({
    this.totalPosts = 0,
    this.totalReactions = 0,
    this.forumsJoined = 0,
    this.lastActive,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalPosts: json['totalPosts'] ?? 0,
      totalReactions: json['totalReactions'] ?? 0,
      forumsJoined: json['forumsJoined'] ?? 0,
      lastActive: json['lastActive'] != null ? DateTime.parse(json['lastActive']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalPosts': totalPosts,
    'totalReactions': totalReactions,
    'forumsJoined': forumsJoined,
    'lastActive': lastActive?.toIso8601String(),
  };
}
```

These enhanced models provide:

1. **Rich Forum Management**: Types, permissions, settings, member counts
2. **Advanced Messaging**: Status tracking, threading, reactions, attachments  
3. **User Presence**: Online status, last seen, preferences
4. **Content Types**: Text, images, files, polls, system messages
5. **Interaction Features**: Reactions with emoji, reply threading, mentions
6. **Metadata Support**: Views, shares, bookmarks, hashtags
7. **Permission System**: Role-based access control
8. **Real-time Features**: Status updates, typing indicators (via separate models)

These models support the full Telegram-style experience with rich interactions and modern messaging features.
