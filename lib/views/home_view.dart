import 'package:flutter/material.dart';
import 'package:myminiblog/views/createpost_view.dart';
import 'package:myminiblog/views/posts_view.dart';
import 'package:myminiblog/views/profile_view.dart';
import 'package:myminiblog/views/search_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var _currPage = 0;
  final List<Widget> _pages =[
    PostListView(),
    CreatePostView(),
    SearchView(),
    ProfileView(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _currPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currPage,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.create), label: "Create Post"),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person_3_rounded), label: "Profile"),
        ],
      ),
    );
  }
}
