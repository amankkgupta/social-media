import 'package:flutter/cupertino.dart';

class SearchUserModel {
  final String username;
  final int userId;
  SearchUserModel({required this.username, required this.userId});

  factory SearchUserModel.fromJson(Map<String, dynamic> json) {
    return SearchUserModel(username: json["username"], userId: json["userId"]);
  }
}
