import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_text_styles.dart';

class SimpleSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;
  
  SimpleSearchDelegate(this.ref);

  @override
  String get searchFieldLabel => 'Search posts, forums, and users...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            'Search results for "$query"',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: AppConstants.spacingS),
          const Text(
            'Search functionality is coming soon!',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            'Start typing to search',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: AppConstants.spacingS),
          const Text(
            'Search posts, forums, and users',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
