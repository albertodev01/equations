import 'package:equation_painter/src/model/equation_painter.dart';
import 'package:equation_painter/src/model/types.dart';
import 'package:equation_painter/src/state/inherited_painter_zoom_state.dart';
import 'package:equation_painter/src/state/painter_zoom_state.dart';
import 'package:flutter/material.dart';

/// {@template equation_painter.EquationPainterWidget}
/// This widget draws a cartesian plane and, if there's a [evaluator], it also
/// draws the function. When [areaColor] is not `null`, [lowerAreaLimit] and
/// [upperAreaLimit] can be used to control which area to color below or above
/// the function.
///
/// If [evaluator] is not `null`, a widget to zoom in and out the plane is added
/// to the bottom.
/// {@endtemplate}
class EquationPainterWidget extends StatelessWidget {
  /// {@macro equation_painter.FunctionEvaluator}
  final FunctionEvaluator? evaluator;

  /// {@template equation_painter.areaColor}
  /// The color that highlights the area below a function.
  ///
  /// By default, this is [Colors.transparent] so that nothing is colored.
  /// {@endtemplate}
  final Color? areaColor;

  /// {@template equation_painter.lowerAreaLimit}
  /// The lower limit that indicates from which point in the x axis the area
  /// below or above the function has to be colored.
  ///
  /// By default, this is `null`, meaning that the entire region to the left is
  /// colored.
  /// {@endtemplate}
  final double? lowerAreaLimit;

  /// {@template equation_painter.upperAreaLimit}
  /// The upper limit that indicates up to which point in the x axis the area
  /// below or above the function has to be colored.
  ///
  /// By default, this is `null`, meaning that the entire region to the right is
  /// colored).
  /// {@endtemplate}
  final double? upperAreaLimit;

  /// Creates a [EquationPainterWidget] instance.
  const EquationPainterWidget({
    super.key,
    this.areaColor,
    this.evaluator,
    this.lowerAreaLimit,
    this.upperAreaLimit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 45, 50, 40),
      child: InheritedPainterZoomState(
        painterZoomState: PainterZoomState(
          minValue: 2,
          maxValue: 10,
          initial: 5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Body(
              evaluator: evaluator,
              areaColor: areaColor,
              lowerAreaLimit: lowerAreaLimit,
              upperAreaLimit: upperAreaLimit,
            ),
            if (evaluator != null) ...const [
              SizedBox(height: 16),
              _InternalSlider(),
            ],
          ],
        ),
      ),
    );
  }
}

/// Internal widget used by [EquationPainterWidget].
@visibleForTesting
class Body extends StatelessWidget {
  /// {@macro equation_painter.FunctionEvaluator}
  final FunctionEvaluator? evaluator;

  /// {@macro equation_painter.areaColor}
  final Color? areaColor;

  /// {@macro equation_painter.lowerAreaLimit}
  final double? lowerAreaLimit;

  /// {@macro equation_painter.upperAreaLimit}
  final double? upperAreaLimit;

  /// Creates a [Body] widget.
  const Body({
    required this.evaluator,
    required this.areaColor,
    required this.lowerAreaLimit,
    required this.upperAreaLimit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final zoomState = InheritedPainterZoomState.of(context).painterZoomState;

    return Material(
      elevation: 8,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: ListenableBuilder(
          listenable: zoomState,
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, sizes) {
                final normalized = sizes.normalize().maxWidth;

                return CustomPaint(
                  painter: EquationPainter(
                    evaluator: evaluator,
                    range: zoomState.zoom.round(),
                    colorArea: (
                      color: areaColor ?? Colors.transparent,
                      start: lowerAreaLimit ?? -zoomState.zoom,
                      end: upperAreaLimit ?? zoomState.zoom,
                    ),
                  ),
                  size: Size.square(normalized),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _InternalSlider extends StatelessWidget {
  const _InternalSlider();

  @override
  Widget build(BuildContext context) {
    final zoomState = InheritedPainterZoomState.of(context).painterZoomState;

    return ListenableBuilder(
      listenable: zoomState,
      builder: (context, state) {
        return Slider(
          min: zoomState.minValue,
          max: zoomState.maxValue,
          value: zoomState.zoom,
          onChanged: zoomState.updateSlider,
          label: '${zoomState.zoom.round()}',
        );
      },
    );
  }
}
