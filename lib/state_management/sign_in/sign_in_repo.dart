import 'package:re_vision/common_button_cubit/common_button_repo.dart';
import 'package:re_vision/state_management/sign_in/sign_in_provider.dart';

class SignInRepo extends CommonButtonCubitRepo {
  @override
  fetchData({data}) {
    return SignInProvider().fetchData(data);
  }
}