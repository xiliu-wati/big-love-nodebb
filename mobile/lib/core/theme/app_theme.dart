import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        brightness: Brightness.light,
        primary: AppColors.primaryBlue,
        secondary: AppColors.secondaryDark,
        surface: AppColors.surfaceLight,
        error: AppColors.errorRed,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.onSurfaceLight,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.onSurfaceLight,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AppColors.onSurfaceLight),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      
      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.errorRed, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.onSurfaceVariantLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.onSurfaceLight),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.onSurfaceLight),
        displaySmall: AppTextStyles.displaySmall.copyWith(color: AppColors.onSurfaceLight),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.onSurfaceLight),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.onSurfaceLight),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: AppColors.onSurfaceLight),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurfaceLight),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurfaceLight),
        titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurfaceLight),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.onSurfaceLight),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceLight),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceLight),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.onSurfaceLight),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.onSurfaceLight),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurfaceLight),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlueDark,
        brightness: Brightness.dark,
        primary: AppColors.primaryBlueDark,
        secondary: AppColors.secondaryDark,
        surface: AppColors.surfaceDark,
        error: AppColors.errorRedDark,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.onSurfaceDark,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.onSurfaceDark,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AppColors.onSurfaceDark),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      
      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryBlueDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.errorRedDark, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlueDark,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlueDark,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlueDark,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primaryBlueDark,
        unselectedItemColor: AppColors.onSurfaceVariantDark,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.onSurfaceDark),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.onSurfaceDark),
        displaySmall: AppTextStyles.displaySmall.copyWith(color: AppColors.onSurfaceDark),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.onSurfaceDark),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.onSurfaceDark),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: AppColors.onSurfaceDark),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurfaceDark),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurfaceDark),
        titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.onSurfaceDark),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.onSurfaceDark),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceDark),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceDark),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.onSurfaceDark),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.onSurfaceDark),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurfaceDark),
      ),
    );
  }
}
