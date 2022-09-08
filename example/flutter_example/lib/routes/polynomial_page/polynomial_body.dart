import 'package:equations_solver/routes/polynomial_page/polynomial_data_input.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_results.dart';
import 'package:equations_solver/routes/polynomial_page/utils/polynomial_plot_widget.dart';
import 'package:equations_solver/routes/polynomial_page/utils/polynomial_title_localizer.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:flutter/material.dart';

/// This widget is used to solve polynomial equations. It also draws the
/// function in a cartesian plane.
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
class _ResponsiveBody extends StatelessWidget {
  /// Creates a [_ResponsiveBody] widget.
  const _ResponsiveBody();

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: LayoutBuilder(
        builder: (context, size) {
          if (size.maxWidth <= doubleColumnPageBreakpoint) {
            // For mobile devices - all in a column
            return const _SingleColumnLayout();
          }

          // For wider screens - plot on the right and results on the left
          return Center(
            child: SingleChildScrollView(
              key: const Key('SingleChildScrollView-desktop-responsive'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  // Input and results
                  Expanded(
                    child: _DoubleColumnLeftContent(),
                  ),

                  // Plot
                  Expanded(
                    child: PolynomialPlotWidget(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Lays the page contents on a single column.
class _SingleColumnLayout extends StatelessWidget
    with PolynomialTitleLocalizer {
  /// Creates a [_SingleColumnLayout] widget.
  const _SingleColumnLayout();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const Key('SingleChildScrollView-mobile-responsive'),
      child: Column(
        children: [
          PageTitle(
            pageTitle: getLocalizedName(context),
            pageLogo: const PolynomialLogo(
              size: 50,
            ),
          ),
          const PolynomialDataInput(),
          const PolynomialResults(),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: LayoutBuilder(
              builder: (_, dimensions) {
                return Visibility(
                  visible: dimensions.maxWidth >= minimumChartWidth,
                  child: const PolynomialPlotWidget(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// The left column [_ResponsiveBody] when the viewport is large enough.
class _DoubleColumnLeftContent extends StatelessWidget
    with PolynomialTitleLocalizer {
  /// Creates a [_DoubleColumnLeftContent] widget.
  const _DoubleColumnLeftContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          PageTitle(
            pageTitle: getLocalizedName(context),
            pageLogo: const PolynomialLogo(
              size: 50,
            ),
          ),
          const PolynomialDataInput(),
          const PolynomialResults(),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
