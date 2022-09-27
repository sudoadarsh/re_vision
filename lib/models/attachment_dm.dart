import 'package:re_vision/models/attachment_type_dm.dart';

/// type : "type"
/// data : "data"

class AttachmentDm {
  AttachmentDm({
    AttachmentType? type,
    String? data,
  }) {
    _type = type;
    _data = data;
  }

  AttachmentDm.fromJson(dynamic json) {
    _type = json['type'];
    _data = json['data'];
  }
  AttachmentType? _type;
  String? _data;
  AttachmentDm copyWith({
    AttachmentType? type,
    String? data,
  }) =>
      AttachmentDm(
        type: type ?? _type,
        data: data ?? _data,
      );
  AttachmentType? get type => _type;
  String? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['data'] = _data;
    return map;
  }
}
