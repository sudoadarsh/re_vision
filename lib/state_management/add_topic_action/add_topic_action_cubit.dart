// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'add_topic_action_state.dart';

class AddTopicActionCubit extends Cubit<AddTopicActionState> {
  AddTopicActionCubit() : super(const AddTopicActionState());
  void interact() {
    emit (AddTopicActionState(longPressed: !state.longPressed));
  }
}
