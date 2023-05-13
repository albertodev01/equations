import 'dart:math';

import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/nonlinear_page/model/inherited_nonlinear.dart';
import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/plot_widget/equation_drawer_widget.dart';
import 'package:equations_solver/routes/utils/plot_widget/function_evaluators.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';

/// Wrapper of a [EquationDrawerWidget] widget that paints nonlinear equations
/// on the screen.
class NonlinearPlotWidget extends StatelessWidget {
  /// Creates a [NonlinearPlotWidget] widget.
  const NonlinearPlotWidget({super.key});

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
              final width = min<double>(dimensions.maxWidth, maxWidthPlot);

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

/// A wrapper of [EquationDrawerWidget] that listens to [NonlinearState] to
/// either draw the equation or clear the chart.
class _PlotWidgetListener extends StatelessWidget {
  /// Creates a [_PlotWidgetListener] widget.
  const _PlotWidgetListener();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: context.nonlinearState,
      builder: (context, _) {
        final nonlinear = context.nonlinearState.state.nonlinear;

        if (nonlinear != null) {
          return EquationDrawerWidget(
            plotMode: NonlinearEvaluator(
              nonLinear: nonlinear,
            ),
          );
        }

        return const EquationDrawerWidget<NonlinearEvaluator>();
      },
    );
  }
}
