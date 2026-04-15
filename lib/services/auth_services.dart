import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:myminiblog/modals/user_model.dart';

class AuthService {

  Future<UserModel?> login(String username, String password) async {
    final backendUrl = dotenv.env["BACKEND_URL"];
    final res = await http.post(
      Uri.parse("$backendUrl/auth/login"),
      body: {
        "username": username,
        "password": password,
      },
    );

    final data = jsonDecode(res.body);
    final message = data["message"];

    if (message == "success") {
      return UserModel.fromJson(data);
    }
    throw Exception(message);
  }

  Future<Map<String, dynamic>> register(String username, String password) async {
    final backendUrl = dotenv.env["BACKEND_URL"];
    final response = await http.post(
      Uri.parse("$backendUrl/auth/register"),
      body: {
        "username": username,
        "password": password,
      },
    );
    return jsonDecode(response.body);
  }
}
