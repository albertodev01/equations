import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/blocs/plot_zoom/plot_zoom.dart';
import 'package:equations_solver/blocs/precision_slider/precision_slider.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_body.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This page contains a series of nonlinear equations solvers. There are 2 tabs
/// that group a series of well-known root finding algorithms:
///
///  - Single point methods (like Newton's method)
///  - Bracketing methods (like secant method or bisection)
class NonlinearPage extends StatefulWidget {
  /// Creates a [NonlinearPage] widget.
  const NonlinearPage({Key? key}) : super(key: key);

  @override
  _NonlinearPageState createState() => _NonlinearPageState();
}

class _NonlinearPageState extends State<NonlinearPage> {
  /*
   * Caching blocs here in the state since `EquationScaffold` is creating a
   * tab view and thus `BlocProvider`s might be destroyed when the body is not
   * visible anymore.
   *
   */

  // Bloc for solving equations
  final singlePointBloc = NonlinearBloc(NonlinearType.singlePoint);
  final bracketingBloc = NonlinearBloc(NonlinearType.bracketing);

  // Blocs for keeping the zoom state of the plot widget
  final singlePlot = PlotZoomCubit(
    minValue: 2,
    maxValue: 10,
    initial: 3,
  );
  final bracketingPlot = PlotZoomCubit(
    minValue: 2,
    maxValue: 10,
    initial: 3,
  );

  // Bloc for the algorithm precision
  final singlePrecision = PrecisionSliderCubit(
    minValue: 1,
    maxValue: 10,
  );
  final bracketingPrecision = PrecisionSliderCubit(
    minValue: 1,
    maxValue: 10,
  );

  // Bloc for the algorithm selection
  final dropdownSingle = DropdownCubit(
    initialValue: NonlinearDropdownItems.newton.asString(),
  );
  final dropdownBracketing = DropdownCubit(
    initialValue: NonlinearDropdownItems.bisection.asString(),
  );

  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.single_point,
      content: MultiBlocProvider(
        providers: [
          BlocProvider<NonlinearBloc>.value(
            value: singlePointBloc,
          ),
          BlocProvider<PlotZoomCubit>.value(
            value: singlePlot,
          ),
          BlocProvider<PrecisionSliderCubit>.value(
            value: singlePrecision,
          ),
          BlocProvider<DropdownCubit>.value(
            value: dropdownSingle,
          ),
        ],
        child: const NonlinearBody(
          key: Key('NonlinearPage-SinglePoint-Body'),
        ),
      ),
    ),
    NavigationItem(
      title: context.l10n.bracketing,
      content: MultiBlocProvider(
        providers: [
          BlocProvider<NonlinearBloc>.value(
            value: bracketingBloc,
          ),
          BlocProvider<PlotZoomCubit>.value(
            value: bracketingPlot,
          ),
          BlocProvider<PrecisionSliderCubit>.value(
            value: bracketingPrecision,
          ),
          BlocProvider<DropdownCubit>.value(
            value: dropdownBracketing,
          ),
        ],
        child: const NonlinearBody(
          key: Key('NonlinearPage-Bracketing-Body'),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return EquationScaffold.navigation(
      navigationItems: cachedItems,
    );
  }
}
