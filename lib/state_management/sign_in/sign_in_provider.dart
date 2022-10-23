import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/social_auth/base_auth.dart';

class SignInProvider {
  Future<User?> fetchData(BuildContext context) async {
    return await BaseAuth.signIn(context);
  }
}