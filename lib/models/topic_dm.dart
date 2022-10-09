import 'package:re_vision/base_sqlite/base_sqlite_model.dart';

/// id : 1
/// topic : ""
/// attachments : ""
/// created_at : ""
/// scheduled_to : ""
/// iteration : ""

class TopicDm extends BaseSqliteModel {
  TopicDm({
    int? id,
    String? topic,
    String? attachments,
    String? createdAt,
    String? scheduledTo,
    int? iteration,
  }) {
    _id = id;
    _topic = topic;
    _attachments = attachments;
    _createdAt = createdAt;
    _scheduledTo = scheduledTo;
    _iteration = iteration;
  }

  TopicDm.fromJson(dynamic json) {
    _id = json['id'];
    _topic = json['topic'];
    _attachments = json['attachments'];
    _createdAt = json['created_at'];
    _scheduledTo = json['scheduled_to'];
    _iteration = json['iteration'];
  }

  int? _id;
  String? _topic;
  String? _attachments;
  String? _createdAt;
  String? _scheduledTo;
  int? _iteration;

  TopicDm copyWith({
    int? id,
    String? topic,
    String? attachments,
    String? createdAt,
    String? scheduledTo,
    int? iteration,
  }) =>
      TopicDm(
        id: id ?? _id,
        topic: topic ?? _topic,
        attachments: attachments ?? _attachments,
        createdAt: createdAt ?? _createdAt,
        scheduledTo: scheduledTo ?? _scheduledTo,
        iteration: iteration ?? _iteration,
      );

  int? get id => _id;

  String? get topic => _topic;

  String? get attachments => _attachments;

  String? get createdAt => _createdAt;

  String? get scheduledTo => _scheduledTo;

  int? get iteration => _iteration;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['topic'] = _topic;
    map['attachments'] = _attachments;
    map['created_at'] = _createdAt;
    map['scheduled_to'] = _scheduledTo;
    map['iteration'] = _iteration;
    return map;
  }
}
