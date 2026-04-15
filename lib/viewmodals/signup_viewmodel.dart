import 'package:flutter/foundation.dart';
import 'package:myminiblog/modals/user_model.dart';
import 'package:myminiblog/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool isErr = false;
  String message = "";

  UserModel? user;

  Future<bool> register({
    required String username,
    required String password,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await _authService.register(username, password);
      final msg = data["message"];
      isLoading = false;

      if (msg == "success") {
        user = UserModel.fromJson(data);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", user!.token);
        await prefs.setString("username", user!.username);
        message = "Registration successful!";
        notifyListeners();
        return true;
      } else if (msg == "missing fields") {
        message = "Missing fields! Please fill all details.";
      } else if (msg == "user already exist") {
        message = "User already exists! Please login.";
      } else {
        message = "Something went wrong.";
      }
    } catch (e) {
      message = "Error: $e";
    }

    isLoading = false;
    notifyListeners();
    return false;
  }
}
