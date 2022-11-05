/// name : ""
/// email : ""
/// requests : [{"uuid":"","status":0,"seen":0}]
/// friends : [{"uuid":""}]

class UserFBDm {
  UserFBDm({
    String? name,
    String? email,
    List<Requests>? requests,
    List<Friends>? friends,
  }) {
    _name = name;
    _email = email;
    _requests = requests;
    _friends = friends;
  }

  UserFBDm.fromJson(dynamic json) {
    _name = json['name'];
    _email = json['email'];
    if (json['requests'] != null) {
      _requests = [];
      json['requests'].forEach((v) {
        _requests?.add(Requests.fromJson(v));
      });
    }
    if (json['friends'] != null) {
      _friends = [];
      json['friends'].forEach((v) {
        _friends?.add(Friends.fromJson(v));
      });
    }
  }

  String? _name;
  String? _email;
  List<Requests>? _requests;
  List<Friends>? _friends;

  UserFBDm copyWith({
    String? name,
    String? email,
    List<Requests>? requests,
    List<Friends>? friends,
  }) =>
      UserFBDm(
        name: name ?? _name,
        email: email ?? _email,
        requests: requests ?? _requests,
        friends: friends ?? _friends,
      );

  String? get name => _name;

  String? get email => _email;

  List<Requests>? get requests => _requests;

  List<Friends>? get friends => _friends;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['email'] = _email;
    if (_requests != null) {
      map['requests'] = _requests?.map((v) => v.toJson()).toList();
    }
    if (_friends != null) {
      map['friends'] = _friends?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// uuid : ""

class Friends {
  Friends({
    String? uuid,
  }) {
    _uuid = uuid;
  }

  Friends.fromJson(dynamic json) {
    _uuid = json['uuid'];
  }

  String? _uuid;

  Friends copyWith({
    String? uuid,
  }) =>
      Friends(
        uuid: uuid ?? _uuid,
      );

  String? get uuid => _uuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uuid'] = _uuid;
    return map;
  }
}

/// uuid : ""
/// status : 0
/// seen : 0

class Requests {
  Requests({
    String? uuid,
    String? name,
    String? email,
    String? pic,
    int? status,
    int? seen,
  }) {
    _uuid = uuid;
    _status = status;
    _seen = seen;
    _name = name;
    _email = email;
    _pic = pic;
  }

  Requests.fromJson(dynamic json) {
    _uuid = json['uuid'];
    _status = json['status'];
    _seen = json['seen'];
    _name = json['name'];
    _email = json['email'];
    _pic = json['pic'];
  }

  String? _uuid;
  int? _status;
  int? _seen;
  String? _name;
  String? _email;
  String? _pic;

  Requests copyWith({
    String? uuid,
    int? status,
    int? seen,
    String? name,
    String? email,
    String? pic,
  }) =>
      Requests(
        uuid: uuid ?? _uuid,
        status: status ?? _status,
        seen: seen ?? _seen,
        name: name ?? _name,
        email: email ?? _email,
        pic: pic ?? _pic
      );

  String? get uuid => _uuid;

  int? get status => _status;

  int? get seen => _seen;

  String? get pic => _pic;

  String? get name => _name;

  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uuid'] = _uuid;
    map['status'] = _status;
    map['seen'] = _seen;
    map['name'] = _name;
    map['email'] = _email;
    map['pic'] = _pic;
    return map;
  }
}
