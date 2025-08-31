import 'package:flutter/material.dart';

class AppTextStyles {
  // Base Font Family
  static const String fontFamily = 'SF Pro Text'; // iOS-style font
  
  // Display Text Styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.25,
    fontFamily: fontFamily,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );

  // Headline Text Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );

  // Title Text Styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    fontFamily: fontFamily,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    fontFamily: fontFamily,
  );

  // Body Text Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    fontFamily: fontFamily,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    fontFamily: fontFamily,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    fontFamily: fontFamily,
  );

  // Label Text Styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    fontFamily: fontFamily,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    fontFamily: fontFamily,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    fontFamily: fontFamily,
  );

  // Custom Forum-Specific Styles
  static const TextStyle forumTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );
  
  static const TextStyle postTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );
  
  static const TextStyle username = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );
  
  static const TextStyle usernameBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );
  
  static const TextStyle rolebadge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    fontFamily: fontFamily,
  );
  
  static const TextStyle timestamp = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );
  
  static const TextStyle postStats = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    fontFamily: fontFamily,
  );
  
  static const TextStyle reactionCount = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    fontFamily: fontFamily,
  );

  // Code and Monospace
  static const TextStyle code = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    fontFamily: 'SF Mono', // Monospace font
  );
  
  static const TextStyle codeBlock = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    fontFamily: 'SF Mono',
    height: 1.4,
  );

  // Helper methods for role-based styling
  static TextStyle getUsernameStyle(String role, {bool isVip = false}) {
    final baseStyle = username;
    
    if (isVip && role.toLowerCase() == 'user') {
      return baseStyle.copyWith(fontWeight: FontWeight.bold);
    }
    
    switch (role.toLowerCase()) {
      case 'moderator':
      case 'admin':
      case 'owner':
        return baseStyle.copyWith(fontWeight: FontWeight.bold);
      default:
        return baseStyle;
    }
  }
  
  static TextStyle getPostTitleStyle(bool isPinned) {
    return isPinned 
        ? postTitle.copyWith(fontWeight: FontWeight.bold)
        : postTitle;
  }
  
  static TextStyle getForumTitleStyle(bool hasUnread) {
    return hasUnread
        ? forumTitle.copyWith(fontWeight: FontWeight.bold)
        : forumTitle.copyWith(fontWeight: FontWeight.w500);
  }

  // Responsive text scaling
  static double getScaleFactor(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    
    if (width < 360) return 0.9; // Small phones
    if (width < 400) return 0.95; // Medium phones
    if (width > 600) return 1.1; // Tablets
    return 1.0; // Default
  }
  
  static TextStyle responsive(BuildContext context, TextStyle style) {
    final scaleFactor = getScaleFactor(context);
    return style.copyWith(fontSize: style.fontSize! * scaleFactor);
  }
}
