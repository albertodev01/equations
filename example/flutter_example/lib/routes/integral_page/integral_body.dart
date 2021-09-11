import 'dart:math';

import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';
import 'package:equations_solver/localization/localization.dart';
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
class IntegralBody extends StatelessWidget {
  /// Creates an [IntegralBody] widget.
  const IntegralBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        // Scrollable contents of the page
        Positioned.fill(
          child: _PageBody(),
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
class _PageBody extends StatefulWidget {
  /// Creates a [_PageBody] widget.
  const _PageBody();

  @override
  _PageBodyState createState() => _PageBodyState();
}

class _PageBodyState extends State<_PageBody> {
  /// Manually caching the page title
  late final Widget pageTitleWidget = PageTitle(
    pageTitle: context.l10n.integrals,
    pageLogo: const IntegralLogo(
      size: 50,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _IntegralPlot(),
          ],
        ),
      ),
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
    return BlocBuilder<IntegralBloc, IntegralState>(
      builder: (context, state) {
        IntegralPlot? plotMode;

        if (state is IntegralResult) {
          plotMode = IntegralPlot(
            function: state.numericalIntegration,
          );
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
