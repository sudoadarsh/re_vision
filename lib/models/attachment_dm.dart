import 'package:flutter/cupertino.dart';

enum AttachmentType {
  link(0),
  image(1),
  pdf(2);

  const AttachmentType(this.value);

  final int value;
}

class AttachmentDm {
  final String? title;
  final Icon? icon;
  final bool isArticle;
  final bool isPdf;
  final bool isImage;
  final bool isVideo;
  final String? data;

  AttachmentDm({
    this.title,
    this.icon,
    this.data,
    this.isArticle = true,
    this.isImage = false,
    this.isPdf = false,
    this.isVideo = false,
  });
}
