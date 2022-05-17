import 'package:equations_solver/blocs/plot_zoom/plot_zoom.dart';
import 'package:equations_solver/blocs/precision_slider/precision_slider.dart';
import 'package:equations_solver/blocs/textfield_values/textfield_values.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:equations_solver/routes/nonlinear_page/model/inherited_nonlinear.dart';
import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';
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
///
/// Each tab also features a [PlotWidget] which plots the function on a cartesian
/// plane.
class NonlinearPage extends StatefulWidget {
  /// Creates a [NonlinearPage] widget.
  const NonlinearPage({super.key});

  @override
  _NonlinearPageState createState() => _NonlinearPageState();
}

class _NonlinearPageState extends State<NonlinearPage> {
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
    maxValue: 15,
  );
  final bracketingPrecision = PrecisionSliderCubit(
    minValue: 1,
    maxValue: 15,
  );

  // TextFields values blocs
  final singlePointTextfields = TextFieldValuesCubit();
  final bracketingTextfields = TextFieldValuesCubit();

  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.single_point,
      content: InheritedNonlinear(
        nonlinearState: NonlinearState(NonlinearType.singlePoint),
        child: InheritedDropdownValue(
          dropdownValue: ValueNotifier<String>(
            NonlinearDropdownItems.newton.asString(),
          ),
          child: MultiBlocProvider(
            providers: [
              BlocProvider<PlotZoomCubit>.value(
                value: singlePlot,
              ),
              BlocProvider<PrecisionSliderCubit>.value(
                value: singlePrecision,
              ),
              BlocProvider<TextFieldValuesCubit>.value(
                value: singlePointTextfields,
              ),
            ],
            child: const NonlinearBody(
              key: Key('NonlinearPage-SinglePoint-Body'),
            ),
          ),
        ),
      ),
    ),
    NavigationItem(
      title: context.l10n.bracketing,
      content: InheritedNonlinear(
        nonlinearState: NonlinearState(NonlinearType.singlePoint),
        child: InheritedDropdownValue(
          dropdownValue: ValueNotifier<String>(
            NonlinearDropdownItems.bisection.asString(),
          ),
          child: MultiBlocProvider(
            providers: [
              BlocProvider<PlotZoomCubit>.value(
                value: bracketingPlot,
              ),
              BlocProvider<PrecisionSliderCubit>.value(
                value: bracketingPrecision,
              ),
              BlocProvider<TextFieldValuesCubit>.value(
                value: bracketingTextfields,
              ),
            ],
            child: const NonlinearBody(
              key: Key('NonlinearPage-Bracketing-Body'),
            ),
          ),
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
