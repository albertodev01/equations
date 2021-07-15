import 'package:equations/equations.dart' as equations;
import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/blocs/slider/slider.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_data_input.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_results.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_mode.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_widget.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/routes/utils/sections_logos.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// This widget contains the solutions of the nonlinear equation and a chart
/// which plots the function.
///
/// This widget is responsive: contents may be laid out on a single column or
/// on two columns according with the available width.
class NonlinearBody extends StatefulWidget {
  /// Creates a [PolynomialBody] widget.
  const NonlinearBody({
    Key? key,
  }) : super(key: key);

  @override
  _NonlinearBodyState createState() => _NonlinearBodyState();
}

class _NonlinearBodyState extends State<NonlinearBody> {
  late final initialValue = _initialValue(context);

  String _initialValue(BuildContext context) {
    final type = context.read<NonlinearBloc>().nonlinearType;
    return type == NonlinearType.singlePoint ? 'Newton' : 'Bisection';
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SliderCubit>(
          create: (_) => SliderCubit(
            minValue: 2,
            maxValue: 15,
            current: 8,
          ),
        ),
        BlocProvider<DropdownCubit>(
          create: (_) => DropdownCubit(
            initialValue: initialValue,
          ),
        ),
      ],
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
    pageTitle: getLocalizedName(context),
    pageLogo: const NonlinearLogo(
      size: 50,
    ),
  );

  /// Getting the title of the page according with the kind of algorithms that
  /// are going to be used.
  String getLocalizedName(BuildContext context) {
    final nonlinearType = context.read<NonlinearBloc>().nonlinearType;

    return nonlinearType == NonlinearType.singlePoint
        ? context.l10n.single_point
        : context.l10n.bracketing;
  }

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
              const NonlinearDataInput(),
              const NonlinearResults(),
              const Padding(
                padding: EdgeInsets.fromLTRB(50, 60, 50, 0),
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
class _NonlinearPlot extends StatefulWidget {
  /// Creates a [_NonlinearPlot] widget.
  const _NonlinearPlot();

  @override
  _NonlinearPlotState createState() => _NonlinearPlotState();
}

class _NonlinearPlotState extends State<_NonlinearPlot> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonlinearBloc, NonlinearState>(
      builder: (context, state) {
        NonlinearPlot? plotMode;

        if (state is NonlinearGuesses) {
          plotMode = NonlinearPlot(nonLinear: state.nonLinear);
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
                PlotWidget<equations.NonLinear>(
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
