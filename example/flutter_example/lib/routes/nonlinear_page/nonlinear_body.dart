import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/nonlinear_page/model/inherited_nonlinear.dart';
import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_data_input.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_results.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/nonlinear_plot_widget.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:flutter/material.dart';

/// This widget contains the solutions of the nonlinear equation and a chart
/// which plots the function.
///
/// This widget is responsive: contents may be laid out on a single column or
/// on two columns according with the available width.
class NonlinearBody extends StatelessWidget {
  /// Creates a [NonlinearBody] widget.
  const NonlinearBody({super.key});

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

  /// Caching the single column layout subtree (small screens configuration).
  late final singleColumnLayout = SingleChildScrollView(
    key: const Key('SingleChildScrollView-mobile-responsive'),
    child: Column(
      children: [
        pageTitleWidget,
        const NonlinearDataInput(),
        const NonlinearResults(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
          ),
          child: LayoutBuilder(
            builder: (_, dimensions) {
              return Visibility(
                visible: dimensions.maxWidth >= minimumChartWidth,
                child: const NonlinearPlotWidget(),
              );
            },
          ),
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
          const NonlinearDataInput(),
          const NonlinearResults(),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    ),
  );

  String getLocalizedName() {
    final nonlinearType = context.nonlinearState.nonlinearType;

    return nonlinearType == NonlinearType.singlePoint
        ? context.l10n.single_point
        : context.l10n.bracketing;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        if (size.maxWidth <= doubleColumnPageBreakpoint) {
          // For mobile devices - all in a column
          return singleColumnLayout;
        }

        // For wider screens - plot on the right and results on the right
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
              child: const NonlinearPlotWidget(),
            ),
          ],
        );
      },
    );
  }
}
