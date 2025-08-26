import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/post.dart';
import '../post/comments_screen.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onLike;
  final Function(String) onComment;
  final Function(String) onReport;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onReport,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _showComments = false;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Why are you reporting this post?'),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Spam'),
              onTap: () {
                Navigator.pop(context);
                widget.onReport('Spam');
              },
            ),
            ListTile(
              title: const Text('Inappropriate content'),
              onTap: () {
                Navigator.pop(context);
                widget.onReport('Inappropriate content');
              },
            ),
            ListTile(
              title: const Text('Harassment'),
              onTap: () {
                Navigator.pop(context);
                widget.onReport('Harassment');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _submitComment() {
    if (_commentController.text.trim().isNotEmpty) {
      widget.onComment(_commentController.text.trim());
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: widget.post.user?.picture != null
                      ? CachedNetworkImageProvider(widget.post.user!.avatarUrl)
                      : null,
                  child: widget.post.user?.picture == null
                      ? Text(
                          widget.post.user?.username[0].toUpperCase() ?? 'U',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.user?.displayName ?? 'Unknown User',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.post.timeAgo,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const ListTile(
                        leading: Icon(Icons.flag),
                        title: Text('Report'),
                        contentPadding: EdgeInsets.zero,
                      ),
                      onTap: _showReportDialog,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Post title
            if (widget.post.title.isNotEmpty)
              Text(
                widget.post.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (widget.post.title.isNotEmpty) const SizedBox(height: 8),

            // Post content
            if (widget.post.content.isNotEmpty)
              Text(
                widget.post.content,
                style: const TextStyle(fontSize: 16),
              ),
            if (widget.post.content.isNotEmpty) const SizedBox(height: 12),

            // Post image
            if (widget.post.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: widget.post.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            if (widget.post.imageUrl != null) const SizedBox(height: 12),

            // Action buttons
            Row(
              children: [
                IconButton(
                  onPressed: widget.onLike,
                  icon: Icon(
                    widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: widget.post.isLiked ? Colors.red : null,
                  ),
                ),
                Text('${widget.post.votes}'),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(post: widget.post),
                      ),
                    );
                  },
                  icon: const Icon(Icons.comment_outlined),
                ),
                Text('${widget.post.comments}'),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    // Share functionality
                  },
                  icon: const Icon(Icons.share_outlined),
                ),
              ],
            ),

            // Comments section
            if (_showComments) ...[
              const Divider(),
              // Add comment
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _submitComment,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Comments list
              if (widget.post.comments > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentsScreen(post: widget.post),
                        ),
                      );
                    },
                    child: Text(
                      'View all ${widget.post.comments} comments',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              /*...widget.post.comments.map((comment) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: comment.user?.picture != null
                          ? CachedNetworkImageProvider(comment.user!.avatarUrl)
                          : null,
                      child: comment.user?.picture == null
                          ? Text(
                              comment.user?.username[0].toUpperCase() ?? 'U',
                              style: const TextStyle(fontSize: 12),
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.user?.displayName ?? 'Unknown User',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(comment.content),
                            const SizedBox(height: 4),
                            Text(
                              comment.timeAgo,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),*/
            ],
          ],
        ),
      ),
    );
  }
}
