import 'dart:math';

import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/integral_page/model/inherited_integral.dart';
import 'package:equations_solver/routes/integral_page/model/integral_state.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/plot_widget/equation_drawer_widget.dart';
import 'package:equations_solver/routes/utils/plot_widget/function_evaluators.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';

/// Wrapper of a [EquationDrawerWidget] widget that draws equations and
/// highlights the area below the function.
class IntegralPlotWidget extends StatelessWidget {
  /// Creates a [IntegralPlotWidget] widget.
  const IntegralPlotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          const _PlotTitle(),

          // The actual plot
          LayoutBuilder(
            builder: (context, dimensions) {
              final width = min<double>(
                dimensions.maxWidth,
                maxWidthPlot,
              );

              return SizedBox(
                width: width,
                child: const _PlotWidgetListener(),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// A wrapper of [PageTitle] placed above a [EquationDrawerWidget].
class _PlotTitle extends StatelessWidget {
  /// Creates a [_PlotTitle] widget.
  const _PlotTitle();

  @override
  Widget build(BuildContext context) {
    return PageTitle(
      pageTitle: context.l10n.chart,
      pageLogo: const CartesianPlane(),
    );
  }
}

/// A wrapper of [EquationDrawerWidget] that listens to [IntegralState] to
/// either draw the function or clear the chart.
class _PlotWidgetListener extends StatelessWidget {
  /// Creates a [_PlotWidgetListener] widget.
  const _PlotWidgetListener();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: context.integralState,
      builder: (context, _) {
        final integral = context.integralState.state.numericalIntegration;

        if (integral != null) {
          return EquationDrawerWidget(
            plotMode: IntegralEvaluator(
              function: integral,
            ),
            areaColor: Colors.amber.withAlpha(60),
            lowerAreaLimit: integral.lowerBound,
            upperAreaLimit: integral.upperBound,
          );
        }

        return const EquationDrawerWidget<IntegralEvaluator>();
      },
    );
  }
}
