/// uuid : ""
/// name : ""
/// email : ""
/// status : 0

class TopicUserDm {
  TopicUserDm({
    String? uuid,
    String? name,
    String? email,
    int? status,
  }) {
    _uuid = uuid;
    _name = name;
    _email = email;
    _status = status;
  }

  TopicUserDm.fromJson(dynamic json) {
    _uuid = json['uuid'];
    _name = json['name'];
    _email = json['email'];
    _status = json['status'];
  }

  String? _uuid;
  String? _name;
  String? _email;
  int? _status;

  TopicUserDm copyWith({
    String? uuid,
    String? name,
    String? email,
    int? status,
  }) =>
      TopicUserDm(
        uuid: uuid ?? _uuid,
        name: name ?? _name,
        email: email ?? _email,
        status: status ?? _status,
      );

  String? get uuid => _uuid;

  String? get name => _name;

  String? get email => _email;

  int? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uuid'] = _uuid;
    map['name'] = _name;
    map['email'] = _email;
    map['status'] = _status;
    return map;
  }
}
