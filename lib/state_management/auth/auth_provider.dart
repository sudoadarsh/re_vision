import 'package:firebase_auth/firebase_auth.dart';
import 'package:re_vision/models/auth_in_model.dart';

import '../../utils/social_auth/base_auth.dart';

class AuthProvider {
  Future<User?> fetchData(AuthInModel model) async {
    AuthInModel data = model;
    return model.login
        ? await BaseAuth.login(
            model.context,
            email: model.email,
            password: model.password,
          )
        : await BaseAuth.signIn(
            data.context,
            email: data.email,
            password: data.password,
          );
  }
}
