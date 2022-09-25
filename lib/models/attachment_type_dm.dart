import 'package:flutter/cupertino.dart';

class AttachmentTypeDm {
  final String title;
  final Icon icon;
  final bool isArticle;
  final bool isPdf;
  final bool isVideo;
  final String? data;

  AttachmentTypeDm({
    required this.title,
    required this.icon,
    this.data,
    this.isArticle = true,
    this.isPdf = false,
    this.isVideo = false,
  });
}
