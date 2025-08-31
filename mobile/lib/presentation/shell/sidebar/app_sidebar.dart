import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/chinese_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/forum.dart';
import 'profile_section.dart';
import 'forum_list_section.dart';
import 'navigation_section.dart';

class AppSidebar extends ConsumerWidget {
  final bool isCompact;
  final Function(Forum)? onForumSelected;
  
  const AppSidebar({
    super.key,
    this.isCompact = false,
    this.onForumSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      width: isCompact ? AppConstants.sidebarWidthCompact : AppConstants.sidebarWidth,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          right: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Profile Section
            ProfileSection(isCompact: isCompact),
            
            // Divider
            if (!isCompact) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingM,
                ),
                child: Divider(
                  color: theme.dividerColor.withOpacity(0.5),
                ),
              ),
            ],
            
            // Forums List
            Expanded(
              child: ForumListSection(
                isCompact: isCompact,
                onForumSelected: onForumSelected,
              ),
            ),
            
            // Navigation Section
            if (!isCompact) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingM,
                ),
                child: Divider(
                  color: theme.dividerColor.withOpacity(0.5),
                ),
              ),
              NavigationSection(isCompact: isCompact),
            ],
          ],
        ),
      ),
    );
  }
}

// Sidebar Header (used in mobile drawer)
class SidebarHeader extends StatelessWidget {
  final VoidCallback? onClose;
  
  const SidebarHeader({
    super.key,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: AppConstants.spacingM,
        right: AppConstants.spacingS,
        bottom: AppConstants.spacingS,
      ),
      decoration: BoxDecoration(
        color: theme.primaryColor,
      ),
      child: Row(
        children: [
          Text(
            ChineseStrings.appFullName,
            style: AppTextStyles.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (onClose != null)
            IconButton(
              onPressed: onClose,
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              tooltip: 'Close',
            ),
        ],
      ),
    );
  }
}
