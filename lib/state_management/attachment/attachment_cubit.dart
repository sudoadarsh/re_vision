// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

import '../../models/attachment_data_dm.dart';

part 'attachment_state.dart';

class AttachmentCubit extends Cubit<AttachmentState> {
  AttachmentCubit() : super(AttachmentState(data: []));
  
  void addAttachment(AttachmentDataDm newData) {
    List<AttachmentDataDm> data = state.data;
    data.add(newData);
    emit (AttachmentState(data: data));
  }
  
  void removeAttachment(AttachmentDataDm newData) {
    List<AttachmentDataDm> modified = state.data.where((element) => element.data != newData.data).toList();
    emit (AttachmentState(data: modified));
  }

  void clear() {
    emit (AttachmentState(data: []));
  }
}
