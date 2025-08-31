import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/forum.dart';
import '../../providers/forum_provider.dart';

class ForumListSection extends ConsumerWidget {
  final bool isCompact;
  final Function(Forum)? onForumSelected;

  const ForumListSection({
    super.key,
    this.isCompact = false,
    this.onForumSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final forumsAsync = ref.watch(forumsProvider);
    final selectedForum = ref.watch(selectedForumProvider);
    
    return Expanded(
      child: forumsAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                const SizedBox(height: 8),
                Text(
                  'Failed to load forums',
                  style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.error),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap to retry',
                  style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
        ),
        data: (forums) => _buildForumsList(context, ref, forums, theme, isCompact, selectedForum),
      ),
    );
  }

  Widget _buildForumsList(BuildContext context, WidgetRef ref, List<Forum> forums, ThemeData theme, bool isCompact, Forum? selectedForum) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Keep the existing header and spacing
        if (!isCompact) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.forum,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  'Forums',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
        
        // Forums list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: forums.length,
            itemBuilder: (context, index) {
              final forum = forums[index];
              final isSelected = selectedForum?.id == forum.id;
              
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  dense: isCompact,
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.getForumTypeColor(forum.type.name).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      _getForumIcon(forum.type),
                      size: 18,
                      color: AppColors.getForumTypeColor(forum.type.name),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          forum.name,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected 
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (forum.type == ForumType.private || forum.type == ForumType.adminOnly) ...[
                        const SizedBox(width: 4),
                        Icon(
                          _getAccessIcon(forum.type),
                          size: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ],
                    ],
                  ),
                  subtitle: !isCompact ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        '${forum.memberCount} members • ${forum.onlineCount} online',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Active ${_formatLastActivity(forum.lastActivity)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ) : null,
                  trailing: forum.unreadCount > 0 ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      forum.unreadCount > 99 ? '99+' : forum.unreadCount.toString(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ) : null,
                  onTap: () {
                    ref.read(selectedForumProvider.notifier).state = forum;
                    onForumSelected?.call(forum);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getForumIcon(ForumType type) {
    switch (type) {
      case ForumType.public:
        return Icons.public;
      case ForumType.private:
        return Icons.lock;
      case ForumType.adminOnly:
        return Icons.admin_panel_settings;
      case ForumType.announcement:
        return Icons.campaign;
    }
  }

  IconData _getAccessIcon(ForumType type) {
    switch (type) {
      case ForumType.private:
        return Icons.lock_outline;
      case ForumType.adminOnly:
        return Icons.shield;
      case ForumType.public:
        return Icons.public;
      case ForumType.announcement:
        return Icons.campaign;
    }
  }

  String _formatLastActivity(DateTime lastActivity) {
    final now = DateTime.now();
    final difference = now.difference(lastActivity);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}