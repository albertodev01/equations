import 'dart:math' as math;

import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// This widget collapses and expands to reveal more or less information.
///
/// The [primary] widget, placed at the top, is always visible. On the right,
/// there is a button that reveals or hides the [secondary] widget with a
/// sliding animation.
///
/// The button on the right is used to control whether [secondary] is visible or
/// not.
class Collapsible extends StatefulWidget {
  /// The visible part of the widget.
  final Widget primary;

  /// The hidden part of the widget. This will become visible with a slide
  /// animation when the button on the right is pressed.
  final Widget secondary;

  /// Creates a [Collapsible] widget.
  const Collapsible({
    required this.primary,
    required this.secondary,
    super.key,
  });

  @override
  State<Collapsible> createState() => _CollapsibleState();
}

class _CollapsibleState extends State<Collapsible>
    with SingleTickerProviderStateMixin {
  // Drives the button rotation AND the sliding value of the hidden part.
  late final controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // This part is always visible.
            _PrimaryWidget(
              controller: controller,
              child: widget.primary,
            ),

            // This part expands or collapses.
            _SecondaryWidget(
              controller: controller,
              child: widget.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// The upper part of [Collapsible] that is always visible and has a button on
/// the right to expand or collapse the contents below.
class _PrimaryWidget extends StatelessWidget {
  /// The [AnimationController] that rules button rotation angle.
  final AnimationController controller;

  /// The child.
  final Widget child;

  /// Creates a [_PrimaryWidget] widget.
  const _PrimaryWidget({
    required this.controller,
    required this.child,
  });

  /// Moves the animation controller backwards if it completed or forward if the
  /// animation didn't start.
  ///
  /// The animation goes back or forth ONLY if the controller isn't ticking.
  void _animate() {
    if (!controller.isAnimating) {
      controller.isCompleted ? controller.reverse() : controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left spacing
        const SizedBox(width: collapsibleInnerSpacing),

        // The actual contents of the top part. This is wrapped in 'Expanded' so
        // that it takes as much space as possible AND text can go to a new
        // line (if any).
        Expanded(
          child: child,
        ),

        // This button rotates by 180° according and indicates whether the
        // secondary widget is visible or not.
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: controller.value * math.pi,
              child: child,
            );
          },
          child: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_up,
              color: Colors.blue,
            ),
            splashRadius: collapsibleInnerSpacing,
            onPressed: _animate,
          ),
        ),

        // Right spacing
        const SizedBox(width: collapsibleInnerSpacing / 2),
      ],
    );
  }
}

/// The bottom part of [Collapsible] that expands or collapses.
class _SecondaryWidget extends StatelessWidget {
  /// The [AnimationController] that rules the [SizeTransition] status.
  final AnimationController controller;

  /// The child.
  final Widget child;

  /// Creates a [_SecondaryWidget] widget.
  const _SecondaryWidget({
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: controller,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: collapsibleInnerSpacing,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Separates the "hidden" part from the top with a gray line
            const Divider(
              height: collapsibleInnerSpacing * 2,
              thickness: 1,
            ),

            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
