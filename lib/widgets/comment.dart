import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Comment extends StatefulWidget {
  final int postId, noOfComments;
  const Comment({super.key, required this.postId, required this.noOfComments});
  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  var comments;
  TextEditingController _commentText = TextEditingController();

  void _showComments() {
    showModalBottomSheet(
      clipBehavior: Clip.none,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Comments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(height: 1),
              Flexible(
                child: comments == null
                    ? Center(child: Text("No comment yet"))
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          final author = comment["author"];
                          return Row(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(child: Text("A")),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      author["username"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,

                                      ),
                                    ),
                                    Text(comment["text"]),
                                  ],
                                ),
                              ),
                              Icon(Icons.favorite_border_outlined),
                            ],
                          );
                        },
                      ),
              ),
              Row(
                spacing: 5,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentText,
                      decoration: InputDecoration(
                        hintText: "Add a comment...",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)
                        )
                      ),

                    ),
                  ),
                  ElevatedButton(
                    onPressed: _postComment,
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(15)
                    ),
                    child: const Icon(Icons.send, size: 30,),

                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getComments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final backendUrl = dotenv.env["BACKEND_URL"];
      final url = Uri.parse(
        "$backendUrl/comment/all-comments/${widget.postId}",
      );
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final fetchedcomments = data["comments"];
        setState(() {
          comments = fetchedcomments;
        });
        _showComments();
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _postComment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final backendUrl = dotenv.env["BACKEND_URL"];
      final response = await http.post(
        Uri.parse("$backendUrl/comment/create-comment/${widget.postId}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"text": _commentText.text.trim()}),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.of(context).pushReplacementNamed("/home");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Comment posted successfully")));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("failure")));
    } finally {
      setState(() {
        _commentText.text="";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: Colors.black87),
      onPressed: _getComments,
      child: Row(
        children: [
          Icon(Icons.comment_outlined, size: 25,),
          const SizedBox(width: 6),
          Text("${widget.noOfComments} Comment"),
        ],
      ),
    );
  }
}
