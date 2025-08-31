import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/chinese_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/forum_provider.dart';
import '../../providers/posts_provider.dart';
import '../../widgets/forum_post_card.dart';

class MainContentArea extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onMenuPressed;
  
  const MainContentArea({
    super.key,
    required this.child,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedForum = ref.watch(selectedForumProvider);
    
    return Column(
      children: [
        // Header Bar
        MainContentHeader(
          selectedForum: selectedForum,
          onMenuPressed: onMenuPressed,
        ),
        
        // Content Area
        Expanded(
          child: selectedForum != null 
              ? ForumContentView(forum: selectedForum)
              : const ForumSelectionView(),
        ),
      ],
    );
  }
}

class MainContentHeader extends StatelessWidget {
  final dynamic selectedForum;
  final VoidCallback? onMenuPressed;
  
  const MainContentHeader({
    super.key,
    this.selectedForum,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < AppConstants.tabletBreakpoint;
    
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
        child: Row(
          children: [
            // Menu Button (Mobile)
            if (isMobile && onMenuPressed != null) ...[
              IconButton(
                onPressed: onMenuPressed,
                icon: const Icon(Icons.menu),
                tooltip: 'Open Menu',
              ),
              const SizedBox(width: AppConstants.spacingS),
            ],
            
            // Forum Info or App Title
            Expanded(
              child: selectedForum != null 
                  ? ForumHeaderInfo(forum: selectedForum)
                  : Text(
                      ChineseStrings.appFullName,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            
            // Header Actions
            if (selectedForum != null) ...[
              IconButton(
                onPressed: () {
                  // TODO: Search within forum
                },
                icon: const Icon(Icons.search),
                tooltip: 'Search in Forum',
              ),
              
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                tooltip: 'Forum Options',
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'members',
                    child: ListTile(
                      leading: Icon(Icons.people),
                      title: Text('View Members'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'rules',
                    child: ListTile(
                      leading: Icon(Icons.rule),
                      title: Text('Forum Rules'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'notifications',
                    child: ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Notification Settings'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
                onSelected: (value) {
                  // TODO: Handle menu actions
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ForumHeaderInfo extends StatelessWidget {
  final dynamic forum;
  
  const ForumHeaderInfo({
    super.key,
    required this.forum,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Forum Name
        Text(
          forum.name,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        // Forum Stats
        Text(
          '${forum.memberCount} members • ${forum.onlineCount} online',
          style: AppTextStyles.bodySmall.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class ForumSelectionView extends StatelessWidget {
  const ForumSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          
          const SizedBox(height: AppConstants.spacingL),
          
          Text(
            '选择一个论坛开始使用',
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingM),
          
          Text(
            '从侧边栏选择一个论坛来查看帖子并开始讨论',
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ForumContentView extends ConsumerWidget {
  final dynamic forum;
  
  const ForumContentView({
    super.key,
    required this.forum,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(selectedForumPostsProvider);
    final postCreationState = ref.watch(postCreationProvider);
    final isCreatingPost = postCreationState.isLoading;
    
    return Column(
      children: [
        // Posts List
        Expanded(
          child: postsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 8),
                  Text(
                    'Failed to load posts',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pull down to retry',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            data: (posts) {
              if (posts.isEmpty) {
                return _buildEmptyState(context);
              }
              
              return RefreshIndicator(
                onRefresh: () => _refreshPosts(ref),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: posts.length + (isCreatingPost ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (isCreatingPost && index == 0) {
                      return _buildCreatingPostIndicator();
                    }
                    
                    final postIndex = isCreatingPost ? index - 1 : index;
                    final post = posts[postIndex];
                    
                    return ForumPostCard(
                      post: post,
                      onTap: () => _openPostThread(context, post),
                    );
                  },
                ),
              );
            },
          ),
        ),
        
        // Create Post FAB
        Padding(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              onPressed: () => _showCreatePostDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('新帖子'),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          
          const SizedBox(height: AppConstants.spacingL),
          
          Text(
            '还没有帖子',
            style: AppTextStyles.titleMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingS),
          
          Text(
            '成为第一个开始讨论的人！',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildCreatingPostIndicator() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingM),
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: AppConstants.spacingM),
          Text(
            'Creating post...',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _refreshPosts(WidgetRef ref) async {
    ref.invalidate(selectedForumPostsProvider);
  }
  
  void _openPostThread(BuildContext context, dynamic post) {
    context.go('/forum/${post.forumId}/post/${post.id}');
  }
  
  void _showCreatePostDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => CreatePostDialog(),
    );
  }
}

// Create Post Dialog
class CreatePostDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends ConsumerState<CreatePostDialog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedForum = ref.watch(selectedForumProvider);
    
    return AlertDialog(
      title: Text('创建新帖子'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Posting in: ${selectedForum?.name ?? "Unknown Forum"}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              
              const SizedBox(height: AppConstants.spacingL),
              
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '帖子标题',
                  hintText: '输入您的帖子标题...',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a title';
                  }
                  if (value!.length < 5) {
                    return 'Title must be at least 5 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppConstants.spacingL),
              
              // Content Field
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: '内容',
                  hintText: '分享您的想法...',
                  alignLabelWithHint: true,
                ),
                maxLines: 6,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter some content';
                  }
                  if (value!.length < 10) {
                    return 'Content must be at least 10 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppConstants.spacingM),
              
              // Helper text
              Text(
                'Tip: Use #hashtags and @mentions to engage with the community!',
                style: AppTextStyles.bodySmall.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _submitPost,
          child: const Text('发布'),
        ),
      ],
    );
  }
  
  void _submitPost() {
    if (!_formKey.currentState!.validate()) return;
    
    final selectedForum = ref.read(selectedForumProvider);
    if (selectedForum == null) return;
    
    // Use the post creation provider instead
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;
    
    ref.read(postCreationProvider.notifier).createPost(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      forumId: selectedForum.id,
      authorId: currentUser.id,
      tags: _extractTags(_contentController.text),
    );
    
    Navigator.of(context).pop();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post created successfully!'),
      ),
    );
  }
  
  List<String> _extractTags(String content) {
    final RegExp hashtagRegex = RegExp(r'#(\w+)');
    return hashtagRegex.allMatches(content)
        .map((match) => match.group(1)!)
        .toList();
  }
}
