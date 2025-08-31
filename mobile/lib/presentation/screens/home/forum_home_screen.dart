import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ForumHomeScreen extends ConsumerWidget {
  const ForumHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: WelcomeView(),
    );
  }
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Welcome Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.forum,
              size: 64,
              color: theme.primaryColor,
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingXL),
          
          // Welcome Title
          Text(
            '欢迎来到大爱社区',
            style: AppTextStyles.displaySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppConstants.spacingL),
          
          // Welcome Description
          Text(
            '连接社区，分享想法，参与有意义的讨论。从侧边栏选择一个论坛开始您的大爱之旅。',
            style: AppTextStyles.bodyLarge.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppConstants.spacingXXL),
          
          // Quick Stats or Featured Content
          _buildQuickStats(context),
          
          const SizedBox(height: AppConstants.spacingXL),
          
          // Quick Actions
          _buildQuickActions(context),
        ],
      ),
    );
  }
  
  Widget _buildQuickStats(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            context,
            icon: Icons.forum,
            value: '4',
            label: 'Forums',
          ),
          _buildStatDivider(context),
          _buildStatItem(
            context,
            icon: Icons.people,
            value: '1.8K',
            label: 'Members',
          ),
          _buildStatDivider(context),
          _buildStatItem(
            context,
            icon: Icons.message,
            value: '26.8K',
            label: 'Posts',
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(
          icon,
          size: AppConstants.iconL,
          color: theme.primaryColor,
        ),
        const SizedBox(height: AppConstants.spacingS),
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppConstants.spacingXS),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 60,
      color: Theme.of(context).dividerColor,
    );
  }
  
  Widget _buildQuickActions(BuildContext context) {
    return Wrap(
      spacing: AppConstants.spacingM,
      runSpacing: AppConstants.spacingM,
      alignment: WrapAlignment.center,
      children: [
        _buildActionButton(
          context,
          icon: Icons.explore,
          label: 'Browse Forums',
          description: 'Explore all available forums',
          onPressed: () {
            // TODO: Focus on forum sidebar or show all forums
          },
        ),
        _buildActionButton(
          context,
          icon: Icons.person,
          label: 'My Profile',
          description: 'View and edit your profile',
          onPressed: () {
            // TODO: Navigate to profile
          },
        ),
        _buildActionButton(
          context,
          icon: Icons.help_outline,
          label: 'Get Help',
          description: 'Learn how to use the forums',
          onPressed: () {
            // TODO: Show help or tutorial
          },
        ),
      ],
    );
  }
  
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: 200,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(AppConstants.spacingL),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: AppConstants.iconL,
              color: theme.primaryColor,
            ),
            const SizedBox(height: AppConstants.spacingM),
            Text(
              label,
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              description,
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
