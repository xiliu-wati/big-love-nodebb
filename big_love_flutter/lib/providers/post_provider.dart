import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class PostProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Post> _posts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMorePosts = true;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMorePosts => _hasMorePosts;

  Future<void> loadPosts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMorePosts = true;
      _posts.clear();
    }

    if (_isLoading || _isLoadingMore || !_hasMorePosts) return;

    if (_currentPage == 1) {
      _setLoading(true);
    } else {
      _setLoadingMore(true);
    }

    _clearError();

    try {
      final newPosts = await _apiService.getPosts(
        page: _currentPage,
        limit: 20,
      );

      if (newPosts.isEmpty) {
        _hasMorePosts = false;
      } else {
        if (refresh) {
          _posts = newPosts;
        } else {
          _posts.addAll(newPosts);
        }
        _currentPage++;
      }
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
    _setLoadingMore(false);
  }

  Future<bool> createPost(String title, String content, {String? imagePath}) async {
    _setLoading(true);
    _clearError();

    try {
      String? imageUrl;
      if (imagePath != null) {
        imageUrl = await _apiService.uploadImage(imagePath);
      }

      final newPost = await _apiService.createPost(title, content, imageUrl: imageUrl);
      
      // Add the new post to the beginning of the list
      _posts.insert(0, newPost);
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> likePost(int postIndex) async {
    if (postIndex < 0 || postIndex >= _posts.length) return;

    final post = _posts[postIndex];
    
    try {
      await _apiService.likePost(post.tid);
      
      // Update the post locally
      _posts[postIndex] = post.copyWith(
        isLiked: !post.isLiked,
        votes: post.isLiked ? post.votes - 1 : post.votes + 1,
      );
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<bool> addComment(int postIndex, String content) async {
    if (postIndex < 0 || postIndex >= _posts.length) return false;

    final post = _posts[postIndex];
    
    try {
      await _apiService.addComment(post.tid, content);
      
      // Reload the specific post to get updated comments
      final updatedPost = await _apiService.getPost(post.tid);
      _posts[postIndex] = updatedPost;
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<void> reportPost(int postIndex, String reason) async {
    if (postIndex < 0 || postIndex >= _posts.length) return;

    final post = _posts[postIndex];
    
    try {
      await _apiService.reportContent(post.tid, 'topic', reason);
      // Show success message or handle UI feedback
    } catch (e) {
      _setError(e.toString());
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingMore(bool loading) {
    _isLoadingMore = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

  void refresh() {
    loadPosts(refresh: true);
  }
}
