import 'dart:math';

import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/integral_page/integral_data_input.dart';
import 'package:equations_solver/routes/integral_page/integral_results.dart';
import 'package:equations_solver/routes/integral_page/model/inherited_integral.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_widget.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';

/// This widget contains the input of the function (along with the integration
/// bounds), the result and a cartesian plane that highlights the area.
///
/// This widget is responsive: contents may be laid out on a single column or
/// on two columns according with the available width.
class IntegralBody extends StatelessWidget {
  /// Creates an [IntegralBody] widget.
  const IntegralBody({super.key});

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
    pageTitle: context.l10n.integrals,
    pageLogo: const IntegralLogo(
      size: 50,
    ),
  );

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
                const IntegralDataInput(),
                const IntegralResultsWidget(),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                  child: _IntegralPlot(),
                ),
              ],
            ),
          );
        }

        // For wider screens - plot on the right and results on the right
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
                      const IntegralDataInput(),
                      const IntegralResultsWidget(),
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
              child: const _IntegralPlot(),
            ),
          ],
        );
      },
    );
  }
}

/// Puts on the screen a widget that draws mathematical functions and highlights
/// the area underneath the function.
class _IntegralPlot extends StatelessWidget {
  /// Creates a [_IntegralPlot] widget.
  const _IntegralPlot();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Title
            const _PlotTitle(),

            // The actual plot
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
      animation: context.integralState,
      builder: (context, _) {
        final integral = context.integralState.state.numericalIntegration;

        if (integral != null) {
          return PlotWidget(
            plotMode: IntegralPlot(
              function: integral,
            ),
            areaColor: Colors.amber.withAlpha(60),
            lowerAreaLimit: integral.lowerBound,
            upperAreaLimit: integral.upperBound,
          );
        }

        return const PlotWidget();
      },
    );
  }
}
