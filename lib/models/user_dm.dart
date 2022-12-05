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
