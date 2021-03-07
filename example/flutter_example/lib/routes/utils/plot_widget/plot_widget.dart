import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/plot_widget/plotter_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlotWidget<T> extends StatelessWidget {
  final PlotMode<T> plotMode;
  const PlotWidget({
    required this.plotMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 45, 50, 40),
      child: LayoutBuilder(
        builder: (context, sizes) {
          final normalized = sizes.normalize().maxWidth;

          return Material(
            elevation: 8,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: CustomPaint(
              painter: PlotterPainter<T>(
                plotMode: plotMode,
                range: 3,
              ),
              size: Size.square(normalized),
            ),
          );
        },
      ),
    );
  }
}