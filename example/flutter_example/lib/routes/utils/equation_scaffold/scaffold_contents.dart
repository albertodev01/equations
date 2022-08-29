import 'dart:math' as math;

import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';

/// The content of the [EquationScaffold] scaffold, which is simply a [Stack]
/// with two children:
///
///   - A background widget that draws an SVG image as background,
///   - A foreground widget which is the actual content of the page.
///
/// If there is enough space in the horizontal axis, an additional background
/// image is added.
class ScaffoldContents extends StatelessWidget {
  /// The body of the [Scaffold]
  final Widget body;

  /// Creates a [ScaffoldContents] widget.
  const ScaffoldContents({
    required this.body,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // The background image of the page
          const Positioned(
            bottom: -70,
            left: -30,
            child: _ScaffoldBackground(),
          ),

          const Positioned(
            top: 20,
            right: 80,
            child: _ScaffoldExtraBackground(),
          ),

          // The actual contents in the foreground
          Positioned.fill(
            child: body,
          ),
        ],
      ),
    );
  }
}

/// The contents of the scaffold in the background.
class _ScaffoldBackground extends StatelessWidget {
  /// Creates a [_ScaffoldBackground] widget.
  const _ScaffoldBackground();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -math.pi / 8,
      child: CartesianPlaneBackground(
        key: const Key('ScaffoldBackground'),
        size: MediaQuery.of(context).size.height / 1.2,
      ),
    );
  }
}

/// The contents of the scaffold in the background.
class _ScaffoldExtraBackground extends StatelessWidget {
  /// Creates a [_ScaffoldExtraBackground] widget.
  const _ScaffoldExtraBackground();

  @override
  Widget build(BuildContext context) {
    final viewportSize = MediaQuery.of(context).size.width;
    final pictureSize = MediaQuery.of(context).size.shortestSide / 2;

    return Visibility(
      visible: viewportSize >= extraBackgroundBreakpoint,
      child: GaussianCurveBackground(
        key: const Key('ScaffoldExtraBackground'),
        size: pictureSize,
      ),
    );
  }
}
