import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("About us", style: TextStyle(
            fontSize: 25, fontWeight: FontWeight.bold
        ),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "About DailyPic",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "DailyPic is a modern social platform designed for people who love sharing moments through pictures and stories. "
                  "It’s a place where users can not only post their favorite images but also accompany them with personal stories, "
                  "thoughts, or experiences for others to read and enjoy.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Key Features",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("- Share Pictures with Stories"),
            Text("- Explore Content"),
            Text("- Interact & Engage"),
            Text("- User-Friendly Interface"),
            SizedBox(height: 16),
            Text(
              "Our Mission",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "DailyPic aims to connect people through the power of images and stories. "
                  "Whether it’s a beautiful sunset, a memorable trip, or a daily moment, every post tells a story that can inspire, entertain, or bring people closer together.",
            ),
          ],
        ),
      ),
    );
  }
}
