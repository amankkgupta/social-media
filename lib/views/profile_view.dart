import 'package:flutter/material.dart';
import 'package:myminiblog/widgets/logout.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(209, 237, 229, 229),
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white70,
                ),
                child: Column(
                  spacing: 5,
                  children: [
                    InkWell(
                      onTap: () => print("profile"),
                      child: Row(
                        children: [
                          Icon(Icons.person_2_outlined),
                          SizedBox(width: 10),
                          Text("My Profile"),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_right_outlined),
                        ],
                      ),
                    ),
                    Divider(thickness: 1),
                    InkWell(
                      onTap: () => print("password"),
                      child: Row(
                        children: [
                          Icon(Icons.tag_outlined),
                          SizedBox(width: 10),
                          Text("Change password"),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_right_outlined),
                        ],
                      ),
                    ),
                    Divider(thickness: 1),
                    InkWell(
                      onTap: () => print("setting"),
                      child: Row(
                        children: [
                          Icon(Icons.settings_outlined),
                          SizedBox(width: 10),
                          Text("Settings & Preferences"),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_right_outlined),
                        ],
                      ),
                    ),
                    Divider(thickness: 1),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, "/support"),
                      child: Row(
                        children: [
                          Icon(Icons.support_agent_outlined),
                          SizedBox(width: 10),
                          Text("Support"),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_right_outlined),
                        ],
                      ),
                    ),
                    Divider(thickness: 1),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, "/aboutus"),
                      child: Row(
                        children: [
                          Icon(Icons.people_outlined),
                          SizedBox(width: 10),
                          Text("About us"),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_right_outlined),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white70,
            ),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return LogoutPopup(
                      onConfirm: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          "/login",
                              (route) => false,
                        );
                      },
                      onCancel: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              child: Row(
                children: [
                  Icon(Icons.logout_outlined),
                  SizedBox(width: 10),
                  Text("Log out"),
                  Spacer(),
                  Icon(Icons.keyboard_arrow_right_outlined),
                ],
              ),
            ),
          ),

          Text("Version 1.13.34"),
        ],
      ),
    );
  }
}
