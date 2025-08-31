import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../../models/comment.dart';
import '../../models/forum.dart';
import '../../services/api_service.dart';
import 'forum_provider.dart';

// Posts for selected forum using API
final postsProvider = FutureProvider.family<List<Post>, int?>((ref, forumId) async {
  try {
    return await ApiService.getPosts(forumId: forumId);
  } catch (e) {
    // Return empty list if API fails
    return <Post>[];
  }
});

// Posts for currently selected forum
final selectedForumPostsProvider = FutureProvider<List<Post>>((ref) async {
  final selectedForum = ref.watch(selectedForumProvider);
  if (selectedForum == null) {
    // Return all posts if no forum is selected
    return await ApiService.getPosts();
  }
  
  return await ApiService.getPosts(forumId: selectedForum.id);
});

// Comments for a specific post
final postCommentsProvider = FutureProvider.family<List<Comment>, int>((ref, postId) async {
  try {
    return await ApiService.getComments(postId);
  } catch (e) {
    return <Comment>[];
  }
});

// Post creation state
class PostCreationNotifier extends StateNotifier<AsyncValue<Post?>> {
  PostCreationNotifier() : super(const AsyncData(null));

  Future<void> createPost({
    required String title,
    required String content,
    required int forumId,
    required int authorId,
    List<String>? tags,
  }) async {
    state = const AsyncLoading();
    
    try {
      final newPost = await ApiService.createPost(
        title: title,
        content: content,
        forumId: forumId,
        authorId: authorId,
        tags: tags,
      );
      
      state = AsyncData(newPost);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final postCreationProvider = StateNotifierProvider<PostCreationNotifier, AsyncValue<Post?>>((ref) {
  return PostCreationNotifier();
});

// Comment creation state
class CommentCreationNotifier extends StateNotifier<AsyncValue<Comment?>> {
  CommentCreationNotifier() : super(const AsyncData(null));

  Future<void> createComment({
    required int postId,
    required String content,
    required int authorId,
    int? parentId,
  }) async {
    state = const AsyncLoading();
    
    try {
      final newComment = await ApiService.createComment(
        postId: postId,
        content: content,
        authorId: authorId,
        parentId: parentId,
      );
      
      state = AsyncData(newComment);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final commentCreationProvider = StateNotifierProvider<CommentCreationNotifier, AsyncValue<Comment?>>((ref) {
  return CommentCreationNotifier();
});

// Post voting
class PostVotingNotifier extends StateNotifier<Map<int, AsyncValue<Map<String, int>>>> {
  PostVotingNotifier() : super({});

  Future<void> votePost(int postId, String type) async {
    // Set loading state for this post
    state = {
      ...state,
      postId: const AsyncLoading<Map<String, int>>(),
    };

    try {
      final voteData = await ApiService.votePost(postId, type);
      
      // Update state with new vote counts
      state = {
        ...state,
        postId: AsyncData(voteData),
      };
    } catch (e, stackTrace) {
      state = {
        ...state,
        postId: AsyncError(e, stackTrace),
      };
    }
  }

  AsyncValue<Map<String, int>>? getVoteState(int postId) {
    return state[postId];
  }
}

final postVotingProvider = StateNotifierProvider<PostVotingNotifier, Map<int, AsyncValue<Map<String, int>>>>((ref) {
  return PostVotingNotifier();
});

// Post reactions
class PostReactionsNotifier extends StateNotifier<Map<int, AsyncValue<Map<String, int>>>> {
  PostReactionsNotifier() : super({});

  Future<void> reactToPost(int postId, String emoji) async {
    // Set loading state for this post
    state = {
      ...state,
      postId: const AsyncLoading<Map<String, int>>(),
    };

    try {
      final reactions = await ApiService.reactToPost(postId, emoji);
      
      // Update state with new reactions
      state = {
        ...state,
        postId: AsyncData(reactions),
      };
    } catch (e, stackTrace) {
      state = {
        ...state,
        postId: AsyncError(e, stackTrace),
      };
    }
  }

  AsyncValue<Map<String, int>>? getReactionState(int postId) {
    return state[postId];
  }
}

final postReactionsProvider = StateNotifierProvider<PostReactionsNotifier, Map<int, AsyncValue<Map<String, int>>>>((ref) {
  return PostReactionsNotifier();
});

// Individual post provider
final postProvider = FutureProvider.family<Post?, int>((ref, postId) async {
  try {
    return await ApiService.getPost(postId);
  } catch (e) {
    return null;
  }
});

// Helper to extract hashtags from content
List<String> extractHashtags(String content) {
  final RegExp hashtagRegExp = RegExp(r'#\w+');
  final matches = hashtagRegExp.allMatches(content);
  return matches.map((match) => match.group(0)!.substring(1)).toList();
}

// Provider to check if posts are loading
final postsLoadingProvider = Provider<bool>((ref) {
  final selectedForum = ref.watch(selectedForumProvider);
  final postsAsync = ref.watch(selectedForumPostsProvider);
  
  return postsAsync.isLoading;
});

// Provider to get post count for a forum
final forumPostCountProvider = FutureProvider.family<int, int>((ref, forumId) async {
  try {
    final posts = await ApiService.getPosts(forumId: forumId);
    return posts.length;
  } catch (e) {
    return 0;
  }
});

// Search posts provider (basic text search)
final searchPostsProvider = FutureProvider.family<List<Post>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  
  try {
    // Get all posts and filter by title/content
    final allPosts = await ApiService.getPosts();
    final searchQuery = query.toLowerCase();
    
    return allPosts.where((post) {
      return post.title.toLowerCase().contains(searchQuery) ||
             post.content.toLowerCase().contains(searchQuery) ||
             post.tags.any((tag) => tag.toLowerCase().contains(searchQuery));
    }).toList();
  } catch (e) {
    return [];
  }
});