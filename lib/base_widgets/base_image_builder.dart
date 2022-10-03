import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class BaseImageBuilder extends StatelessWidget {
  const BaseImageBuilder({
    Key? key,
    required this.url,
    required this.error, this.height, this.width,
  }) : super(key: key);

  final String url;
  final Widget error;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, image) {
        return Container(
          decoration: BoxDecoration(image: DecorationImage(image: image)),
        );
      },
      placeholder: (context, url) => const CupertinoActivityIndicator(),
      errorWidget: (context, url, error) => error,
    );
  }
}
