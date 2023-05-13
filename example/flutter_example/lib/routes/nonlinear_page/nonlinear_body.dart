import 'package:equations_solver/routes/nonlinear_page/nonlinear_data_input.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_results.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/nonlinear_plot_widget.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/nonlinear_title_localizer.dart';
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
    return const Stack(
      children: [
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

          // For wider screens - plot on the right and results on the right
          return const _DoubleColumnLayout();
        },
      ),
    );
  }
}

/// Lays the page contents on a single column.
class _SingleColumnLayout extends StatelessWidget with NonlinearTitleLocalizer {
  /// Creates a [_SingleColumnLayout] widget.
  const _SingleColumnLayout();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const Key('SingleChildScrollView-mobile-responsive'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PageTitle(
            pageTitle: getLocalizedName(context),
            pageLogo: const NonlinearLogo(
              size: 50,
            ),
          ),
          const NonlinearDataInput(),
          const NonlinearResults(),
          const NonlinearPlotWidget(),
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
    return const Center(
      child: SingleChildScrollView(
        key: Key('SingleChildScrollView-desktop-responsive'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Input and results
            Expanded(
              child: _DoubleColumnLeftContent(),
            ),

            // Plot
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: NonlinearPlotWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The left column [_ResponsiveBody] when the viewport is large enough.
class _DoubleColumnLeftContent extends StatelessWidget
    with NonlinearTitleLocalizer {
  /// Creates a [_DoubleColumnLeftContent] widget.
  const _DoubleColumnLeftContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PageTitle(
            pageTitle: getLocalizedName(context),
            pageLogo: const NonlinearLogo(
              size: 50,
            ),
          ),
          const NonlinearDataInput(),
          const NonlinearResults(),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
