import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myminiblog/modals/search_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserServices {
  Future<List<SearchUserModel>> searchUser(String query) async {
    final backendUrl= dotenv.env["BACKEND_URL"];
    final pref= await SharedPreferences.getInstance();
    final token = pref.getString("token");

    final uri= Uri.parse("$backendUrl/user/search-user?q=$query");

    final res= await http.get(uri, headers: {
      "Authorization": "Bearer $token",
    });
    if(res.statusCode==200){
      final decoded= jsonDecode(res.body);
      final List<dynamic> data= decoded["data"];
      return data.map((json) => SearchUserModel.fromJson(json)).toList();
    } else {
      throw Exception("failed");
    }
  }
}