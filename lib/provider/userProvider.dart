import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _email = "";
  String _password = "";
  String _name = "";

  String get email => _email;
  String get password => _password;
  String get univ => _name;

  void set email(String input_email) {
    _email = input_email;
    notifyListeners();
  }

  void set password(String input_password) {
    _password = input_password;
    notifyListeners();
  }

  void set univ(String input_name) {
    _name = input_name;
    notifyListeners();
  }
}
