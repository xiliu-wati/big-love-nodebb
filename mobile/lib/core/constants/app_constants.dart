class AppConstants {
  // Layout Constants
  static const double sidebarWidth = 280.0;
  static const double sidebarWidthCompact = 72.0;
  static const double tabletBreakpoint = 768.0;
  static const double desktopBreakpoint = 1024.0;
  
  // Spacing Constants
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  
  // Icon Sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  
  // Avatar Sizes
  static const double avatarS = 24.0;
  static const double avatarM = 32.0;
  static const double avatarL = 48.0;
  static const double avatarXL = 64.0;
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 350);
  
  // Touch Target Sizes
  static const double minTouchTarget = 44.0;
  static const double touchTargetPadding = 8.0;
  
  // Forum Limits
  static const int maxPostTitleLength = 200;
  static const int maxPostContentLength = 10000;
  static const int maxReplyDepth = 4;
  static const int postsPerPage = 20;
  static const int repliesPerPage = 10;
  
  // File Upload Limits
  static const int maxImageSizeMB = 10;
  static const int maxFileSizeMB = 25;
  static const int maxAttachmentsPerPost = 5;
  
  // Popular Emojis for Reactions
  static const List<String> popularEmojis = [
    '👍', '👎', '❤️', '😂', '😮', '😢', '😡', '🔥', '💯', '👏'
  ];
  
  // Forum Categories
  static const List<String> defaultCategories = [
    'General Discussion',
    'Tech Support',
    'Feature Requests',
    'Off Topic',
    'Announcements'
  ];
  
  // User Role Hierarchy (higher index = more permissions)
  static const Map<String, int> roleHierarchy = {
    'user': 0,
    'vip': 1,
    'moderator': 2,
    'admin': 3,
    'owner': 4,
  };
}
