import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/forum.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';

// Mock current user provider (represents logged-in user)
final currentUserProvider = StateProvider<User?>((ref) => User(
  id: 1,  // This would come from authentication in a real app
  username: 'john_doe',
  email: 'john@example.com',
  displayName: 'John Doe',
  bio: 'Forum enthusiast and active community member.',
  role: UserRole.user,
  status: UserStatus.online,
  joinedAt: DateTime.now().subtract(const Duration(days: 30)),
  preferences: const UserPreferences(),
  stats: const UserStats(
    totalPosts: 42,
    totalReactions: 156,
    forumsJoined: 5,
    reputation: 1247,
  ),
));

// Forum data provider using API
final forumsProvider = FutureProvider<List<Forum>>((ref) async {
  try {
    // ApiService.getForums() already returns properly formatted Forum objects
    final forums = await ApiService.getForums();
    print('🎯 FORUMS PROVIDER: Successfully loaded ${forums.length} forums');
    return forums;
  } catch (e) {
    print('❌ FORUMS PROVIDER ERROR: $e');
    // Fallback to empty list if API fails
    return [];
  }
});

// Selected forum provider
final selectedForumProvider = StateProvider<Forum?>((ref) => null);

// Forum selection notifier for advanced state management
class ForumSelectionNotifier extends StateNotifier<Forum?> {
  ForumSelectionNotifier() : super(null);
  
  void selectForum(Forum forum) {
    state = forum;
  }
  
  void clearSelection() {
    state = null;
  }
  
  void updateForumActivity(int forumId) {
    if (state?.id == forumId) {
      // Update last activity time
      final updatedForum = state!.copyWith(
        lastActivity: DateTime.now(),
      );
      state = updatedForum;
    }
  }
}

final forumSelectionProvider = StateNotifierProvider<ForumSelectionNotifier, Forum?>(
  (ref) => ForumSelectionNotifier(),
);

// Helper functions to convert API data to our models
ForumType _getForumType(String name, bool isPrivate) {
  final lowerName = name.toLowerCase();
  if (lowerName.contains('admin')) return ForumType.adminOnly;
  if (lowerName.contains('vip') || isPrivate) return ForumType.private;
  if (lowerName.contains('announcement')) return ForumType.announcement;
  return ForumType.public; // Default for general, support, feedback, etc.
}

List<ForumTag> _generateForumTags(List<String> apiTags, String name) {
  final tags = <ForumTag>[];
  final lowerName = name.toLowerCase();
  
  // Add name-based tag
  if (lowerName.contains('general')) {
    tags.add(const ForumTag(id: 1, name: 'General', color: '#4CAF50'));
  } else if (lowerName.contains('support')) {
    tags.add(const ForumTag(id: 2, name: 'Support', color: '#FF9800'));
  } else if (lowerName.contains('vip')) {
    tags.add(const ForumTag(id: 3, name: 'VIP', color: '#FFD700'));
  } else if (lowerName.contains('admin')) {
    tags.add(const ForumTag(id: 4, name: 'Admin', color: '#F44336'));
  } else if (lowerName.contains('feature')) {
    tags.add(const ForumTag(id: 5, name: 'Features', color: '#607D8B'));
  } else {
    tags.add(const ForumTag(id: 6, name: 'Discussion', color: '#2196F3'));
  }
  
  // Add API tags if available
  for (int i = 0; i < apiTags.length && i < 2; i++) {
    tags.add(ForumTag(
      id: 10 + i,
      name: apiTags[i].capitalize(),
      color: _getTagColor(i),
    ));
  }
  
  return tags;
}

String _getTagColor(int index) {
  const colors = [
    '#2196F3', // Blue
    '#9C27B0', // Purple
    '#00BCD4', // Cyan
    '#795548', // Brown
    '#607D8B', // Blue Grey
  ];
  return colors[index % colors.length];
}

ForumPermission _getUserPermission(String name, bool isPrivate) {
  final lowerName = name.toLowerCase();
  // Admin areas are read-only for regular users
  if (lowerName.contains('admin')) return ForumPermission.read;
  
  // VIP areas might be read-only depending on user status
  if (lowerName.contains('vip')) return ForumPermission.read;
  
  // Public forums allow writing
  return ForumPermission.write;
}

extension StringCapitalize on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}