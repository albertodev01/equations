import 'dart:math';

import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/polynomial_page/model/inherited_polynomial.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/plot_widget/equation_drawer_widget.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';

/// Wrapper of a [EquationDrawerWidget] widget that paints polynomial equations on the
/// screen.
class PolynomialPlotWidget extends StatelessWidget {
  /// Creates a [PolynomialPlotWidget] widget.
  const PolynomialPlotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
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
      pageLogo: const PlotIcon(),
    );
  }
}

/// A wrapper of [EquationDrawerWidget] that listens to [PolynomialState] to either draw
/// the polynomial or clear the chart.
class _PlotWidgetListener extends StatelessWidget {
  /// Creates a [_PlotWidgetListener] widget.
  const _PlotWidgetListener();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: context.polynomialState,
      builder: (context, _) {
        final algebraic = context.polynomialState.state.algebraic;

        if (algebraic != null) {
          return EquationDrawerWidget(
            plotMode: PolynomialPlot(
              algebraic: algebraic,
            ),
          );
        }

        return const EquationDrawerWidget<PolynomialPlot>();
      },
    );
  }
}
