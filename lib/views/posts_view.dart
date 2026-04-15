import 'package:flutter/material.dart';
import 'package:myminiblog/viewmodals/post_viewmodel.dart';
import 'package:myminiblog/widgets/like.dart';
import 'package:myminiblog/widgets/post_category.dart';
import 'package:provider/provider.dart';
import '../widgets/comment.dart';
import '../widgets/threemenu.dart';
import 'package:intl/intl.dart';

class PostListView extends StatefulWidget {
  const PostListView({super.key});

  @override
  State<PostListView> createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<PostViewModel>(context, listen: false);
      viewModel.loadPosts(0);
    });
  }

  String formatDate(String dateTime) {
    try {
      final dt = DateTime.parse(dateTime);
      return DateFormat("MMM d, yyyy • h:mm a").format(dt);
    } catch (_) {
      return dateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PostViewModel>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(209, 237, 229, 229),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Hi ! ${viewModel.username ?? ''}",
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.notifications_none_outlined),
          ),
        ],
        elevation: 20,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PostCategory(),
          viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.error != null
              ? Center(child: Text("Error: ${viewModel.error}"))
              : viewModel.posts.isEmpty
              ? Expanded(child: const Center(child: Text("No Posts Yet!")))
              : Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.posts.length,
                    itemBuilder: (context, index) {
                      final post = viewModel.posts[index];
                      final firstLetter = post.username[0].toUpperCase();

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row 1
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                        post.username,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        formatDate(post.createdAt),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Threemenu(
                                    postId: post.id,
                                    myPost: viewModel.username == post.username,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Image.network(
                                post.imageUrl,
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity,
                              ),
                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Like(postId: post.id),
                                  Comment(
                                    postId: post.id,
                                    noOfComments: post.noOfComments,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.share),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.bookmark_border),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              Text(
                                post.text,
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
