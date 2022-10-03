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

  AttachmentDm copyWith({
    String? title,
    Icon? icon,
    bool? isArticle,
    bool? isPdf,
    bool? isImage,
    bool? isVideo,
    String? data,
  }) {
    return AttachmentDm(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      data: data ?? this.data,
      isArticle: isArticle ?? this.isArticle,
      isImage: isImage ?? this.isImage,
      isPdf: isPdf ?? this.isPdf,
      isVideo: isVideo ?? this.isVideo
    );
  }
}
