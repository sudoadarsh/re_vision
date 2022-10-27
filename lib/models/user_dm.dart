/// name : ""
/// uuid : ""
/// email: ""
/// requestS : [{"uuid":"","status":""}]
/// requestR : [{"uuid":"","seen":"false"}]
/// friends : [{"uuid":"","share":""}]

class UserFBDm {
  UserFBDm({
    String? name,
    String? email,
    String? uuid,
    List<RequestS>? requestS,
    List<RequestR>? requestR,
    List<Friends>? friends,
  }) {
    _name = name;
    _email = email;
    _uuid = uuid;
    _requestS = requestS;
    _requestR = requestR;
    _friends = friends;
  }

  UserFBDm.fromJson(dynamic json) {
    _name = json['name'];
    _email = json['email'];
    _uuid = json['uuid'];
    if (json['requestS'] != null) {
      _requestS = [];
      json['requestS'].forEach((v) {
        _requestS?.add(RequestS.fromJson(v));
      });
    }
    if (json['requestR'] != null) {
      _requestR = [];
      json['requestR'].forEach((v) {
        _requestR?.add(RequestR.fromJson(v));
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
  String? _uuid;
  List<RequestS>? _requestS;
  List<RequestR>? _requestR;
  List<Friends>? _friends;

  UserFBDm copyWith({
    String? name,
    String? uuid,
    String? email,
    List<RequestS>? requestS,
    List<RequestR>? requestR,
    List<Friends>? friends,
  }) =>
      UserFBDm(
        name: name ?? _name,
        email: email ?? _email,
        uuid: uuid ?? _uuid,
        requestS: requestS ?? _requestS,
        requestR: requestR ?? _requestR,
        friends: friends ?? _friends,
      );

  String? get name => _name;

  String? get email => _email;

  String? get uuid => _uuid;

  List<RequestS>? get requestS => _requestS;

  List<RequestR>? get requestR => _requestR;

  List<Friends>? get friends => _friends;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['email'] = _email;
    map['uuid'] = _uuid;
    if (_requestS != null) {
      map['requestS'] = _requestS?.map((v) => v.toJson()).toList();
    }
    if (_requestR != null) {
      map['requestR'] = _requestR?.map((v) => v.toJson()).toList();
    }
    if (_friends != null) {
      map['friends'] = _friends?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// uuid : ""
/// share : ""

class Friends {
  Friends({
    String? uuid,
    String? share,
  }) {
    _uuid = uuid;
    _share = share;
  }

  Friends.fromJson(dynamic json) {
    _uuid = json['uuid'];
    _share = json['share'];
  }

  String? _uuid;
  String? _share;

  Friends copyWith({
    String? uuid,
    String? share,
  }) =>
      Friends(
        uuid: uuid ?? _uuid,
        share: share ?? _share,
      );

  String? get uuid => _uuid;

  String? get share => _share;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uuid'] = _uuid;
    map['share'] = _share;
    return map;
  }
}

/// uuid : ""
/// seen : "false"

class RequestR {
  RequestR({
    String? uuid,
    String? seen,
  }) {
    _uuid = uuid;
    _seen = seen;
  }

  RequestR.fromJson(dynamic json) {
    _uuid = json['uuid'];
    _seen = json['seen'];
  }

  String? _uuid;
  String? _seen;

  RequestR copyWith({
    String? uuid,
    String? seen,
  }) =>
      RequestR(
        uuid: uuid ?? _uuid,
        seen: seen ?? _seen,
      );

  String? get uuid => _uuid;

  String? get seen => _seen;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uuid'] = _uuid;
    map['seen'] = _seen;
    return map;
  }
}

/// uuid : ""
/// status : ""

class RequestS {
  RequestS({
    String? uuid,
    String? status,
  }) {
    _uuid = uuid;
    _status = status;
  }

  RequestS.fromJson(dynamic json) {
    _uuid = json['uuid'];
    _status = json['status'];
  }

  String? _uuid;
  String? _status;

  RequestS copyWith({
    String? uuid,
    String? status,
  }) =>
      RequestS(
        uuid: uuid ?? _uuid,
        status: status ?? _status,
      );

  String? get uuid => _uuid;

  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uuid'] = _uuid;
    map['status'] = _status;
    return map;
  }
}
