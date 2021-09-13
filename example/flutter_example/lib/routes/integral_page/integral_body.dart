import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/integral_page/integral_data_input.dart';
import 'package:equations_solver/routes/integral_page/integral_results.dart';
import 'package:equations_solver/routes/integral_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_widget.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// This widget contains the input of the function (along with the integration
/// bounds), the result and a cartesian plane that highlights the area.
///
/// This widget is responsive: contents may be laid out on a single column or
/// on two columns according with the available width.
class IntegralBody extends StatelessWidget {
  /// Creates an [IntegralBody] widget.
  const IntegralBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DropdownCubit>(
      create: (_) => DropdownCubit(
        initialValue: IntegralDropdownItems.simpson.asString(),
      ),
      child: Stack(
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
      ),
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
    return LayoutBuilder(builder: (context, size) {
      if (size.maxWidth <= 950) {
        // For mobile devices - all in a column
        return SingleChildScrollView(
          key: const Key('SingleChildScrollView-mobile-responsive'),
          child: Column(
            children: [
              pageTitleWidget,
              const IntegralDataInput(),
              const IntegralResults(),
              const Padding(
                padding: EdgeInsets.fromLTRB(50, 60, 50, 0),
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
                    const IntegralResults(),
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
    });
  }
}

/// Puts on the screen a widget that draws mathematical functions and highlights
/// the area underneath the function.
class _IntegralPlot extends StatelessWidget {
  /// Creates a [_IntegralPlot] widget.
  const _IntegralPlot();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntegralBloc, IntegralState>(
      builder: (context, state) {
        IntegralPlot? plotMode;
        double? lowerLimit;
        double? upperLimit;

        if (state is IntegralResult) {
          plotMode = IntegralPlot(
            function: state.numericalIntegration,
          );

          lowerLimit = state.numericalIntegration.lowerBound;
          upperLimit = state.numericalIntegration.upperBound;
        }

        return Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Some spacing
                const SizedBox(
                  height: 50,
                ),

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
                  areaColor: Colors.amber.withAlpha(60),
                  lowerAreaLimit: lowerLimit,
                  upperAreaLimit: upperLimit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}