import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myminiblog/viewmodals/post_viewmodel.dart';
import 'package:provider/provider.dart';

class PostCategory extends StatefulWidget {
  const PostCategory({super.key});

  @override
  State<PostCategory> createState() => _PostCategoryState();
}

class _PostCategoryState extends State<PostCategory> {
  int selectedIndex = 0;

  void _onCategorySelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    final viewModel = Provider.of<PostViewModel>(context, listen: false);
    viewModel.loadPosts(index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // horizontal scrolling
        child: Row(
          children: [
            _buildCategoryButton("Recent Posts", 0),
            const SizedBox(width: 10),
            _buildCategoryButton("My Post", 1),
            const SizedBox(width: 10),
            _buildCategoryButton("Trending", 2),
            const SizedBox(width: 10),
            _buildCategoryButton("Popular", 3),
            const SizedBox(width: 10),
            _buildCategoryButton("Most liked", 4),
          ],
        ),
      ),
    );
  }


  Widget _buildCategoryButton(String text, int index) {
    final bool isSelected = selectedIndex == index;

    return ElevatedButton(
      onPressed: () => _onCategorySelected(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
