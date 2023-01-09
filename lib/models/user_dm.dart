/// name : ""
/// email : ""
/// requests : [{"uuid":"","status":0,"seen":0}]

class UserFBDm {
  UserFBDm({
    String? name,
    String? email,
    String? picURL
  }) {
    _name = name;
    _email = email;
    _picURL = picURL;
  }

  UserFBDm.fromJson(dynamic json) {
    _name = json['name'];
    _email = json['email'];
    _picURL = json['pic_URL'];
  }

  String? _name;
  String? _email;
  String? _picURL;

  UserFBDm copyWith({
    String? name,
    String? email,
    String? picURL,
  }) =>
      UserFBDm(
        name: name ?? _name,
        email: email ?? _email,
        picURL: picURL ?? _picURL
      );

  String? get name => _name;

  String? get email => _email;

  String? get picURL => _picURL;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['email'] = _email;
    map['pic_URL'] = _picURL;
    return map;
  }
}
