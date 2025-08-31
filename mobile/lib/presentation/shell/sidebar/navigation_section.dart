import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/chinese_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';


class NavigationSection extends ConsumerWidget {
  final bool isCompact;
  
  const NavigationSection({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.all(isCompact ? AppConstants.spacingS : AppConstants.spacingM),
      child: Column(
        children: [
          // Search
          NavigationItem(
            icon: Icons.search,
            label: ChineseStrings.search,
            isCompact: isCompact,
            onTap: () {
              // TODO: Implement search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search functionality coming soon!')),
              );
            },
          ),
          
          // Statistics
          NavigationItem(
            icon: Icons.bar_chart,
            label: '统计信息',
            isCompact: isCompact,
            onTap: () {
              // TODO: Implement forum statistics
            },
          ),
          
          // Members Directory
          NavigationItem(
            icon: Icons.people,
            label: ChineseStrings.members,
            isCompact: isCompact,
            onTap: () {
              // TODO: Implement members directory
            },
          ),
          
          // Settings
          NavigationItem(
            icon: Icons.settings,
            label: ChineseStrings.settings,
            isCompact: isCompact,
            onTap: () {
              // TODO: Implement settings
            },
          ),
          
          // Help & Support
          NavigationItem(
            icon: Icons.help_outline,
            label: '帮助',
            isCompact: isCompact,
            onTap: () {
              // TODO: Implement help
            },
          ),
          
          const SizedBox(height: AppConstants.spacingM),
          
          // Logout
          NavigationItem(
            icon: Icons.logout,
            label: '退出登录',
            isCompact: isCompact,
            isDestructive: true,
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }
  
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement logout logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }
}

class NavigationItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isCompact;
  final bool isDestructive;
  final VoidCallback onTap;
  
  const NavigationItem({
    super.key,
    required this.icon,
    required this.label,
    this.isCompact = false,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  State<NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<NavigationItem> {
  bool _isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = widget.isDestructive 
        ? AppColors.errorRed 
        : theme.colorScheme.onSurface.withOpacity(0.8);
    
    if (widget.isCompact) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Tooltip(
          message: widget.label,
          child: Material(
            color: _isHovered 
                ? theme.colorScheme.onSurface.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppConstants.radiusS),
            child: InkWell(
              onTap: widget.onTap,
              onHover: (isHovered) {
                setState(() {
                  _isHovered = isHovered;
                });
              },
              borderRadius: BorderRadius.circular(AppConstants.radiusS),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Icon(
                  widget.icon,
                  size: AppConstants.iconM,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: _isHovered 
            ? theme.colorScheme.onSurface.withOpacity(0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: InkWell(
          onTap: widget.onTap,
          onHover: (isHovered) {
            setState(() {
              _isHovered = isHovered;
            });
          },
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingM,
              vertical: AppConstants.spacingS,
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: AppConstants.iconM,
                  color: textColor,
                ),
                const SizedBox(width: AppConstants.spacingM),
                Expanded(
                  child: Text(
                    widget.label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: textColor,
                      fontWeight: _isHovered ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
