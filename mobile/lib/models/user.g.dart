// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      darkMode: json['darkMode'] as bool? ?? false,
      language: json['language'] as String? ?? 'en',
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      timezone: json['timezone'] as String? ?? 'UTC',
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'darkMode': instance.darkMode,
      'language': instance.language,
      'emailNotifications': instance.emailNotifications,
      'pushNotifications': instance.pushNotifications,
      'soundEnabled': instance.soundEnabled,
      'timezone': instance.timezone,
    };

UserStats _$UserStatsFromJson(Map<String, dynamic> json) => UserStats(
      totalPosts: (json['totalPosts'] as num?)?.toInt() ?? 0,
      totalReactions: (json['totalReactions'] as num?)?.toInt() ?? 0,
      forumsJoined: (json['forumsJoined'] as num?)?.toInt() ?? 0,
      reputation: (json['reputation'] as num?)?.toInt() ?? 0,
      lastActive: json['lastActive'] == null
          ? null
          : DateTime.parse(json['lastActive'] as String),
    );

Map<String, dynamic> _$UserStatsToJson(UserStats instance) => <String, dynamic>{
      'totalPosts': instance.totalPosts,
      'totalReactions': instance.totalReactions,
      'forumsJoined': instance.forumsJoined,
      'reputation': instance.reputation,
      'lastActive': instance.lastActive?.toIso8601String(),
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      role:
          $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.user,
      status: $enumDecodeNullable(_$UserStatusEnumMap, json['status']) ??
          UserStatus.offline,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
      preferences:
          UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
      stats: UserStats.fromJson(json['stats'] as Map<String, dynamic>),
      isVip: json['isVip'] as bool? ?? false,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'displayName': instance.displayName,
      'bio': instance.bio,
      'avatarUrl': instance.avatarUrl,
      'bannerUrl': instance.bannerUrl,
      'role': _$UserRoleEnumMap[instance.role]!,
      'status': _$UserStatusEnumMap[instance.status]!,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'lastSeen': instance.lastSeen?.toIso8601String(),
      'preferences': instance.preferences,
      'stats': instance.stats,
      'isVip': instance.isVip,
    };

const _$UserRoleEnumMap = {
  UserRole.user: 'user',
  UserRole.moderator: 'moderator',
  UserRole.admin: 'admin',
  UserRole.owner: 'owner',
};

const _$UserStatusEnumMap = {
  UserStatus.online: 'online',
  UserStatus.away: 'away',
  UserStatus.busy: 'busy',
  UserStatus.offline: 'offline',
};
