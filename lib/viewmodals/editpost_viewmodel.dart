import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:myminiblog/services/editpost_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPostViewModel extends ChangeNotifier {
  final EditPostService _postService = EditPostService();

  int? postId;
  String? title;
  String? description;
  String? existingImageUrl;
  bool removeImage = false;
  File? selectedImage;
  bool isLoading = false;
  String? error;

  EditPostViewModel({this.postId});

  Future<void> loadPost() async {
    if (postId == null) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      final post = await _postService.fetchSinglePost(postId!, token);

      // Only for UI: keeping dummy title
      title = "Dummy title";
      description = post.text;
      existingImageUrl = post.imageUrl;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void pickImage(File image) {
    selectedImage = image;
    removeImage = false;
    notifyListeners();
  }

  void removeExistingImage() {
    selectedImage = null;
    removeImage = true;
    notifyListeners();
  }

  Future<bool> updatePost() async {
    if (description == null || description!.trim().isEmpty) {
      error = "Description cannot be empty";
      notifyListeners();
      return false;
    }

    if (postId == null) {
      error = "Post ID is missing";
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      final success = await _postService.updatePost(
        postId!,
        description!.trim(),
        token,
        imageFile: selectedImage,
        removeImage: removeImage,
      );
      return success;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
