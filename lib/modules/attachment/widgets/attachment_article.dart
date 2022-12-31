import 'package:favicon/favicon.dart';
import 'package:flutter/cupertino.dart';
import 'package:re_vision/extensions/widget_extensions.dart';

import '../../../base_widgets/base_image_builder.dart';
import '../../../constants/icon_constants.dart';

class AttachmentArticle extends StatelessWidget {
  const AttachmentArticle({Key? key, required this.initialUrl}) : super(key: key);

  final String initialUrl;

  // To get the image url.
  Future<String?> getImageUrl() async {
    String url;
    try {
      final Favicon? icon = await FaviconFinder.getBest(initialUrl);
      url = icon?.url ?? '';
    } catch (e) {
      debugPrint('Unable to get Favicon');
      url = '';
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImageUrl(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return BaseImageBuilder(
            url: snapshot.data!,
            error: IconC.link,
            height: 20,
            width: 20,
          ).center();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator().center();
        }
        return IconC.link;
      },
    );
  }
}
