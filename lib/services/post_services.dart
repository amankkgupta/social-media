import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:myminiblog/modals/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostService {

  Future<List<PostModel>> fetchPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final backendUrl = dotenv.env["BACKEND_URL"];
    final response = await http.get(
      Uri.parse("$backendUrl/post/all-posts"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final posts = (data["posts"] as List)
          .map((json) => PostModel.fromJson(json))
          .toList();
      return posts;
    } else {
      throw Exception("Failed to load posts");
    }
  }

  Future<bool> createPost({
    required String title,
    required String description,
    required File image,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final backendUrl = dotenv.env["BACKEND_URL"];
    final uri = Uri.parse("$backendUrl/post/create-post");

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title.trim();
    request.fields['text'] = description.trim();

    request.files.add(
      await http.MultipartFile.fromPath('image', image.path),
    );

    var response = await request.send();
    return response.statusCode == 201;
  }

  Future<void> likePost(int postId, int action) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final backendUrl= dotenv.env["BACKEND_URL"];

    final response = await http.post(
      Uri.parse("$backendUrl/post/like"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "post_id": postId,
        "action": action,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update like");
    }
  }

  Future<List<PostModel>> fetchMyPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final backendUrl = dotenv.env["BACKEND_URL"];
    final response = await http.get(
      Uri.parse("$backendUrl/post/my-posts"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final posts = (data["posts"] as List)
          .map((json) => PostModel.fromJson(json))
          .toList();
      return posts;
    } else {
      throw Exception("Failed to load posts");
    }
  }

}
