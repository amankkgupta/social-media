import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:myminiblog/services/post_services.dart';

class CreatePostViewModel extends ChangeNotifier {
  final PostService _postService = PostService();


  bool isLoading = false;
  String? errorMessage;

  Future<bool> createPost({
    required String title,
    required String description,
    required File image,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _postService.createPost(
        title: title,
        description: description,
        image: image,
      );
      return success;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
