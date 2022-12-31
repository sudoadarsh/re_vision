import 'dart:io';
import 'package:flutter/material.dart';
import 'package:re_vision/constants/icon_constants.dart';
import 'package:re_vision/extensions/widget_extensions.dart';
import 'package:video_player/video_player.dart';

class AttachmentThumbnail extends StatefulWidget {
  const AttachmentThumbnail({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  State<AttachmentThumbnail> createState() => _AttachmentThumbnailState();
}

class _AttachmentThumbnailState extends State<AttachmentThumbnail> {
  /// The video controller.
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        setState(() {});
        return;
      });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_controller),
              const CircleAvatar(
                backgroundColor: Color.fromARGB(55, 94, 94, 96),
                child: IconC.play,
              )
            ],
          )
        : IconC.video.center();
  }
}
