part of 'common__cubit.dart';

@immutable
abstract class CommonCubitState {}

class CommonCubitInitial extends CommonCubitState {}

class CommonCubitStateLoading extends CommonCubitState {}

class CommonCubitStateLoaded<T> extends CommonCubitState {
  final List<T> data;
  CommonCubitStateLoaded({required this.data});
}

class CommonCubitStateError extends CommonCubitState {
  final String error;

  CommonCubitStateError({required this.error});
}