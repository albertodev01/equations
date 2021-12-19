import 'dart:math';

import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_data_input.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_results.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_widget.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget contains the solutions of the nonlinear equation and a chart
/// which plots the function.
///
/// This widget is responsive: contents may be laid out on a single column or
/// on two columns according with the available width.
class NonlinearBody extends StatelessWidget {
  /// Creates a [NonlinearBody] widget.
  const NonlinearBody({Key? key}) : super(key: key);

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
    pageLogo: const NonlinearLogo(
      size: 50,
    ),
  );

  String getLocalizedName() {
    final nonlinearType = context.read<NonlinearBloc>().nonlinearType;

    return nonlinearType == NonlinearType.singlePoint
        ? context.l10n.single_point
        : context.l10n.bracketing;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      if (size.maxWidth <= doubleColumnPageBreakpoint) {
        // For mobile devices - all in a column
        return SingleChildScrollView(
          key: const Key('SingleChildScrollView-mobile-responsive'),
          child: Column(
            children: [
              pageTitleWidget,
              const NonlinearDataInput(),
              const NonlinearResults(),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: _NonlinearPlot(),
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
                    const NonlinearDataInput(),
                    const NonlinearResults(),
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
            child: const _NonlinearPlot(),
          ),
        ],
      );
    });
  }
}

/// Puts on the screen a widget that draws mathematical functions.
class _NonlinearPlot extends StatelessWidget {
  /// Creates a [_NonlinearPlot] widget.
  const _NonlinearPlot();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonlinearBloc, NonlinearState>(
      builder: (context, state) {
        NonlinearPlot? plotMode;

        if (state is NonlinearGuesses) {
          plotMode = NonlinearPlot(
            nonLinear: state.nonLinear,
          );
        }

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
                      child: PlotWidget(
                        plotMode: plotMode,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A wrapper of [PageTitle] placed above a [PlotWidget].
class _PlotTitle extends StatelessWidget {
  /// Creates a [_PlotTitle] widget.
  const _PlotTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTitle(
      pageTitle: context.l10n.chart,
      pageLogo: const PlotIcon(),
    );
  }
}
