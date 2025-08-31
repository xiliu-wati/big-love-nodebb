import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/localization/chinese_strings.dart';
import 'presentation/shell/app_shell.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/home/forum_home_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'presentation/screens/post/post_thread_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: BigLoveApp(),
    ),
  );
}

class BigLoveApp extends ConsumerWidget {
  const BigLoveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: ChineseStrings.appFullName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _createRouter(),
      debugShowCheckedModeBanner: false,
    );
  }

  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: '/forums',
      routes: [
        // Authentication Routes
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        
        // Main Shell Route
        ShellRoute(
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            // Forums Home
            GoRoute(
              path: '/forums',
              builder: (context, state) => const ForumHomeScreen(),
            ),
            
            // User Profile
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
            
            // Forum-specific routes (for future implementation)
            GoRoute(
              path: '/forum/:forumId',
              builder: (context, state) {
                final forumId = state.pathParameters['forumId']!;
                return ForumDetailScreen(forumId: int.parse(forumId));
              },
            ),
            
            // Post-specific routes
            GoRoute(
              path: '/forum/:forumId/post/:postId',
              builder: (context, state) {
                final forumId = state.pathParameters['forumId']!;
                final postId = state.pathParameters['postId']!;
                return PostThreadScreen(
                  forumId: int.parse(forumId),
                  postId: int.parse(postId),
                );
              },
            ),
          ],
        ),
      ],
      
      // Error handling
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Page not found: ${state.uri}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/forums'),
                child: const Text('Go to Forums'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder screens for future implementation
class ForumDetailScreen extends StatelessWidget {
  final int forumId;
  
  const ForumDetailScreen({super.key, required this.forumId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Forum Detail Screen'),
          Text('Forum ID: $forumId'),
          const Text('(Coming in Phase 2)'),
        ],
      ),
    );
  }
}