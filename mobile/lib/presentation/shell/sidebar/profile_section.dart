import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/chinese_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/user.dart';
import '../../providers/forum_provider.dart';

class ProfileSection extends ConsumerWidget {
  final bool isCompact;
  
  const ProfileSection({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    
    if (user == null) {
      return _buildLoginPrompt(context, theme);
    }
    
    if (isCompact) {
      return _buildCompactProfile(context, theme, user);
    }
    
    return _buildFullProfile(context, theme, user);
  }
  
  Widget _buildLoginPrompt(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Column(
        children: [
          Icon(
            Icons.person_outline,
            size: AppConstants.iconXL,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(height: AppConstants.spacingS),
          if (!isCompact) ...[
            Text(
              '未登录',
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: AppConstants.spacingM),
            ElevatedButton(
              onPressed: () {
                // Navigate to login
                // TODO: Implement navigation to login screen
              },
              child: const Text('登录'),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildCompactProfile(BuildContext context, ThemeData theme, User user) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Column(
        children: [
          _buildAvatar(user, AppConstants.avatarL),
          const SizedBox(height: AppConstants.spacingS),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getStatusColor(user.status),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFullProfile(BuildContext context, ThemeData theme, User user) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Column(
        children: [
          // Avatar and Status
          Stack(
            children: [
              _buildAvatar(user, AppConstants.avatarXL),
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getStatusColor(user.status),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingM),
          
          // User Info
          Text(
            user.name,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: AppConstants.spacingXS),
          
          // Role Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.roleBadgeEmoji,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: AppConstants.spacingXS),
              Text(
                user.roleDisplayName,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.getRoleColor(user.role.name, isVip: user.isVip),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingXS),
          
          // Status Text
          Text(
            user.statusText,
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: AppConstants.spacingM),
          
          // Quick Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickAction(
                context,
                Icons.person_outline,
                '个人资料',
                () {
                  // TODO: Navigate to profile
                },
              ),
              _buildQuickAction(
                context,
                Icons.settings_outlined,
                '设置',
                () {
                  // TODO: Navigate to settings
                },
              ),
              _buildQuickAction(
                context,
                user.preferences.darkMode ? Icons.light_mode : Icons.dark_mode,
                '主题',
                () {
                  // TODO: Toggle theme
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildAvatar(User user, double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: user.avatarUrl != null
            ? CachedNetworkImage(
                imageUrl: user.avatarUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.surfaceVariantLight,
                  child: Icon(
                    Icons.person,
                    size: size * 0.6,
                    color: AppColors.onSurfaceVariantLight,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.surfaceVariantLight,
                  child: Icon(
                    Icons.person,
                    size: size * 0.6,
                    color: AppColors.onSurfaceVariantLight,
                  ),
                ),
              )
            : Container(
                color: AppColors.getRoleColor(user.role.name, isVip: user.isVip)
                    .withOpacity(0.2),
                child: Center(
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: size * 0.4,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getRoleColor(user.role.name, isVip: user.isVip),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
  
  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String tooltip,
    VoidCallback onPressed,
  ) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingS),
          child: Icon(
            icon,
            size: AppConstants.iconS,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
  
  Color _getStatusColor(UserStatus status) {
    switch (status) {
      case UserStatus.online:
        return AppColors.successGreen;
      case UserStatus.away:
        return AppColors.warningOrange;
      case UserStatus.busy:
        return AppColors.errorRed;
      case UserStatus.offline:
        return Colors.grey;
    }
  }
}
