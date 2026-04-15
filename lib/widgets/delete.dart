import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DeleteDialog extends StatefulWidget {
  final int postId;
  const DeleteDialog({super.key, required this.postId});
  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  bool isDeleting = false;

  Future<void> deletePost() async {
    setState(() => isDeleting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final backendUrl = dotenv.env["BACKEND_URL"];

      final response = await http.delete(
        Uri.parse("$backendUrl/post/delete-post/${widget.postId}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pop(context, true);
          Navigator.pushReplacementNamed(context, "/home");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Post deleted successfully"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            )
          );
        }
      } else {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("failed"))
          );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context, false);
    } finally {
      if (mounted) setState(() => isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          width: double.infinity,
          child: Column(
            children: [
              Image.asset("assets/icons/warning.png", height: 60),

              const SizedBox(height: 12),
              const Text(
                "Delete this Post",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("Are you sure you want to delete this post?"),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 97, 177),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: isDeleting ? null : deletePost,
                  child: isDeleting
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text("Yes"),
                ),
              ),

              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Close button
        Positioned(
          top: -60,
          right: 5,
          child: FloatingActionButton.small(
            elevation: 0,
            backgroundColor: Colors.white70,
            shape: const CircleBorder(),
            onPressed: () => Navigator.pop(context, false),
            child: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }
}
