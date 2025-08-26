import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../models/post.dart';
import '../../services/api_service.dart';
import '../widgets/post_card.dart';

class CategoryPostsScreen extends StatefulWidget {
  final Category category;

  const CategoryPostsScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryPostsScreen> createState() => _CategoryPostsScreenState();
}

class _CategoryPostsScreenState extends State<CategoryPostsScreen> {
  final ApiService _apiService = ApiService();
  List<Post> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategoryPosts();
  }

  Future<void> _loadCategoryPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // For now, load all posts and filter by category
      // In a real app, the API would support category filtering
      final allPosts = await _apiService.getPosts();
      final categoryPosts = allPosts.where((post) => 
        post.categoryId == widget.category.id
      ).toList();
      
      setState(() {
        _posts = categoryPosts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(widget.category.color);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
      ),
      body: Column(
        children: [
          // Category header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              border: Border(
                bottom: BorderSide(
                  color: color.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        _getCategoryIcon(widget.category.name),
                        color: color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          Text(
                            widget.category.description,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${_posts.length} posts in this category',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Posts list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: $_error'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadCategoryPosts,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _posts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.article_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No posts in this category yet',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Be the first to create a post!',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadCategoryPosts,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _posts.length,
                              itemBuilder: (context, index) {
                                final post = _posts[index];
                                return PostCard(
                                  post: post,
                                  onLike: () {
                                    // Handle like
                                  },
                                  onComment: (comment) {
                                    // Handle comment
                                  },
                                  onReport: (reason) {
                                    // Handle report
                                  },
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Theme.of(context).primaryColor;
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'general':
        return Icons.forum;
      case 'community':
        return Icons.people;
      case 'support':
        return Icons.help_outline;
      case 'announcements':
        return Icons.campaign;
      case 'feedback':
        return Icons.feedback;
      default:
        return Icons.category;
    }
  }
}
