import 'package:re_vision/common_button_cubit/common_button_repo.dart';

import 'auth_provider.dart';

class AuthRepo extends CommonButtonCubitRepo {
  @override
  fetchData({data}) {
    return AuthProvider().fetchData(data);
  }
}