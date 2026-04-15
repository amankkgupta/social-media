import 'package:flutter/material.dart';
import 'package:myminiblog/viewmodals/login_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});
  @override
  State<LoginPageView> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageView> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _hide = true;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 245, 239, 239),
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
                  const Text("Let's go",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text("Enter your credentials to log in"),

                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: _username,
                      decoration: const InputDecoration(
                        hintText: "eg. Aman Kumar",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: viewModel.isErr ? Colors.red : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            obscureText: _hide,
                            controller: _password,
                            decoration: const InputDecoration(
                              hintText: "eg. password",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() => _hide = !_hide);
                          },
                          icon: Icon(_hide ? Icons.visibility : Icons.visibility_off),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (viewModel.message.isNotEmpty)
                    Text(viewModel.message, style: const TextStyle(color: Colors.red)),

                  Container(
                    alignment: Alignment.centerRight,
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(color: Color.fromARGB(255, 33, 22, 238)),
                    ),
                  ),

                  const SizedBox(height: 10),

                  viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final user = await viewModel.login(
                          _username.text.trim(),
                          _password.text.trim(),
                        );
                        if (user != null && mounted) {
                          Navigator.pushReplacementNamed(context, "/home");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 58, 49, 231),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Login", style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "/signup");
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(color: Color.fromARGB(255, 58, 49, 231)),
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
    );
  }
}
