import 'package:flutter/material.dart';
import 'package:myminiblog/viewmodals/post_viewmodel.dart';
import 'package:provider/provider.dart';

class Like extends StatelessWidget {
  final int postId;
  const Like({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context);
    final post = postViewModel.posts.firstWhere((p) => p.id == postId);

    return TextButton(
      style: TextButton.styleFrom(foregroundColor: Colors.black87),
      onPressed: () {
        postViewModel.toggleLike(postId);
      },
      child: Row(
        children: [
          Icon(
            Icons.favorite,
            color: post.isLiked ? Colors.red : Colors.grey,
            size: 25,
          ),
          const SizedBox(width: 6),
          Text("${post.likes} Likes"),
        ],
      ),
    );
  }
}
