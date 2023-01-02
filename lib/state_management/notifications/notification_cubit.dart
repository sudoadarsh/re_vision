// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:re_vision/models/reqs_dm.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationStateChange(notifications: const []));

  void change(List<ReqsDm> notifications) {
    emit(NotificationStateChange(notifications: notifications));
  }
}
