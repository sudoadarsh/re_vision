// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:re_vision/common_button_cubit/common_button_repo.dart';
part 'common_button_state.dart';

class CommonButtonCubit extends Cubit<CommonButtonState> {
  final CommonButtonCubitRepo buttonRepo;

  CommonButtonCubit(this.buttonRepo) : super(CommonButtonInitial());

  void fetchData<T>({data}) async {
    try {
      emit (CommonButtonLoading());
      final T? successData = await buttonRepo.fetchData(data: data);
      emit (CommonButtonSuccess(data: successData));
    } catch (e) {
      emit (CommonButtonFailure(error: e.toString()));
    }
  }
}
