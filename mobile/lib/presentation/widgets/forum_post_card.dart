import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../providers/posts_provider.dart';

class ForumPostCard extends ConsumerStatefulWidget {
  final Post post;
  final VoidCallback? onTap;
  final bool isInThread;
  
  const ForumPostCard({
    super.key,
    required this.post,
    this.onTap,
    this.isInThread = false,
  });

  @override
  ConsumerState<ForumPostCard> createState() => _ForumPostCardState();
}

class _ForumPostCardState extends ConsumerState<ForumPostCard> 
    with SingleTickerProviderStateMixin {
  bool _showReplies = false;
  bool _showReactions = false;
  final TextEditingController _replyController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationMedium,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _replyController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSystemPost = widget.post.type == PostType.system;
    final isPinned = widget.post.isPinned;
    final isAnnouncement = widget.post.type == PostType.announcement;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: widget.isInThread ? AppConstants.spacingM + 20 : AppConstants.spacingM,
        vertical: AppConstants.spacingS,
      ),
      child: Material(
        color: _getCardColor(theme),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        elevation: widget.isInThread ? 1 : 2,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post Header
                _buildPostHeader(theme),
                
                if (widget.post.title.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.spacingM),
                  _buildPostTitle(theme),
                ],
                
                const SizedBox(height: AppConstants.spacingM),
                
                // Post Content
                _buildPostContent(theme),
                
                // Media Attachments
                if (widget.post.hasAttachments) ...[
                  const SizedBox(height: AppConstants.spacingM),
                  _buildAttachments(),
                ],
                
                const SizedBox(height: AppConstants.spacingM),
                
                // Post Statistics and Actions
                _buildPostActions(theme),
                
                // Reactions Row
                if (widget.post.totalReactions > 0) ...[
                  const SizedBox(height: AppConstants.spacingS),
                  _buildReactionsRow(theme),
                ],
                
                // Replies Section
                if (widget.post.hasReplies && !widget.isInThread) ...[
                  const SizedBox(height: AppConstants.spacingM),
                  _buildRepliesSection(theme),
                ],
                
                // Reply Input (when expanded)
                if (_showReplies && !widget.isInThread) ...[
                  const SizedBox(height: AppConstants.spacingM),
                  _buildReplyInput(theme),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Color _getCardColor(ThemeData theme) {
    if (widget.post.isPinned) {
      return theme.colorScheme.primary.withValues(alpha: 0.05);
    }
    if (widget.post.type == PostType.announcement) {
      return AppColors.warningOrange.withValues(alpha: 0.05);
    }
    if (widget.post.type == PostType.system) {
      return theme.colorScheme.surfaceVariant;
    }
    return theme.cardColor;
  }
  
  Widget _buildPostHeader(ThemeData theme) {
    return Row(
      children: [
        // Author Avatar
        _buildUserAvatar(widget.post.author),
        
        const SizedBox(width: AppConstants.spacingM),
        
        // Author Info and Post Meta
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Username with role
                  _buildUsername(theme, widget.post.author),
                  
                  const SizedBox(width: AppConstants.spacingS),
                  
                  // Post indicators
                  if (widget.post.isPinned) ...[
                    Icon(
                      Icons.push_pin,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: AppConstants.spacingXS),
                  ],
                  
                  if (widget.post.type == PostType.announcement) ...[
                    Icon(
                      Icons.campaign,
                      size: 14,
                      color: AppColors.warningOrange,
                    ),
                    const SizedBox(width: AppConstants.spacingXS),
                  ],
                ],
              ),
              
              const SizedBox(height: 2),
              
              // Post timestamp and metadata
              Row(
                children: [
                  Text(
                    timeago.format(widget.post.createdAt),
                    style: AppTextStyles.timestamp.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  
                  if (widget.post.isEdited) ...[
                    const SizedBox(width: AppConstants.spacingS),
                    Text(
                      '• edited',
                      style: AppTextStyles.timestamp.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  
                  if (widget.post.tags.isNotEmpty) ...[
                    const SizedBox(width: AppConstants.spacingS),
                    ...widget.post.tags.take(2).map((tag) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '#$tag',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )),
                  ],
                ],
              ),
            ],
          ),
        ),
        
        // Post Menu
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_horiz,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'share',
              child: ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'bookmark',
              child: ListTile(
                leading: Icon(Icons.bookmark_border),
                title: Text('Bookmark'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'report',
              child: ListTile(
                leading: Icon(Icons.flag_outlined),
                title: Text('Report'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
          onSelected: (value) => _handlePostAction(value),
        ),
      ],
    );
  }
  
  Widget _buildUserAvatar(User user) {
    return Container(
      width: AppConstants.avatarM,
      height: AppConstants.avatarM,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.getRoleColor(user.role.name, isVip: user.isVip),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: user.avatarUrl != null
            ? CachedNetworkImage(
                imageUrl: user.avatarUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.person),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.person),
                ),
              )
            : Container(
                color: AppColors.getRoleColor(user.role.name, isVip: user.isVip)
                    .withValues(alpha: 0.1),
                child: Center(
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: AppTextStyles.username.copyWith(
                      color: AppColors.getRoleColor(user.role.name, isVip: user.isVip),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
  
  Widget _buildUsername(ThemeData theme, User user) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          user.roleBadgeEmoji,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(width: 4),
        Text(
          user.name,
          style: AppTextStyles.getUsernameStyle(
            user.role.name,
            isVip: user.isVip,
          ).copyWith(
            color: AppColors.getRoleColor(user.role.name, isVip: user.isVip),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          user.roleDisplayName,
          style: AppTextStyles.rolebadge.copyWith(
            color: AppColors.getRoleColor(user.role.name, isVip: user.isVip),
          ),
        ),
      ],
    );
  }
  
  Widget _buildPostTitle(ThemeData theme) {
    return Text(
      widget.post.title,
      style: AppTextStyles.getPostTitleStyle(widget.post.isPinned).copyWith(
        color: theme.colorScheme.onSurface,
      ),
    );
  }
  
  Widget _buildPostContent(ThemeData theme) {
    return Text(
      widget.post.displayContent,
      style: AppTextStyles.bodyLarge.copyWith(
        color: theme.colorScheme.onSurface,
        height: 1.5,
      ),
    );
  }
  
  Widget _buildAttachments() {
    if (widget.post.attachments.isEmpty) return const SizedBox.shrink();
    
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.post.attachments.length,
        itemBuilder: (context, index) {
          final attachment = widget.post.attachments[index];
          
          if (attachment.isImage) {
            return Padding(
              padding: const EdgeInsets.only(right: AppConstants.spacingS),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
                child: CachedNetworkImage(
                  imageUrl: attachment.url,
                  width: 150,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            );
          }
          
          return Container(
            width: 150,
            padding: const EdgeInsets.all(AppConstants.spacingM),
            margin: const EdgeInsets.only(right: AppConstants.spacingS),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(AppConstants.radiusS),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getFileIcon(attachment.type),
                  size: 32,
                  color: Colors.grey[600],
                ),
                const SizedBox(height: AppConstants.spacingS),
                Text(
                  attachment.filename,
                  style: AppTextStyles.bodySmall,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppConstants.spacingXS),
                Text(
                  attachment.displaySize,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildPostActions(ThemeData theme) {
    return Row(
      children: [
        // Upvote
        _buildVoteButton(
          icon: Icons.thumb_up_outlined,
          count: widget.post.upvotes,
          isActive: false, // TODO: Implement user vote state
          onPressed: () => _handleVote(true),
          color: AppColors.likeGreen,
        ),
        
        const SizedBox(width: AppConstants.spacingL),
        
        // Downvote
        _buildVoteButton(
          icon: Icons.thumb_down_outlined,
          count: widget.post.downvotes,
          isActive: false, // TODO: Implement user vote state
          onPressed: () => _handleVote(false),
          color: AppColors.dislikeRed,
        ),
        
        const SizedBox(width: AppConstants.spacingL),
        
        // Replies
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          count: widget.post.replies.length,
          label: 'replies',
          onPressed: () {
            if (!widget.isInThread) {
              setState(() {
                _showReplies = !_showReplies;
                if (_showReplies) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              });
            }
          },
        ),
        
        const SizedBox(width: AppConstants.spacingL),
        
        // Views
        _buildActionButton(
          icon: Icons.visibility_outlined,
          count: widget.post.metadata.views,
          label: 'views',
          onPressed: null,
        ),
        
        const Spacer(),
        
        // Reactions toggle
        IconButton(
          onPressed: () {
            setState(() {
              _showReactions = !_showReactions;
            });
          },
          icon: Icon(
            Icons.add_reaction_outlined,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          tooltip: 'React',
        ),
      ],
    );
  }
  
  Widget _buildVoteButton({
    required IconData icon,
    required int count,
    required bool isActive,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? color : Colors.grey[600],
            ),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: isActive ? color : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required String label,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.grey[600],
            ),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildReactionsRow(ThemeData theme) {
    final topReactions = widget.post.topReactions;
    
    return Wrap(
      spacing: AppConstants.spacingS,
      children: [
        ...topReactions.map((reaction) => InkWell(
          onTap: () => _handleReaction(reaction.key),
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  reaction.key,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 4),
                Text(
                  reaction.value.toString(),
                  style: AppTextStyles.reactionCount.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        )),
        
        if (_showReactions) ...[
          const SizedBox(width: AppConstants.spacingS),
          _buildQuickReactions(),
        ],
      ],
    );
  }
  
  Widget _buildQuickReactions() {
    const quickEmojis = ['👍', '👎', '❤️', '😂', '😮', '🔥'];
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: quickEmojis.map((emoji) => InkWell(
        onTap: () => _handleReaction(emoji),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(emoji, style: const TextStyle(fontSize: 16)),
        ),
      )).toList(),
    );
  }
  
  Widget _buildRepliesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.post.replies.isNotEmpty) ...[
          Text(
            'Replies (${widget.post.replies.length})',
            style: AppTextStyles.titleSmall.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppConstants.spacingS),
          ...widget.post.replies.take(3).map((reply) => 
            ForumPostCard(
              post: reply,
              isInThread: true,
            ),
          ),
          if (widget.post.replies.length > 3) ...[
            TextButton(
              onPressed: () => widget.onTap?.call(),
              child: Text('View all ${widget.post.replies.length} replies'),
            ),
          ],
        ],
      ],
    );
  }
  
  Widget _buildReplyInput(ThemeData theme) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizeTransition(
          sizeFactor: _animation,
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppConstants.radiusS),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _replyController,
                  decoration: const InputDecoration(
                    hintText: 'Write a reply...',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  maxLines: 3,
                  minLines: 1,
                ),
                const SizedBox(height: AppConstants.spacingS),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showReplies = false;
                          _animationController.reverse();
                        });
                        _replyController.clear();
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    ElevatedButton(
                      onPressed: _submitReply,
                      child: const Text('Reply'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  IconData _getFileIcon(type) {
    switch (type.toString()) {
      case 'AttachmentType.document':
        return Icons.description;
      case 'AttachmentType.video':
        return Icons.play_circle_outline;
      case 'AttachmentType.audio':
        return Icons.audiotrack;
      default:
        return Icons.attachment;
    }
  }
  
  void _handleVote(bool isUpvote) {
    final notifier = ref.read(postVotingProvider.notifier);
    notifier.votePost(widget.post.id, isUpvote ? 'up' : 'down');
  }
  
  void _handleReaction(String emoji) {
    final notifier = ref.read(postVotingProvider.notifier);
    ref.read(postReactionsProvider.notifier).reactToPost(widget.post.id, emoji);
    
    setState(() {
      _showReactions = false;
    });
  }
  
  void _handlePostAction(String action) {
    switch (action) {
      case 'share':
        // TODO: Implement share
        break;
      case 'bookmark':
        // TODO: Implement bookmark
        break;
      case 'report':
        // TODO: Implement report
        break;
    }
  }
  
  void _submitReply() {
    if (_replyController.text.trim().isNotEmpty) {
      final notifier = ref.read(postVotingProvider.notifier);
      ref.read(commentCreationProvider.notifier).createComment(
        postId: widget.post.id,
        content: _replyController.text.trim(),
        authorId: 1, // TODO: Get from proper user provider
      );
    // Original call was: notifier?.replyToPost(widget.post.id, _replyController.text.trim());
      
      _replyController.clear();
      setState(() {
        _showReplies = false;
        _animationController.reverse();
      });
    }
  }
}
