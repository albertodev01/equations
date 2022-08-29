import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/integral_page/integral_data_input.dart';
import 'package:equations_solver/routes/integral_page/integral_results.dart';
import 'package:equations_solver/routes/integral_page/utils/integral_plot_widget.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:flutter/material.dart';

/// This widget contains the input for the function (along with the integration
/// bounds). There also is a cartesian plane to draw the function and highlight
/// the enclosed area.
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
          left: 10,
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
    return LayoutBuilder(
      builder: (context, size) {
        if (size.maxWidth <= doubleColumnPageBreakpoint) {
          // For mobile devices - all in a column
          return const _SingleColumnLayout();
        }

        // For wider screens - plot on the right and results on the right
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Input and results
            SizedBox(
              width: size.maxWidth / 3,
              child: const _DoubleColumnLayout(),
            ),

            // Plot
            SizedBox(
              width: size.maxWidth / 2.3,
              child: const IntegralPlotWidget(),
            ),
          ],
        );
        ;
      },
    );
  }
}

/// Lays the page contents on a single column.
class _SingleColumnLayout extends StatelessWidget {
  /// Creates a [_SingleColumnLayout] widget.
  const _SingleColumnLayout();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const Key('SingleChildScrollView-mobile-responsive'),
      child: Column(
        children: [
          PageTitle(
            pageTitle: context.l10n.integrals,
            pageLogo: const IntegralLogo(
              size: 50,
            ),
          ),
          const IntegralDataInput(),
          const IntegralResultsWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 35,
            ),
            child: LayoutBuilder(
              builder: (_, dimensions) {
                return Visibility(
                  visible: dimensions.maxWidth >= minimumChartWidth,
                  child: const IntegralPlotWidget(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Lays the page contents on two columns.
class _DoubleColumnLayout extends StatelessWidget {
  /// Creates a [_DoubleColumnLayout] widget.
  const _DoubleColumnLayout();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        key: const Key('SingleChildScrollView-desktop-responsive'),
        child: Column(
          children: [
            PageTitle(
              pageTitle: context.l10n.integrals,
              pageLogo: const IntegralLogo(
                size: 50,
              ),
            ),
            const IntegralDataInput(),
            const IntegralResultsWidget(),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
