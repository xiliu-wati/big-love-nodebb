import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (Telegram Blue)
  static const Color primaryBlue = Color(0xFF0088CC);
  static const Color primaryBlueDark = Color(0xFF50A2E9);
  static const Color primaryDark = Color(0xFF006699);
  
  // Secondary Colors
  static const Color secondaryDark = Color(0xFF17212B);
  
  // Light Theme Colors
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color surfaceVariantLight = Color(0xFFE8E8E8);
  static const Color onSurfaceLight = Color(0xFF1C1C1E);
  static const Color onSurfaceVariantLight = Color(0xFF666666);
  static const Color borderLight = Color(0xFFD1D1D6);
  
  // Dark Theme Colors
  static const Color backgroundDark = Color(0xFF212D3C);
  static const Color surfaceDark = Color(0xFF2E3A4B);
  static const Color surfaceVariantDark = Color(0xFF3A4A5C);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);
  static const Color onSurfaceVariantDark = Color(0xFFA8A8A8);
  static const Color borderDark = Color(0xFF4A5A6B);
  
  // Status Colors
  static const Color successGreen = Color(0xFF34C759);
  static const Color successGreenDark = Color(0xFF32D74B);
  static const Color warningOrange = Color(0xFFFF9500);
  static const Color warningOrangeDark = Color(0xFFFF9F0A);
  static const Color errorRed = Color(0xFFFF3B30);
  static const Color errorRedDark = Color(0xFFFF453A);
  
  // User Role Colors
  static const Color userGray = Color(0xFF757575);
  static const Color vipGold = Color(0xFFFFD700);
  static const Color moderatorBlue = Color(0xFF2196F3);
  static const Color adminRed = Color(0xFFF44336);
  static const Color ownerPurple = Color(0xFF9C27B0);
  
  // Reaction Colors
  static const Color likeGreen = Color(0xFF34C759);
  static const Color dislikeRed = Color(0xFFFF3B30);
  static const Color loveRed = Color(0xFFE91E63);
  static const Color laughYellow = Color(0xFFFFC107);
  static const Color surpriseOrange = Color(0xFFFF9800);
  static const Color sadBlue = Color(0xFF2196F3);
  static const Color angryRed = Color(0xFFF44336);
  
  // Forum Type Colors
  static const Color publicForumGreen = Color(0xFF4CAF50);
  static const Color privateForumOrange = Color(0xFFFF9800);
  static const Color adminForumRed = Color(0xFFF44336);
  static const Color announcementPurple = Color(0xFF9C27B0);
  
  // Interaction States
  static const Color hoverLight = Color(0xFFF0F0F0);
  static const Color hoverDark = Color(0xFF3A4A5C);
  static const Color pressedLight = Color(0xFFE0E0E0);
  static const Color pressedDark = Color(0xFF4A5A6B);
  static const Color selectedLight = Color(0xFFE3F2FD);
  static const Color selectedDark = Color(0xFF1A2832);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient vipGradient = LinearGradient(
    colors: [vipGold, Color(0xFFFFA000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient adminGradient = LinearGradient(
    colors: [adminRed, Color(0xFFD32F2F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Helper methods
  static Color getRoleColor(String role, {bool isVip = false}) {
    if (isVip && role.toLowerCase() == 'user') return vipGold;
    
    switch (role.toLowerCase()) {
      case 'user':
        return userGray;
      case 'moderator':
        return moderatorBlue;
      case 'admin':
        return adminRed;
      case 'owner':
        return ownerPurple;
      default:
        return userGray;
    }
  }
  
  static Color getForumTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'public':
        return publicForumGreen;
      case 'private':
        return privateForumOrange;
      case 'adminonly':
        return adminForumRed;
      case 'announcement':
        return announcementPurple;
      default:
        return publicForumGreen;
    }
  }
  
  static Color getReactionColor(String emoji) {
    switch (emoji) {
      case '👍':
        return likeGreen;
      case '👎':
        return dislikeRed;
      case '❤️':
        return loveRed;
      case '😂':
        return laughYellow;
      case '😮':
        return surpriseOrange;
      case '😢':
        return sadBlue;
      case '😡':
        return angryRed;
      default:
        return primaryBlue;
    }
  }

  // Opacity variants
  static Color withLowOpacity(Color color) => color.withValues(alpha: 0.1);
  static Color withMediumOpacity(Color color) => color.withValues(alpha: 0.5);
  static Color withHighOpacity(Color color) => color.withValues(alpha: 0.8);
}
