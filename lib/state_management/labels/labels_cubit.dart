// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'labels_state.dart';

class LabelsCubit extends Cubit<LabelsState> {
  LabelsCubit() : super(LabelsInitial());

  /// Search for labels.
  void searchLabels(String label, List availableLabels) {
    // 1. If the search field is empty.
    if (label.isEmpty || label == "") emit(LabelsEmpty());

    // 2. Return the labels matching the search.
    List res = availableLabels
        .where((element) => element.toLowerCase().contains(label.trim().toLowerCase()))
        .toList();

    if (res.isEmpty) {
      emit (LabelsNotFound());
    } else {
      emit(LabelsFound(result: res));
    }
  }
}
