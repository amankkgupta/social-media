import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:myminiblog/widgets/comment.dart';
import 'package:myminiblog/widgets/threemenu.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _HomePageState();
}

class _HomePageState extends State<PostPage> {
  List posts = [];
  bool isLoading = true;
  String? username;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      username = prefs.getString("username");
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
        posts = data["posts"];
      } else {
        throw Exception("Failed to load posts");
      }
    } catch (e) {
      // setState(() {
      //   isLoading = false;
      // });
    } finally {
      setState(() {
        isLoading=false;
      });
    }
  }

  String formatDate(String dateTime) {
    try {
      final dt = DateTime.parse(dateTime);
      return "${dt.day}/${dt.month}/${dt.year}";
    } catch (_) {
      return dateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(209, 237, 229, 229),
      appBar: AppBar(
        title: Text(
          "Hi ! $username",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.notifications_none_outlined),
          ),
        ],
        centerTitle: false,
        elevation: 20,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 12, left: 12),
                  child: Text(
                    "Recent Posts",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                posts.length == 0
                    ? Center(child: Text("No Posts Yets !"))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            final firstLetter = post["username"][0]
                                .toUpperCase();

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row 1
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          child: Text(
                                            firstLetter,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              post["username"],
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              formatDate(post["created_at"]),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Threemenu(postId: post["id"], myPost: username==post["username"],),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Image.network(
                                      post["image_url"],
                                      fit: BoxFit.cover,
                                      height: 200,
                                      width: double.infinity,
                                    ),
                                    const SizedBox(height: 12),

                                    // Row 3: Actions
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.favorite_border,
                                          ),
                                          onPressed: () {},
                                        ),
                                        Text("${post["likes"]} Likes"),
                                        Comment(
                                          postId: post["id"],
                                          noOfComments: post["noofcomments"],
                                        ),
                                        Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.share),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.bookmark_border,
                                          ),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                    Text(
                                      post["text"],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
    );
  }
}
