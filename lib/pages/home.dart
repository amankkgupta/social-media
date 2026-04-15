import 'package:flutter/material.dart';
import 'package:myminiblog/pages/createpost.dart';
import 'package:myminiblog/pages/posts.dart';
import 'package:myminiblog/pages/profile.dart';
import 'package:myminiblog/pages/search.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _currPage = 0;
  final List<Widget> _pages =[
    PostPage(),
    CreatePost(),
    Search(),
    Profile(),
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
