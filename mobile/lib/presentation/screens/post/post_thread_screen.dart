import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../../models/forum.dart';
import '../../../models/comment.dart';
import '../../providers/posts_provider.dart';
import '../../providers/forum_provider.dart';
import '../../widgets/forum_post_card.dart';
import '../../widgets/reply_composer.dart';

class PostThreadScreen extends ConsumerStatefulWidget {
  final int postId;
  final int forumId;
  
  const PostThreadScreen({
    super.key,
    required this.postId,
    required this.forumId,
  });

  @override
  ConsumerState<PostThreadScreen> createState() => _PostThreadScreenState();
}

class _PostThreadScreenState extends ConsumerState<PostThreadScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showReplyComposer = false;
  Post? _replyingToPost;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(postProvider(widget.postId));
    final selectedForum = ref.watch(selectedForumProvider);
    
    return postAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text('Failed to load post', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(error.toString(), style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
      data: (post) => _buildPostScreen(context, post ?? _createDummyPost(), selectedForum),
    );
  }

  Widget _buildPostScreen(BuildContext context, Post mainPost, Forum? selectedForum) {
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mainPost.title.isNotEmpty ? mainPost.title : 'Post Thread',
              style: AppTextStyles.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (selectedForum != null)
              Text(
                selectedForum.name,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showPostOptions(context, mainPost),
            icon: const Icon(Icons.more_vert),
            tooltip: 'Post Options',
          ),
        ],
      ),
      body: Column(
        children: [
          // Thread Content
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Main Post
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(AppConstants.spacingM),
                    child: _buildMainPost(mainPost),
                  ),
                ),
                
                // Replies Header
                SliverToBoxAdapter(
                  child: _buildRepliesHeader(0),
                ),
                
                // Replies List
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildReplyItem(
                      mainPost.replies[index],
                      depth: 0,
                    ),
                    childCount: mainPost.replies.length,
                  ),
                ),
                
                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
          ),
          
          // Reply Composer
          if (_showReplyComposer)
            ReplyComposer(
              replyingTo: _replyingToPost ?? mainPost,
              onSubmit: _submitReply,
              onCancel: _cancelReply,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startReply(mainPost),
        child: const Icon(Icons.reply),
        tooltip: 'Reply to Post',
      ),
    );
  }
  
  Widget _buildMainPost(Post post) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          _buildPostHeader(post),
          
          if (post.title.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacingL),
            Text(
              post.title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          
          const SizedBox(height: AppConstants.spacingL),
          
          // Post Content
          Text(
            post.content,
            style: AppTextStyles.bodyLarge.copyWith(
              color: theme.colorScheme.onSurface,
              height: 1.6,
            ),
          ),
          
          // Media Attachments
          if (post.hasAttachments) ...[
            const SizedBox(height: AppConstants.spacingL),
            _buildAttachments(post),
          ],
          
          const SizedBox(height: AppConstants.spacingL),
          
          // Post Statistics and Actions
          _buildPostActions(post),
          
          // Reactions
          if (post.totalReactions > 0) ...[
            const SizedBox(height: AppConstants.spacingM),
            _buildReactionsDisplay(post),
          ],
        ],
      ),
    );
  }
  
  Widget _buildPostHeader(Post post) {
    return Row(
      children: [
        // Author Avatar
        Container(
          width: AppConstants.avatarL,
          height: AppConstants.avatarL,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.getRoleColor(post.author.role.name, isVip: post.author.isVip),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: post.author.avatarUrl != null
                ? Image.network(
                    post.author.avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildAvatarFallback(post.author),
                  )
                : _buildAvatarFallback(post.author),
          ),
        ),
        
        const SizedBox(width: AppConstants.spacingM),
        
        // Author Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    post.author.roleBadgeEmoji,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    post.author.name,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.getRoleColor(post.author.role.name, isVip: post.author.isVip),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.getRoleColor(post.author.role.name, isVip: post.author.isVip)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      post.author.roleDisplayName,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.getRoleColor(post.author.role.name, isVip: post.author.isVip),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 4),
              
              Row(
                children: [
                  Text(
                    post.timeAgo,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  if (post.isEdited) ...[
                    const SizedBox(width: 8),
                    Text(
                      '• edited',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildAvatarFallback(dynamic author) {
    return Container(
      color: AppColors.getRoleColor(author.role.name, isVip: author.isVip)
          .withValues(alpha: 0.2),
      child: Center(
        child: Text(
          author.name[0].toUpperCase(),
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.getRoleColor(author.role.name, isVip: author.isVip),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  Widget _buildAttachments(Post post) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: post.attachments.length,
        itemBuilder: (context, index) {
          final attachment = post.attachments[index];
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: AppConstants.spacingM),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.attachment,
                  size: 48,
                  color: Colors.grey[600],
                ),
                const SizedBox(height: AppConstants.spacingS),
                Text(
                  attachment.filename,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildPostActions(Post post) {
    return Row(
      children: [
        // Upvote
        _buildActionButton(
          icon: Icons.thumb_up_outlined,
          count: post.upvotes,
          label: 'upvotes',
          color: AppColors.likeGreen,
          onPressed: () => _handleVote(post, true),
        ),
        
        const SizedBox(width: AppConstants.spacingL),
        
        // Downvote
        _buildActionButton(
          icon: Icons.thumb_down_outlined,
          count: post.downvotes,
          label: 'downvotes',
          color: AppColors.dislikeRed,
          onPressed: () => _handleVote(post, false),
        ),
        
        const SizedBox(width: AppConstants.spacingL),
        
        // Replies
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          count: post.replies.length,
          label: 'replies',
          onPressed: () => _startReply(post),
        ),
        
        const Spacer(),
        
        // Views
        Row(
          children: [
            Icon(
              Icons.visibility_outlined,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              '${post.metadata.views}',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required String label,
    VoidCallback? onPressed,
    Color? color,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: color ?? Colors.grey[600],
            ),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: color ?? Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildReactionsDisplay(Post post) {
    final topReactions = post.topReactions;
    
    return Wrap(
      spacing: AppConstants.spacingS,
      children: topReactions.map((reaction) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(reaction.key, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              reaction.value.toString(),
              style: AppTextStyles.labelSmall,
            ),
          ],
        ),
      )).toList(),
    );
  }
  
  Widget _buildRepliesHeader(int replyCount) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Row(
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: AppConstants.spacingS),
          Text(
            '$replyCount ${replyCount == 1 ? 'Reply' : 'Replies'}',
            style: AppTextStyles.titleSmall.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReplyItem(Post reply, {required int depth}) {
    final maxDepth = 4; // Maximum nesting depth
    final actualDepth = depth.clamp(0, maxDepth);
    
    return Container(
      margin: EdgeInsets.only(
        left: AppConstants.spacingM + (actualDepth * 20),
        right: AppConstants.spacingM,
        bottom: AppConstants.spacingS,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thread indicator
          if (actualDepth > 0) ...[
            Container(
              width: 2,
              height: 40,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              margin: const EdgeInsets.only(right: AppConstants.spacingS),
            ),
          ],
          
          // Reply content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reply header
                  Row(
                    children: [
                      Text(
                        reply.author.roleBadgeEmoji,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        reply.author.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.getRoleColor(reply.author.role.name, isVip: reply.author.isVip),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        reply.timeAgo,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Reply actions
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_horiz,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'reply',
                            child: ListTile(
                              leading: Icon(Icons.reply, size: 16),
                              title: Text('Reply'),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'report',
                            child: ListTile(
                              leading: Icon(Icons.flag_outlined, size: 16),
                              title: Text('Report'),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                        onSelected: (value) => _handleReplyAction(value, reply),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppConstants.spacingS),
                  
                  // Reply content
                  Text(
                    reply.content,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                  
                  // Reply voting
                  if (reply.netVotes != 0) ...[
                    const SizedBox(height: AppConstants.spacingS),
                    Row(
                      children: [
                        if (reply.upvotes > 0) ...[
                          Icon(
                            Icons.thumb_up,
                            size: 14,
                            color: AppColors.likeGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            reply.upvotes.toString(),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.likeGreen,
                            ),
                          ),
                        ],
                        if (reply.downvotes > 0) ...[
                          if (reply.upvotes > 0) const SizedBox(width: AppConstants.spacingS),
                          Icon(
                            Icons.thumb_down,
                            size: 14,
                            color: AppColors.dislikeRed,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            reply.downvotes.toString(),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.dislikeRed,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _handleVote(Post post, bool isUpvote) async {
    try {
      await ref.read(postVotingProvider.notifier).votePost(
        post.id, 
        isUpvote ? 'up' : 'down'
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to vote: $e')),
      );
    }
  }
  
  void _startReply(Post post) {
    setState(() {
      _replyingToPost = post;
      _showReplyComposer = true;
    });
  }
  
  void _cancelReply() {
    setState(() {
      _showReplyComposer = false;
      _replyingToPost = null;
    });
  }
  
  void _submitReply(String content) async {
    if (_replyingToPost != null) {
      final user = ref.read(currentUserProvider);
      if (user == null) return;
      
      try {
        await ref.read(commentCreationProvider.notifier).createComment(
          postId: _replyingToPost!.id,
          content: content,
          authorId: user.id,
        );
        
        // Refresh the post data to show new comment
        ref.invalidate(postProvider(widget.postId));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post reply: $e')),
        );
      }
    }
    _cancelReply();
  }
  
  void _handleReplyAction(String action, Post reply) {
    switch (action) {
      case 'reply':
        _startReply(reply);
        break;
      case 'report':
        // TODO: Implement report functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report functionality coming soon')),
        );
        break;
    }
  }
  
  void _showPostOptions(BuildContext context, Post post) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Post'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement share functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_border),
              title: const Text('Bookmark'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement bookmark functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: const Text('Report Post'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement report functionality
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Post _createDummyPost() {
    return Post(
      id: 0,
      title: 'Post not found',
      content: 'The requested post could not be found.',
      author: User(
        id: 0,
        username: 'unknown',
        email: 'unknown@example.com',
        displayName: 'Unknown User',
        role: UserRole.user,
        joinedAt: DateTime.now(),
        preferences: const UserPreferences(),
        stats: const UserStats(),
      ),
      forumId: widget.forumId,
      createdAt: DateTime.now(),
      metadata: const PostMetadata(),
      upvotes: 0,
      downvotes: 0,
      reactions: {},
      replies: [],
    );
  }
}
