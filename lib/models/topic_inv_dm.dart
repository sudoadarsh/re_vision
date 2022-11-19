/// id : ""
/// status : 0
/// name : ""
/// email : ""

class TopicInvDm {
  TopicInvDm({
    String? id,
    int? status,
    String? topicName,
    String? email,
  }) {
    _id = id;
    _status = status;
    _topicName = topicName;
    _email = email;
  }

  TopicInvDm.fromJson(dynamic json) {
    _id = json['id'];
    _status = json['status'];
    _topicName = json['topic_name'];
    _email = json['email'];
  }

  String? _id;
  int? _status;
  String? _topicName;
  String? _email;

  TopicInvDm copyWith({
    String? id,
    int? status,
    String? name,
    String? email,
  }) =>
      TopicInvDm(
        id: id ?? _id,
        status: status ?? _status,
        topicName: name ?? _topicName,
        email: email ?? _email,
      );

  String? get id => _id;

  int? get status => _status;

  String? get topicName => _topicName;

  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['status'] = _status;
    map['topic_name'] = _topicName;
    map['email'] = _email;
    return map;
  }
}
