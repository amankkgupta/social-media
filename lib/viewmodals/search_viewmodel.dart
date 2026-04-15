import 'package:flutter/material.dart';
import 'package:myminiblog/modals/search_user_model.dart';
import 'package:myminiblog/services/users_services.dart';

class SearchViewModel extends ChangeNotifier {
  final UserServices _userServices = UserServices();

  bool isLoading = false;
  List<SearchUserModel> users = [];
  String errorMessage = "";
  String currQuery="";

  Future<void> searchUser(String query) async {
    isLoading = true;
    errorMessage = "";
    currQuery=query;
    notifyListeners();

    try {
      final result = await _userServices.searchUser(query);
      users = result;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch(){
    users=[];
    currQuery="";
    notifyListeners();
  }
}
