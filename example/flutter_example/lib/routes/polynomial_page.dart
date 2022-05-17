import 'package:equations_solver/blocs/textfield_values/textfield_values.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/plot_zoom/inherited_plot_zoom.dart';
import 'package:equations_solver/routes/models/plot_zoom/plot_zoom_state.dart';
import 'package:equations_solver/routes/polynomial_page/model/inherited_polynomial.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_body.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/routes/utils/plot_widget/plot_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This page contains a series of polynomial equations solvers. There are 4
/// tabs dedicated to particular polynomial equations:
///
///  - Linear
///  - Quadratic
///  - Cubic
///  - Quartic
///
/// Each tab also features a [PlotWidget] which plots the function on a cartesian
/// plane.
class PolynomialPage extends StatefulWidget {
  /// Creates a [PolynomialPage] widget.
  const PolynomialPage({super.key});

  @override
  _PolynomialPageState createState() => _PolynomialPageState();
}

class _PolynomialPageState extends State<PolynomialPage> {
  // TextFields values blocs
  final linearTextfields = TextFieldValuesCubit();
  final quadraticTextfields = TextFieldValuesCubit();
  final cubicTextfields = TextFieldValuesCubit();
  final quarticTextfields = TextFieldValuesCubit();

  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.firstDegree,
      content: InheritedPolynomial(
        polynomialState: PolynomialState(PolynomialType.linear),
        child: InheritedPlotZoom(
          plotZoomState: PlotZoomState(
            minValue: 2,
            maxValue: 10,
            initial: 3,
          ),
          child: MultiBlocProvider(
            providers: [
              BlocProvider<TextFieldValuesCubit>.value(
                value: linearTextfields,
              ),
            ],
            child: const PolynomialBody(),
          ),
        ),
      ),
    ),
    NavigationItem(
      title: context.l10n.secondDegree,
      content: InheritedPolynomial(
        polynomialState: PolynomialState(PolynomialType.quadratic),
        child: InheritedPlotZoom(
          plotZoomState: PlotZoomState(
            minValue: 2,
            maxValue: 10,
            initial: 3,
          ),
          child: MultiBlocProvider(
            providers: [
              BlocProvider<TextFieldValuesCubit>.value(
                value: quadraticTextfields,
              ),
            ],
            child: const PolynomialBody(),
          ),
        ),
      ),
    ),
    NavigationItem(
      title: context.l10n.thirdDegree,
      content: InheritedPolynomial(
        polynomialState: PolynomialState(PolynomialType.cubic),
        child: InheritedPlotZoom(
          plotZoomState: PlotZoomState(
            minValue: 2,
            maxValue: 10,
            initial: 3,
          ),
          child: MultiBlocProvider(
            providers: [
              BlocProvider<TextFieldValuesCubit>.value(
                value: cubicTextfields,
              ),
            ],
            child: const PolynomialBody(),
          ),
        ),
      ),
    ),
    NavigationItem(
      title: context.l10n.fourthDegree,
      content: InheritedPolynomial(
        polynomialState: PolynomialState(PolynomialType.quartic),
        child: InheritedPlotZoom(
          plotZoomState: PlotZoomState(
            minValue: 2,
            maxValue: 10,
            initial: 3,
          ),
          child: MultiBlocProvider(
            providers: [
              BlocProvider<TextFieldValuesCubit>.value(
                value: quarticTextfields,
              ),
            ],
            child: const PolynomialBody(),
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
