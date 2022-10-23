/// name : "displayName"
/// profile_pic : "user.photoURL"

class UserDm {
  UserDm({
    String? name,
    String? profilePic,}) {
    _name = name;
    _profilePic = profilePic;
  }

  UserDm.fromJson(dynamic json) {
    _name = json['name'];
    _profilePic = json['profile_pic'];
  }

  String? _name;
  String? _profilePic;

  UserDm copyWith({ String? name,
    String? profilePic,
  }) =>
      UserDm(name: name ?? _name,
        profilePic: profilePic ?? _profilePic,
      );

  String? get name => _name;

  String? get profilePic => _profilePic;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['profile_pic'] = _profilePic;
    return map;
  }
}