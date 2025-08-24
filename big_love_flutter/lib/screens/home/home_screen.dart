import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart';
import '../../models/post.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().loadPosts(refresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= 
          _scrollController.position.maxScrollExtent - 200) {
        context.read<PostProvider>().loadPosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Home - already here
        break;
      case 1:
        context.go('/create-post');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Big Love'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return PopupMenuButton(
                icon: CircleAvatar(
                  radius: 16,
                  backgroundImage: authProvider.currentUser?.picture != null
                      ? CachedNetworkImageProvider(authProvider.currentUser!.avatarUrl)
                      : null,
                  child: authProvider.currentUser?.picture == null
                      ? Text(
                          authProvider.currentUser?.username[0].toUpperCase() ?? 'U',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    onTap: () => context.go('/profile'),
                  ),
                  PopupMenuItem(
                    child: const ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    onTap: () async {
                      await authProvider.logout();
                      if (mounted) {
                        context.go('/login');
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, _) {
          if (postProvider.isLoading && postProvider.posts.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (postProvider.error != null && postProvider.posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading posts',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    postProvider.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => postProvider.refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (postProvider.posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.forum_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No posts yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Be the first to share something!',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/create-post'),
                    child: const Text('Create Post'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => postProvider.loadPosts(refresh: true),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: postProvider.posts.length + (postProvider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= postProvider.posts.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final post = postProvider.posts[index];
                return PostCard(
                  post: post,
                  onLike: () => postProvider.likePost(index),
                  onComment: (content) => postProvider.addComment(index, content),
                  onReport: (reason) => postProvider.reportPost(index, reason),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/create-post'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
