import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 64,
            color: Colors.grey,
          ),
          
          SizedBox(height: AppConstants.spacingL),
          
          Text(
            'Profile Screen',
            style: AppTextStyles.headlineMedium,
          ),
          
          SizedBox(height: AppConstants.spacingM),
          
          Text(
            'Coming in Phase 7',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
