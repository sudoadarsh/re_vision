/// name : ""
/// email : ""

class FriendDm {
  FriendDm({
    String? uuid,
    String? name,
    String? email,
    String? picURL,
  }) {
    _name = name;
    _email = email;
    _uuid = uuid;
    _picURL = picURL;
  }

  FriendDm.fromJson(dynamic json) {
    _uuid = json['uuid'];
    _name = json['name'];
    _email = json['email'];
    _picURL = json['pic_URL'];
  }

  String? _name;
  String? _email;
  String? _uuid;
  String? _picURL;

  FriendDm copyWith({
    String? name,
    String? email,
    String? uuid,
    String? picURL,
  }) =>
      FriendDm(
        name: name ?? _name,
        email: email ?? _email,
        uuid: uuid ?? _uuid,
        picURL: picURL ?? _picURL,
      );

  String? get name => _name;

  String? get email => _email;

  String? get uuid => _uuid;

  String? get picURL => _picURL;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['email'] = _email;
    map['uuid'] = _uuid;
    map['pic_URL'] = _picURL;
    return map;
  }
}
