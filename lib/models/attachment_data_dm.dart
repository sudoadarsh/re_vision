/// type : 0
/// data : ""

enum AttachmentType {
  article(0),
  image(1),
  pdf(2),
  video(3);

  const AttachmentType(this.value);

  final int value;
}

class AttachmentDataDm {
  AttachmentDataDm({
    int? type,
    String? data,
  }) {
    _type = type;
    _data = data;
  }

  AttachmentDataDm.fromJson(dynamic json) {
    _type = json['type'];
    _data = json['data'];
  }

  int? _type;
  String? _data;

  AttachmentDataDm copyWith({
    int? type,
    String? data,
  }) =>
      AttachmentDataDm(
        type: type ?? _type,
        data: data ?? _data,
      );

  int? get type => _type;

  String? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['data'] = _data;
    return map;
  }
}
