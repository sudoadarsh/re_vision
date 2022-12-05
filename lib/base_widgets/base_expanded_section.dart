import 'package:flutter/material.dart';

class BaseExpandedSection extends StatefulWidget {
  const BaseExpandedSection(
      {Key? key, required this.child, this.expand = false})
      : super(key: key);

  final Widget child;
  final bool expand;

  @override
  State<BaseExpandedSection> createState() => _BaseExpandedSectionState();
}

class _BaseExpandedSectionState extends State<BaseExpandedSection>
    with SingleTickerProviderStateMixin {
  // 1. The animation controller.
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    // 2. Setting the animation controller.
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn);

    _runExpandCheck();

    super.initState();
  }

  // 3. Function to decide whether to expand or collapse the animation.
  void _runExpandCheck() {
    if (widget.expand) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  // 4. To trigger a function when a parameter of [BaseExpandedSection] changes.
  @override
  void didUpdateWidget(covariant BaseExpandedSection oldWidget) {
    _runExpandCheck();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(sizeFactor: _animation, child: widget.child);
  }
}
