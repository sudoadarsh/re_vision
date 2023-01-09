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
    String? picURL,
  }) {
    _uuid = uuid;
    _name = name;
    _email = email;
    _status = status;
    _picURL = picURL;
  }

  TopicUserDm.fromJson(dynamic json) {
    _uuid = json['uuid'];
    _name = json['name'];
    _email = json['email'];
    _status = json['status'];
    _picURL = json['pic_URL'];
  }

  String? _uuid;
  String? _name;
  String? _email;
  int? _status;
  String? _picURL;

  TopicUserDm copyWith({
    String? uuid,
    String? name,
    String? email,
    int? status,
    String? picURL
  }) =>
      TopicUserDm(
        uuid: uuid ?? _uuid,
        name: name ?? _name,
        email: email ?? _email,
        status: status ?? _status,
        picURL: picURL ?? _picURL
      );

  String? get uuid => _uuid;

  String? get name => _name;

  String? get email => _email;

  int? get status => _status;

  String? get picURL => _picURL;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uuid'] = _uuid;
    map['name'] = _name;
    map['email'] = _email;
    map['status'] = _status;
    map['pic_URL'] = _picURL;
    return map;
  }
}
