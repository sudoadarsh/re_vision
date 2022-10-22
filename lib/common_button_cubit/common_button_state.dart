part of 'common_button_cubit.dart';

@immutable
abstract class CommonButtonState {}

class CommonButtonInitial extends CommonButtonState {}

class CommonButtonLoading extends CommonButtonState {}

class CommonButtonSuccess<T> extends CommonButtonState {
  final T? data;

  CommonButtonSuccess({required this.data});
}

class CommonButtonFailure extends CommonButtonState {
  final String error;
  CommonButtonFailure({required this.error});
}