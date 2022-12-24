import 'package:flutter/material.dart';
import 'package:re_vision/modules/labels/labels_page.dart';

import '../../base_widgets/base_text.dart';
import '../../constants/color_constants.dart';

mixin LabelsView on State<LabelsPage> {
  /// The label chip.
  Widget labelChip({
    required String label,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return _LabelChip(
      label: label,
      isSelected: isSelected,
      onTap: onTap,
    );
  }

  /// The results view builder.
  Widget resultBuilder({
    required List items,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return _ResultViewBuilder(
      items: items,
      itemBuilder: itemBuilder,
    );
  }
}

/// The label chip widget.
class _LabelChip extends StatelessWidget {
  const _LabelChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: onTap,
        child: Chip(
          label: BaseText(
            label.trim(),
          ),
          backgroundColor: isSelected ? ColorC.secondary : ColorC.secondaryComp,
        ),
      ),
    );
  }
}

/// The result view builder. This will be used in three scenarios.
class _ResultViewBuilder extends StatelessWidget {
  const _ResultViewBuilder({
    Key? key,
    required this.itemBuilder,
    required this.items,
  }) : super(key: key);

  final List items;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
