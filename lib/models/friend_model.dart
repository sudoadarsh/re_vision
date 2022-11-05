/// uuid : ""

class FriendModel {
  FriendModel({
    String? uuid,
  }) {
    _uuid = uuid;
  }

  FriendModel.fromJson(dynamic json) {
    _uuid = json['uuid'];
  }

  String? _uuid;

  FriendModel copyWith({
    String? uuid,
  }) =>
      FriendModel(
        uuid: uuid ?? _uuid,
      );

  String? get uuid => _uuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uuid'] = _uuid;
    return map;
  }
}
