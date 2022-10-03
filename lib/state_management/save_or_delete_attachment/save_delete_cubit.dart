// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

part 'save_delete_state.dart';

class SaveDeleteCubit extends Cubit<SaveDeleteState> {
  SaveDeleteCubit() : super(SaveDeleteState());

  void changeState() => emit (SaveDeleteState(isLongPressed: !state.isLongPressed));
}
