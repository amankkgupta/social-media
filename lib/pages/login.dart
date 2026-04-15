import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isLoading = false;
  bool _isErr = false;
  String _message = "";
  bool _hide = true;

  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final backendUrl = dotenv.env["BACKEND_URL"];
      final res = await http.post(
        Uri.parse("$backendUrl/auth/login"),
        body: {
          "username": _username.text.trim(),
          "password": _password.text.trim(),
        },
      );
      setState(() {
        _isLoading = false;
      });
      final data = jsonDecode(res.body);
      final message = data["message"];
      if (message == "success") {
        final token = data["token"];
        final username = data["username"];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);
        await prefs.setString("username", username);
        Navigator.pushReplacementNamed(context, "/home");
      } else if (message == "missing fields") {
        setState(() {
          _message = "Missing fields ! please fill all details";
        });
      } else if (message == "user not exist") {
        setState(() {
          _message = "User not exist ! please register";
        });
      } else if (message == "wrong password") {
        setState(() {
          _isErr = true;
        });
      }
    } catch (e) {
      setState(() {
        _message = "Something went wrong, Please try later";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(236, 245, 239, 239),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/appreciatelogo.png"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's go",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Enter your credentials to log in"),

                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Enter your username"),
                          TextField(
                            controller: _username,
                            decoration: InputDecoration(
                              hintText: "eg. Aman Kumar",
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isErr ? Colors.red : Colors.transparent,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Enter your password"),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  obscureText: _hide,
                                  controller: _password,
                                  decoration: InputDecoration(
                                    hintText: "eg. password",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              _hide
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _hide = !_hide;
                                        });
                                      },
                                      icon: Icon(Icons.visibility),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _hide = !_hide;
                                        });
                                      },
                                      icon: Icon(Icons.visibility_off),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    Text("$_message", style: TextStyle(color: Colors.red)),

                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 33, 22, 238),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    _isLoading
                        ? Center(child: const CircularProgressIndicator())
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  58,
                                  49,
                                  231,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ), // rounded corners
                                ),
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, "/signup");
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 58, 49, 231),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
