import 'package:flutter/foundation.dart';
import 'package:myminiblog/modals/user_model.dart';
import 'package:myminiblog/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isLoading = false;
  bool isErr = false;
  String message = "";

  Future<UserModel?> login(String username, String password) async {
    try {
      isLoading = true;
      isErr = false;
      message = "";
      notifyListeners();

      final user = await _authService.login(username, password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", user!.token);
      await prefs.setString("username", user.username);

      return user;
    } catch (e) {
      if (e.toString().contains("wrong password")) {
        isErr = true;
      }
      message = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
