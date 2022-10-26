/// name : "displayName"
/// profile_pic : "user.photoURL"

class UserFBDm {
  UserFBDm({
    String? name,
    String? profilePic,}) {
    _name = name;
    _profilePic = profilePic;
  }

  UserFBDm.fromJson(dynamic json) {
    _name = json['name'];
    _profilePic = json['profile_pic'];
  }

  String? _name;
  String? _profilePic;

  UserFBDm copyWith({ String? name,
    String? profilePic,
  }) =>
      UserFBDm(name: name ?? _name,
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