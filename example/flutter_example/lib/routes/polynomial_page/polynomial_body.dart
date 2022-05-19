import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/polynomial_page/model/inherited_polynomial.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_data_input.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_results.dart';
import 'package:equations_solver/routes/polynomial_page/utils/polynomial_plot.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:flutter/material.dart';

/// This widget is used to solve polynomial equations and plot the function in
/// a cartesian plane.
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

  /// Caching the single column layout subtree (small screens configuration).
  late final singleColumnLayout = SingleChildScrollView(
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
          child: PolynomialPlotWidget(),
        ),
      ],
    ),
  );

  /// Caching the double column layout subtree (large screens configuration)
  late final doubleColumnLayout = Center(
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
          return singleColumnLayout;
        }

        // For wider screens - plot on the right and results on the left
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Input and results
            SizedBox(
              width: size.maxWidth / 3,
              height: double.infinity,
              child: doubleColumnLayout,
            ),

            // Plot
            SizedBox(
              width: size.maxWidth / 2.3,
              height: double.infinity,
              child: const PolynomialPlotWidget(),
            ),
          ],
        );
      },
    );
  }
}
