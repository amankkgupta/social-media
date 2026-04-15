import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../modals/post_model.dart';

class EditPostService {
  final String? backendUrl = dotenv.env["BACKEND_URL"];

  // Fetch single post
  Future<PostModel> fetchSinglePost(int postId, String token) async {
    final uri = Uri.parse("$backendUrl/post/$postId");
    final response = await http.get(uri, headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return PostModel.fromJson(data);
    } else {
      throw Exception("Failed to load post");
    }
  }

  // Update post
  Future<bool> updatePost(
      int postId,
      String text,
      String token, {
        File? imageFile,
        bool removeImage = false,
      }) async {
    final uri = Uri.parse("$backendUrl/post/update-post/$postId");
    var request = http.MultipartRequest("PUT", uri);
    request.headers["Authorization"] = "Bearer $token";

    request.fields["text"] = text;

    if (removeImage) {
      request.fields["remove_image"] = "true";
    }

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath("image", imageFile.path));
    }

    final response = await request.send();

    return response.statusCode == 200;
  }
}
