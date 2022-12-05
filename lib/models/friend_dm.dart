/// name : ""
/// email : ""

class FriendDm {
  FriendDm({
    String? uuid,
    String? name,
    String? email,
  }) {
    _name = name;
    _email = email;
    _uuid = uuid;
  }

  FriendDm.fromJson(dynamic json) {
    _uuid = json['uuid'];
    _name = json['name'];
    _email = json['email'];
  }

  String? _name;
  String? _email;
  String? _uuid;

  FriendDm copyWith({
    String? name,
    String? email,
    String? uuid,
  }) =>
      FriendDm(
        name: name ?? _name,
        email: email ?? _email,
        uuid: uuid ?? _uuid
      );

  String? get name => _name;

  String? get email => _email;

  String? get uuid => _uuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['email'] = _email;
    map['uuid'] = _uuid;
    return map;
  }
}
