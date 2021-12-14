import 'package:equations_solver/blocs/plot_zoom/plot_zoom.dart';
import 'package:equations_solver/routes/utils/plot_widget/color_area.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/plot_widget/plotter_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget draws a cartesian plane and, if there's a [plotMode], it also
/// plots a real function `f(x)`.
///
/// If [plotMode] is not `null`, then a plot_zoom is also added below the widget to
/// scale the image.
///
/// If [plotMode] is `null`, the plot_zoom doesn't appear and the widget only draws
/// a cartesian plane (with no function within).
class PlotWidget<T> extends StatelessWidget {
  /// Provides the ability to evaluate a real function on a point.
  final PlotMode<T>? plotMode;

  /// The color that highlights the area below a function.
  ///
  /// By default, this is set to [Colors.transparent] so nothing will be colored.
  final Color areaColor;

  /// The lower limit that indicates from which point in the x axis the area
  /// below the function has to be colored.
  ///
  /// By default, this is `null` meaning that no lower limits are applied (so
  /// the entire region on the left is colored).
  final double? lowerAreaLimit;

  /// The upper limit that indicates up to which point in the x axis the area
  /// below the function has to be colored.
  ///
  /// By default, this is `null` meaning that no upper limits are applied (so
  /// the entire region on the right is colored).
  final double? upperAreaLimit;

  /// Creates a [PlotWidget] instance.
  const PlotWidget({
    Key? key,
    this.areaColor = Colors.transparent,
    this.plotMode,
    this.lowerAreaLimit,
    this.upperAreaLimit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 45, 50, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The plot
          _PlotBody<T>(
            plotMode: plotMode,
            areaColor: areaColor,
            lowerAreaLimit: lowerAreaLimit,
            upperAreaLimit: upperAreaLimit,
          ),

          // Some spacing
          const SizedBox(height: 35),

          // Placing the slider ONLY if there's a function
          if (plotMode != null) const _PlotSlider(),
        ],
      ),
    );
  }
}

class _PlotBody<T> extends StatelessWidget {
  /// The [PlotMode] object.
  final PlotMode<T>? plotMode;

  /// The color that highlights the area below a function.
  final Color areaColor;

  /// The lower limit that indicates from which point in the x axis the area
  /// below the function has to be colored.
  final double? lowerAreaLimit;

  /// The upper limit that indicates up to which point in the x axis the area
  /// below the function has to be colored.
  final double? upperAreaLimit;

  /// Creates a [_PLotBody] widget.
  const _PlotBody({
    Key? key,
    required this.plotMode,
    required this.areaColor,
    required this.lowerAreaLimit,
    required this.upperAreaLimit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, sizes) {
        final normalized = sizes.normalize().maxWidth;

        return Material(
          elevation: 8,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: ClipRRect(
            child: BlocBuilder<PlotZoomCubit, double>(
              builder: (context, state) {
                return CustomPaint(
                  painter: PlotterPainter<T>(
                    plotMode: plotMode,
                    range: state.round(),
                    colorArea: ColorArea(
                      color: areaColor,
                      startPoint: lowerAreaLimit ?? -state,
                      endPoint: upperAreaLimit ?? state,
                    ),
                  ),
                  size: Size.square(normalized),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _PlotSlider extends StatelessWidget {
  const _PlotSlider({Key? key}) : super(key: key);

  void update(BuildContext context, double value) =>
      context.read<PlotZoomCubit>().updateSlider(value);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlotZoomCubit, double>(
      builder: (context, state) {
        return Slider(
          min: 2,
          max: 10,
          value: state,
          onChanged: (value) => update(context, value),
          label: '${state.round()}',
        );
      },
    );
  }
}
