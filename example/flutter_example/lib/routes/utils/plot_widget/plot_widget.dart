import 'package:equations_solver/blocs/slider/slider_bloc.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/plot_widget/plotter_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlotWidget<T> extends StatelessWidget {
  final PlotMode<T>? plotMode;
  const PlotWidget({
    this.plotMode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SliderBloc>(
      create: (_) => SliderBloc(),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 45, 50, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PlotBody<T>(
                plotMode: plotMode,
              ),
              const SizedBox(height: 35),
              if (plotMode != null) const _PlotSlider(),
            ],
          )),
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
            child: BlocBuilder<SliderBloc, double>(
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
      context.read<SliderBloc>().add(value);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SliderBloc, double>(
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
