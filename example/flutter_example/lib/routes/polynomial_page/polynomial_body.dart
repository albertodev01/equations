import 'dart:math';

import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/polynomial_page/model/inherited_polynomial.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_data_input.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_results.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_widget.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';

/// This widget contains the solutions of the polynomial equation and a chart
/// to plot the function.
///
/// This widget is responsive: contents may be laid out on a single column or
/// on two columns according with the available space.
class PolynomialBody extends StatelessWidget {
  /// Creates a [PolynomialBody] widget.
  const PolynomialBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        // Scrollable contents of the page
        Positioned.fill(
          child: _ResponsiveBody(),
        ),

        // "Go back" button
        Positioned(
          top: 20,
          left: 20,
          child: GoBackButton(),
        ),
      ],
    );
  }
}

/// Determines whether the contents should appear in 1 or 2 columns.
class _ResponsiveBody extends StatefulWidget {
  /// Creates a [_ResponsiveBody] widget.
  const _ResponsiveBody();

  @override
  __ResponsiveBodyState createState() => __ResponsiveBodyState();
}

class __ResponsiveBodyState extends State<_ResponsiveBody> {
  /// Manually caching the page title.
  late final Widget pageTitleWidget = PageTitle(
    pageTitle: getLocalizedName(),
    pageLogo: const PolynomialLogo(
      size: 50,
    ),
  );

  /// Getting the title of the page according with the type of polynomial that
  /// is going to be solved.
  String getLocalizedName() {
    final polynomialType = context.polynomialState.polynomialType;

    switch (polynomialType) {
      case PolynomialType.linear:
        return context.l10n.firstDegree;
      case PolynomialType.quadratic:
        return context.l10n.secondDegree;
      case PolynomialType.cubic:
        return context.l10n.thirdDegree;
      case PolynomialType.quartic:
        return context.l10n.fourthDegree;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        if (size.maxWidth <= doubleColumnPageBreakpoint) {
          // For mobile devices - all in a column
          return SingleChildScrollView(
            key: const Key('SingleChildScrollView-mobile-responsive'),
            child: Column(
              children: [
                pageTitleWidget,
                const PolynomialDataInput(),
                const PolynomialResults(),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                  child: _PolynomialPlot(),
                ),
              ],
            ),
          );
        }

        // For wider screens - plot on the right and results on the left
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Input and results
            SizedBox(
              width: size.maxWidth / 3,
              height: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  key: const Key('SingleChildScrollView-desktop-responsive'),
                  child: Column(
                    children: [
                      pageTitleWidget,
                      const PolynomialDataInput(),
                      const PolynomialResults(),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Plot
            SizedBox(
              width: size.maxWidth / 2.3,
              height: double.infinity,
              child: const _PolynomialPlot(),
            ),
          ],
        );
      },
    );
  }
}

/// Puts on the screen a widget that draws mathematical functions.
class _PolynomialPlot extends StatelessWidget {
  /// Creates a [_PolynomialPlot] widget.
  const _PolynomialPlot();

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
                final width = min<double>(
                  dimensions.maxWidth,
                  maxWidthPlot,
                );

                return SizedBox(
                  width: width,
                  child: const PlotWidgetListener(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// A wrapper of [PageTitle] placed above a [PlotWidget].
class _PlotTitle extends StatelessWidget {
  /// Creates a [_PlotTitle] widget.
  const _PlotTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTitle(
      pageTitle: context.l10n.chart,
      pageLogo: const PlotIcon(),
    );
  }
}

/// TODO
class PlotWidgetListener extends StatelessWidget {
  const PlotWidgetListener({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: context.polynomialState,
      builder: (context, _) {
        final algebraic = context.polynomialState.state.algebraic;

        if (algebraic != null) {
          return PlotWidget(
            plotMode: PolynomialPlot(
              algebraic: algebraic,
            ),
          );
        }

        return const PlotWidget();
      },
    );
  }
}
