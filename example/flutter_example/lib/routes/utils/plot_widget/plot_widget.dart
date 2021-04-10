import 'package:equations_solver/blocs/slider/slider.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/plot_widget/plotter_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget draws a cartesian plane and, if there's a [plotMode], it also
/// plots a real function `f(x)`.
///
/// If [plotMode] is not `null`, then a slider is also added below the widget to
/// scale the image.
///
/// If [plotMode] is `null`, the slider doesn't appear and the widget only draws
/// a cartesian plane (with no function within).
class PlotWidget<T> extends StatelessWidget {
  /// Provides the ability to evaluate a real function on a point.
  final PlotMode<T>? plotMode;

  /// Creates a [PlotWidget] instance.
  const PlotWidget({
    this.plotMode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SliderCubit>(
      create: (_) => SliderCubit(
        minValue: 2,
        maxValue: 10,
        current: 3,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(50, 45, 50, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // The plot
            _PlotBody<T>(
              plotMode: plotMode,
            ),

            // Some spacing
            const SizedBox(height: 35),

            // Placing the slider ONLY if there's a function
            if (plotMode != null) const _PlotSlider(),
          ],
        ),
      ),
    );
  }
}

class _PlotBody<T> extends StatelessWidget {
  final PlotMode<T>? plotMode;
  const _PlotBody({
    required this.plotMode,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, sizes) {
        final normalized = sizes.normalize().maxWidth;

        return Material(
          elevation: 8,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: ClipRRect(
            child: BlocBuilder<SliderCubit, double>(
              buildWhen: (prev, curr) => prev != curr,
              builder: (context, state) {
                return CustomPaint(
                  painter: PlotterPainter<T>(
                    plotMode: plotMode,
                    range: state.round(),
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
  const _PlotSlider();

  void update(BuildContext context, double value) =>
      context.read<SliderCubit>().updateSlider(value);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SliderCubit, double>(
      builder: (context, state) {
        return Slider(
          min: 2,
          max: 10,
          divisions: 8,
          value: state,
          onChanged: (value) => update(context, value),
          label: '${state.round()}',
        );
      },
    );
  }
}
