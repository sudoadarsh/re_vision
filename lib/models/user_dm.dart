/// name : ""
/// email : ""
/// requests : [{"uuid":"","status":0,"seen":0}]

class UserFBDm {
  UserFBDm({
    String? name,
    String? email,
  }) {
    _name = name;
    _email = email;
  }

  UserFBDm.fromJson(dynamic json) {
    _name = json['name'];
    _email = json['email'];
  }

  String? _name;
  String? _email;

  UserFBDm copyWith({
    String? name,
    String? email,
  }) =>
      UserFBDm(
        name: name ?? _name,
        email: email ?? _email,
      );

  String? get name => _name;

  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['email'] = _email;
    return map;
  }
}

/// uuid : ""
/// status : 0
/// seen : 0

class FrReqDm {
  FrReqDm({
    String? uuid,
    String? name,
    String? email,
    String? pic,
    int? status,
  }) {
    _uuid = uuid;
    _status = status;
    _name = name;
    _email = email;
    _pic = pic;
  }

  FrReqDm.fromJson(dynamic json) {
    _uuid = json['uuid'];
    _status = json['status'];
    _name = json['name'];
    _email = json['email'];
    _pic = json['pic'];
  }

  String? _uuid;
  int? _status;
  String? _name;
  String? _email;
  String? _pic;

  FrReqDm copyWith({
    String? uuid,
    int? status,
    int? seen,
    String? name,
    String? email,
    String? pic,
  }) =>
      FrReqDm(
        uuid: uuid ?? _uuid,
        status: status ?? _status,
        name: name ?? _name,
        email: email ?? _email,
        pic: pic ?? _pic
      );

  String? get uuid => _uuid;

  int? get status => _status;

  String? get pic => _pic;

  String? get name => _name;

  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uuid'] = _uuid;
    map['status'] = _status;
    map['name'] = _name;
    map['email'] = _email;
    map['pic'] = _pic;
    return map;
  }
}
