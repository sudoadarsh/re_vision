// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:re_vision/models/attachment_dm.dart';

part 'attachment_state.dart';

class AttachmentCubit extends Cubit<AttachmentState> {
  AttachmentCubit() : super(AttachmentState(attachments: []));

  void addAttachment(AttachmentDm attachment) {
    List<AttachmentDm> current = state.attachments;
    current.add(attachment);
    emit (AttachmentState(attachments: current));
  }

  void removeAttachment(AttachmentDm attachment) {
    List<AttachmentDm> current = state.attachments;
    List<AttachmentDm> modified = current.where((element) => element.data != attachment.data).toList();
    emit (AttachmentState(attachments: modified));
  }
}
