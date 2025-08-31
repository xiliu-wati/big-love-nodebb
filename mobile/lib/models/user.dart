import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum UserRole {
  @JsonValue('user')
  user,
  @JsonValue('moderator')
  moderator,
  @JsonValue('admin')
  admin,
  @JsonValue('owner')
  owner
}

enum UserStatus {
  @JsonValue('online')
  online,
  @JsonValue('away')
  away,
  @JsonValue('busy')
  busy,
  @JsonValue('offline')
  offline
}

@JsonSerializable()
class UserPreferences extends Equatable {
  final bool darkMode;
  final String language;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool soundEnabled;
  final String timezone;

  const UserPreferences({
    this.darkMode = false,
    this.language = 'en',
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.soundEnabled = true,
    this.timezone = 'UTC',
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  @override
  List<Object?> get props => [
    darkMode, language, emailNotifications, pushNotifications, soundEnabled, timezone
  ];
}

@JsonSerializable()
class UserStats extends Equatable {
  final int totalPosts;
  final int totalReactions;
  final int forumsJoined;
  final int reputation;
  final DateTime? lastActive;

  const UserStats({
    this.totalPosts = 0,
    this.totalReactions = 0,
    this.forumsJoined = 0,
    this.reputation = 0,
    this.lastActive,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) => _$UserStatsFromJson(json);
  Map<String, dynamic> toJson() => _$UserStatsToJson(this);

  @override
  List<Object?> get props => [totalPosts, totalReactions, forumsJoined, reputation, lastActive];
}

@JsonSerializable()
class User extends Equatable {
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
  final bool isVip;

  const User({
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
    this.isVip = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // Helper getters
  String get name => displayName ?? username;
  
  bool get isOnline => status == UserStatus.online;
  
  bool get canModerate => role.index >= UserRole.moderator.index;
  
  bool get canAdmin => role.index >= UserRole.admin.index;
  
  String get roleDisplayName {
    if (isVip && role == UserRole.user) return 'VIP';
    return role.name.toUpperCase();
  }

  String get roleBadgeEmoji {
    if (isVip && role == UserRole.user) return '👑';
    switch (role) {
      case UserRole.user:
        return '👤';
      case UserRole.moderator:
        return '🛡️';
      case UserRole.admin:
        return '⚡';
      case UserRole.owner:
        return '👑';
    }
  }

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

  String get reputationDisplay {
    if (stats.reputation >= 1000) {
      return '${(stats.reputation / 1000).toStringAsFixed(1)}k';
    }
    return stats.reputation.toString();
  }

  // Legacy compatibility properties
  String? get picture => avatarUrl;
  String get avatarUrl_legacy => avatarUrl ?? '';

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

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? displayName,
    String? bio,
    String? avatarUrl,
    String? bannerUrl,
    UserRole? role,
    UserStatus? status,
    DateTime? joinedAt,
    DateTime? lastSeen,
    UserPreferences? preferences,
    UserStats? stats,
    bool? isVip,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
      lastSeen: lastSeen ?? this.lastSeen,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
      isVip: isVip ?? this.isVip,
    );
  }

  @override
  List<Object?> get props => [
    id, username, email, displayName, bio, avatarUrl, bannerUrl,
    role, status, joinedAt, lastSeen, preferences, stats, isVip,
  ];
}