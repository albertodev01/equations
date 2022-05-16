import 'dart:math' as math;

import 'package:equations_solver/blocs/expansion_cubit/expansion_cubit.dart';
import 'package:equations_solver/routes/utils/collapsible/primary_region.dart';
import 'package:equations_solver/routes/utils/collapsible/secondary_region.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget has a visible area, called **header** and another area, called
/// **content**, that appears or disappears with a slide down or up animation.
class Collapsible extends StatefulWidget {
  /// The `header` contains the visible content. This widget isn't collapsed and
  /// the user sees it immediately.
  final Widget header;

  /// The `content` is initially collapsed and thus the user cannot see this
  /// immediately. To show this widget, the user must tap the header to start
  /// the scale animation.
  final Widget content;

  /// The widget padding.
  ///
  /// By default, this is set to [EdgeInsets.zero].
  final EdgeInsets edgeInsets;

  /// The height between [header] and [content] when expanded.
  ///
  /// By default, this is set to `0`.
  final double heightBetweenRegions;

  /// When `true`, the widget is created with the [content] part visible.
  ///
  /// By default, this is set to `false`.
  final bool initializeOpened;

  /// Creates a [Collapsible] widget.
  const Collapsible({
    super.key,
    required this.header,
    required this.content,
    this.edgeInsets = EdgeInsets.zero,
    this.heightBetweenRegions = 0.0,
    this.initializeOpened = false,
  });

  @override
  _CollapsibleState createState() => _CollapsibleState();
}

class _CollapsibleState extends State<Collapsible>
    with TickerProviderStateMixin {
  /// The animation controller to rotate the top-right button and grow the
  /// size of the primary region.
  late final controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
    value: widget.initializeOpened ? 1 : 0,
  );

  /// The rotation animation of the button.
  late final rotationAnimation = Tween<double>(
    begin: 0,
    end: math.pi,
  ).animate(controller);

  /// Up and down animation for the secondary region.
  late final slidingAnimation = CurvedAnimation(
    parent: controller,
    curve: Curves.ease,
  );

  /// Open or closes the secondary region.
  void toggleExpansion() => context.read<ExpansionCubit>().toggle();

  @override
  void dispose() {
    controller.dispose();
    slidingAnimation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpansionCubit, bool>(
      listener: (context, state) {
        if (!state) {
          controller.reverse();
        } else {
          controller.forward();
        }
      },
      child: Padding(
        padding: widget.edgeInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: toggleExpansion,
              behavior: HitTestBehavior.opaque,
              child: PrimaryRegion(
                key: const Key('Collapsible-Primary-region'),
                animation: rotationAnimation,
                child: widget.header,
              ),
            ),
            SizeTransition(
              key: const Key('Collapsible-SizeTransition'),
              sizeFactor: controller,
              axisAlignment: 1,
              child: SecondaryRegion(
                key: const Key('Collapsible-Secondary-region'),
                heightBetweenRegions: widget.heightBetweenRegions,
                child: widget.content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
