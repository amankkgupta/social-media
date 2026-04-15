import 'package:flutter/foundation.dart';
import 'package:myminiblog/modals/post_model.dart';
import 'package:myminiblog/services/post_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostViewModel extends ChangeNotifier {
  final PostService _postService = PostService();

  List<PostModel> posts = [];
  bool isLoading = false;
  String? username;
  String? error;

  Future<void> loadPosts(int index) async {
    print(index);
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      username = prefs.getString("username");
      switch(index){
        case 0:
          posts = await _postService.fetchPosts();
          break;
        case 1:
          posts = await _postService.fetchMyPosts();
          break;
      }

    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleLike(int postId) async {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = posts[index];
    final wasLiked = post.isLiked;

    post.isLiked = !wasLiked;
    post.likes += wasLiked ? -1 : 1;
    notifyListeners();

    try {
      final action = wasLiked ? 0 : 1;
      await _postService.likePost(postId, action);
    } catch (e) {
      post.isLiked = wasLiked;
      post.likes += wasLiked ? 1 : -1;
      notifyListeners();
    }
  }

}
