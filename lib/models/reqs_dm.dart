/// primary_id : ""
/// name : ""
/// email : ""
/// status : ""

class ReqsDm {
  ReqsDm({
    String? primaryId,
    String? name,
    String? email,
    int? status,
    String? uuid,
    String? topic
  }) {
    _primaryId = primaryId;
    _name = name;
    _email = email;
    _status = status;
    _uuid = uuid;
    _topic = topic;
  }

  ReqsDm.fromJson(dynamic json) {
    _primaryId = json['primary_id'];
    _name = json['name'];
    _email = json['email'];
    _status = json['status'];
    _uuid = json['uuid'];
    _topic = json['topic'];
  }

  String? _primaryId;
  String? _name;
  String? _email;
  int? _status;
  String? _uuid;
  String? _topic;

  ReqsDm copyWith({
    String? primaryId,
    String? name,
    String? email,
    int? status,
    String? uuid,
    String? topic,
  }) =>
      ReqsDm(
        primaryId: primaryId ?? _primaryId,
        name: name ?? _name,
        email: email ?? _email,
        status: status ?? _status,
        uuid: uuid ?? _uuid,
        topic: topic ?? _topic,
      );

  String? get primaryId => _primaryId;

  String? get name => _name;

  String? get email => _email;

  int? get status => _status;

  String? get uuid => _uuid;

  String? get topic => _topic;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['primary_id'] = _primaryId;
    map['name'] = _name;
    map['email'] = _email;
    map['status'] = _status;
    map['uuid'] = _uuid;
    map['topic'] = _topic;
    return map;
  }
}
