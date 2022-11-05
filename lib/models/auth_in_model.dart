import 'package:flutter/cupertino.dart';

class AuthInModel {
  final BuildContext context;
  final String email;
  final String password;
  final bool login;

  AuthInModel({
    required this.context,
    required this.email,
    required this.password,
    this.login = true
  });
}
