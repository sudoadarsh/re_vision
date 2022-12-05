import 'package:flutter/material.dart';

import 'base_text.dart';

class SliverSectionHeader extends StatelessWidget {
  const SliverSectionHeader({
    Key? key,
    required this.header,
  }) : super(key: key);

  final String header;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8),
      sliver: SliverToBoxAdapter(
        child: BaseText(header, fontSize: 20.0, fontWeight: FontWeight.w300),
      ),
    );
  }
}
