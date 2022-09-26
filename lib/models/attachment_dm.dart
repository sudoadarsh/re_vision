/// type : "type"
/// data : "data"

class AttachmentDm {
  AttachmentDm({
      String? type, 
      String? data,}){
    _type = type;
    _data = data;
}

  AttachmentDm.fromJson(dynamic json) {
    _type = json['type'];
    _data = json['data'];
  }
  String? _type;
  String? _data;
AttachmentDm copyWith({  String? type,
  String? data,
}) => AttachmentDm(  type: type ?? _type,
  data: data ?? _data,
);
  String? get type => _type;
  String? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['data'] = _data;
    return map;
  }

}