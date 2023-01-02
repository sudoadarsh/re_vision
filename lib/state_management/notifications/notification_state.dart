part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationStateChange extends NotificationState {
  final List<ReqsDm> notifications;

  NotificationStateChange({required this.notifications});
}
