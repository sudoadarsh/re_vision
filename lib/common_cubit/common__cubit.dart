// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'common_cubit_repo.dart';


part 'common__state.dart';

class CommonCubit extends Cubit<CommonCubitState> {
  final CommonCubitRepo baseCubitRepo;

  CommonCubit(this.baseCubitRepo) : super(CommonCubitInitial());

  void fetchData({var data}) async {
    try {
      emit(CommonCubitStateLoading());
      List fetchedData = await baseCubitRepo.fetchData(data: data);
      emit(CommonCubitStateLoaded(data: fetchedData));
    } catch (e) {
      emit(CommonCubitStateError(error: e.toString()));
    }
  }
}
