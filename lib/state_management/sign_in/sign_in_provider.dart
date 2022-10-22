import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:re_vision/utils/google/google_auth.dart';

class SignInProvider {
  Future<User?> fetchData(BuildContext context) async {
    return await GoogleAuth.signIn(context);
  }
}