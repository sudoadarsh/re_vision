// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

part 'save_state.dart';

class SaveCubit extends Cubit<SaveState> {
  SaveCubit() : super(SaveState(isSaved: false));

  void toggleSave() => emit (SaveState(isSaved: !state.isSaved));
}
