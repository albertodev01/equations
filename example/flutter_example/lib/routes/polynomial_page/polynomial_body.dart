import 'package:equations_solver/blocs/slider/slider.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_data_input.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_results.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_widget.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/routes/utils/sections_logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// This widget contains the solutions of the polynomial equation and a chart
/// which plots the function.
///
/// This widget is responsive: contents may be laid out on a single column or
/// on two columns according with the available width.
class PolynomialBody extends StatelessWidget {
  /// Creates a [PolynomialBody] widget.
  const PolynomialBody();

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
  /// Manually caching the page title
  late final Widget pageTitleWidget = PageTitle(
    pageTitle: getLocalizedName(context),
    pageLogo: const PolynomialLogo(
      size: 50,
    ),
  );

  /// Getting the title of the page according with the type of polynomial that
  /// is going to be solved.
  String getLocalizedName(BuildContext context) {
    final polynomialType = context.read<PolynomialBloc>().polynomialType;

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
    return LayoutBuilder(builder: (context, size) {
      if (size.maxWidth <= 950) {
        // For mobile devices - all in a column
        return SingleChildScrollView(
          child: Column(
            children: [
              pageTitleWidget,
              const PolynomialDataInput(),
              const PolynomialResults(),
              const Padding(
                padding: EdgeInsets.fromLTRB(50, 60, 50, 0),
                child: _PolynomialPlot(),
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
                child: Column(
                  children: [
                    pageTitleWidget,
                    const PolynomialDataInput(),
                    const PolynomialResults(),
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
    });
  }
}

/// Puts on the screen a widget that draws mathematical functions.
class _PolynomialPlot extends StatefulWidget {
  /// Creates a [_PolynomialPlot] widget.
  const _PolynomialPlot();

  @override
  __PolynomialPlotState createState() => __PolynomialPlotState();
}

class __PolynomialPlotState extends State<_PolynomialPlot> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PolynomialBloc, PolynomialState>(
      builder: (context, state) {
        PolynomialPlot? plotMode;

        if (state is PolynomialRoots) {
          plotMode = PolynomialPlot(algebraic: state.algebraic);
        }

        return Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Title
                SectionTitle(
                  pageTitle: context.l10n.chart,
                  icon: SvgPicture.asset(
                    'assets/plot.svg',
                    height: 40,
                  ),
                ),

                // The actual plot
                PlotWidget(
                  plotMode: plotMode,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
