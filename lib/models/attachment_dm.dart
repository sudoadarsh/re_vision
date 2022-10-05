import 'package:flutter/cupertino.dart';

class AttachmentDm {
  final String title;
  final Icon leadingIcon;
  final Widget expandedView;

  AttachmentDm({
    required this.title,
    required this.leadingIcon,
    required this.expandedView,
  });

  AttachmentDm copyWith({
    String? title,
    Icon? leadingIcon,
    Widget? expandedView,
  }) {
    return AttachmentDm(
      title: title ?? this.title,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      expandedView: expandedView ?? this.expandedView,
    );
  }
}
