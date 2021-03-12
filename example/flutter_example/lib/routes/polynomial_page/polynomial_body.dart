import 'package:equations_solver/routes/polynomial_page/data_input.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_results.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_widget.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/routes/utils/sections_logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// TODO write docs
class PolynomialBody extends StatelessWidget {
  const PolynomialBody();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        // Scrollable contents of the page
        Positioned.fill(top: 20, child: _ResponsiveBody()),

        // "Go back" button
        Positioned(
          top: 20,
          left: 20,
          child: _GoBackButton(),
        ),
      ],
    );
  }
}

class _ResponsiveBody extends StatefulWidget {
  const _ResponsiveBody();

  @override
  __ResponsiveBodyState createState() => __ResponsiveBodyState();
}

class __ResponsiveBodyState extends State<_ResponsiveBody> {
  /// Manually caching the page title
  late final Widget pageTitleWidget = _PageTitle(
    pageTitle: getLocalizedName(context),
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
              const DataInput(),
              const PolynomialResults(),
              const SizedBox(height: 85),
              const Padding(
                padding: EdgeInsets.fromLTRB(60, 0, 60, 20),
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
                    const DataInput(),
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
            child: _PolynomialPlot(),
          ),
        ],
      );
    });
  }
}

/// A widget containing the title of the page.
class _PageTitle extends StatelessWidget {
  /// The title of the page.
  final String pageTitle;
  const _PageTitle({
    required this.pageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: PolynomialLogo(
              size: 50,
            ),
          ),
          Text(
            pageTitle,
            style: const TextStyle(fontSize: 26, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}

/// This button simply goes back to the previous page.
class _GoBackButton extends StatelessWidget {
  const _GoBackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}

class _PolynomialPlot extends StatefulWidget {
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
                    "assets/plot.svg",
                    height: 40,
                  ),
                ),

                // The actual plot
                PlotWidget(plotMode: plotMode),
              ],
            ),
          ),
        );
      },
    );
  }
}
