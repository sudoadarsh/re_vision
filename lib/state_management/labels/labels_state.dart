part of 'labels_cubit.dart';

@immutable
abstract class LabelsState {}

class LabelsInitial extends LabelsState {}

class LabelsEmpty extends LabelsState {}

class LabelsFound extends LabelsState {
  final List result;
  LabelsFound({required this.result});
}

class LabelsNotFound extends LabelsState {}