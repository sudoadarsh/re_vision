import 'package:re_vision/base_sqlite/base_sqlite_model.dart';

/// id : 1
/// topic : ""
/// attachments : ""
/// created_at : ""
/// scheduled_to : ""
/// iteration : ""

class TopicDm extends BaseSqliteModel {
  TopicDm({
    String? id,
    String? topic,
    String? attachments,
    String? notes,
    String? createdAt,
    String? scheduledTo,
    int? iteration,
    int? isOnline,
  }) {
    _id = id;
    _topic = topic;
    _attachments = attachments;
    _notes = notes;
    _createdAt = createdAt;
    _scheduledTo = scheduledTo;
    _iteration = iteration;
    _isOnline = isOnline;
  }

  TopicDm.fromJson(dynamic json) {
    _id = json['id'];
    _topic = json['topic'];
    _attachments = json['attachments'];
    _notes = json["notes"];
    _createdAt = json['created_at'];
    _scheduledTo = json['scheduled_to'];
    _iteration = json['iteration'];
    _isOnline = json['isOnline'];
  }

  String? _id;
  String? _topic;
  String? _attachments;
  String? _notes;
  String? _createdAt;
  String? _scheduledTo;
  int? _iteration;
  int? _isOnline;

  TopicDm copyWith({
    String? id,
    String? topic,
    String? attachments,
    String? notes,
    String? createdAt,
    String? scheduledTo,
    int? iteration,
    int? isOnline
  }) =>
      TopicDm(
        id: id ?? _id,
        topic: topic ?? _topic,
        attachments: attachments ?? _attachments,
        notes: notes ?? _notes,
        createdAt: createdAt ?? _createdAt,
        scheduledTo: scheduledTo ?? _scheduledTo,
        iteration: iteration ?? _iteration,
        isOnline: isOnline ?? _isOnline
      );

  String? get id => _id;

  String? get topic => _topic;

  String? get attachments => _attachments;

  String? get notes => _notes;

  String? get createdAt => _createdAt;

  String? get scheduledTo => _scheduledTo;

  int? get iteration => _iteration;

  int? get isOnline => _isOnline;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['topic'] = _topic;
    map['attachments'] = _attachments;
    map['notes'] = _notes;
    map['created_at'] = _createdAt;
    map['scheduled_to'] = _scheduledTo;
    map['iteration'] = _iteration;
    map["is_online"] = _isOnline;
    return map;
  }
}
