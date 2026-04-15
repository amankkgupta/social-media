import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditPost extends StatefulWidget {
  const EditPost({super.key});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  File? _selectedImage;
  String? _existingImageUrl;
  bool _removeImage = false;
  int? _postId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _postId = args["postId"];
    _fetchPost();
  }

  Future<void> _fetchPost() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final backendUrl = dotenv.env["BACKEND_URL"];
      final uri = Uri.parse("$backendUrl/post/$_postId");

      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _title.text = "Dummy title"; // keep UI only
          _description.text = data["text"] ?? "";
          _existingImageUrl = data["image"];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load post")),
        );
      }
    } catch (e) {
      print("Error fetching post: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _removeImage = false;
      });
    }
  }

  Future<void> _updatePost() async {
    if (_description.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Description cannot be empty")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final backendUrl = dotenv.env["BACKEND_URL"];
      final uri = Uri.parse("$backendUrl/post/update-post/$_postId");

      var request = http.MultipartRequest("PUT", uri);
      request.headers["Authorization"] = "Bearer $token";

      request.fields["text"] = _description.text.trim();

      if (_removeImage) {
        request.fields["remove_image"] = "true";
      }

      if (_selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath("image", _selectedImage!.path),
        );
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Post updated successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Something went wrong")),
        );
      }
    } catch (e) {
      print("Error updating post: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildImageSection() {
    if (_selectedImage != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.file(
              _selectedImage!,
              height: 100,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: -20,
            right: -20,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                  _removeImage = true;
                });
              },
              icon: const Icon(Icons.cancel_outlined, color: Colors.red),
            ),
          ),
        ],
      );
    }

    if (_existingImageUrl != null && !_removeImage) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              _existingImageUrl!,
              height: 100,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: -20,
            right: -20,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _removeImage = true;
                });
              },
              icon: const Icon(Icons.cancel_outlined, color: Colors.red),
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_file_outlined),
          const Text("Upload image"),
          const Spacer(),
          TextButton(
            onPressed: _pickImage,
            child: const Text("Upload", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(209, 237, 229, 229),
      appBar: AppBar(
        title: const Text(
          "Edit Post",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        elevation: 10,
        centerTitle: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text("Share your thoughts with the community"),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Title"),
                  TextField(
                    controller: _title,
                    decoration: const InputDecoration(
                      hintText: "eg. Dive into the perfect",
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Description"),
                  TextField(
                    controller: _description,
                    decoration: const InputDecoration(
                      hintText: "eg. Dive into the perfect",
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildImageSection(),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updatePost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 58, 49, 231),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  "Update Post",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
