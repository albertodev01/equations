import 'package:equations_solver/blocs/plot_zoom/plot_zoom.dart';
import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_body.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This page contains a series of polynomial equations solvers. There are 4
/// tabs dedicated to particular polynomial equations
///
///  - Linear
///  - Quadratic
///  - Cubic
///  - Quartic
class PolynomialPage extends StatefulWidget {
  /// Creates a [PolynomialPage] widget.
  const PolynomialPage({Key? key}) : super(key: key);

  @override
  _PolynomialPageState createState() => _PolynomialPageState();
}

class _PolynomialPageState extends State<PolynomialPage> {
  /*
   * Caching blocs here in the state since `EquationScaffold` is creating a
   * tab view and thus `BlocProvider`s might be destroyed when the body is not
   * visible anymore.
   *
   */

  // Blocs for solving polynomials
  final linearBloc = PolynomialBloc(PolynomialType.linear);
  final quadraticBloc = PolynomialBloc(PolynomialType.quadratic);
  final cubicBloc = PolynomialBloc(PolynomialType.cubic);
  final quarticBloc = PolynomialBloc(PolynomialType.quartic);

  // Blocs for keeping the zoom state of the plot widget
  final linearPlot = PlotZoomCubit(minValue: 2, maxValue: 10, initial: 3);
  final quadraticPlot = PlotZoomCubit(minValue: 2, maxValue: 10, initial: 3);
  final cubicPlot = PlotZoomCubit(minValue: 2, maxValue: 10, initial: 3);
  final quarticPlot = PlotZoomCubit(minValue: 2, maxValue: 10, initial: 3);

  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.firstDegree,
      content: MultiBlocProvider(
        providers: [
          BlocProvider<PolynomialBloc>.value(
            value: linearBloc,
          ),
          BlocProvider<PlotZoomCubit>.value(
            value: linearPlot,
          ),
        ],
        child: const PolynomialBody(),
      ),
    ),
    NavigationItem(
      title: context.l10n.secondDegree,
      content: MultiBlocProvider(
        providers: [
          BlocProvider<PolynomialBloc>.value(
            value: quadraticBloc,
          ),
          BlocProvider<PlotZoomCubit>.value(
            value: quadraticPlot,
          ),
        ],
        child: const PolynomialBody(),
      ),
    ),
    NavigationItem(
      title: context.l10n.thirdDegree,
      content: MultiBlocProvider(
        providers: [
          BlocProvider<PolynomialBloc>.value(
            value: cubicBloc,
          ),
          BlocProvider<PlotZoomCubit>.value(
            value: cubicPlot,
          ),
        ],
        child: const PolynomialBody(),
      ),
    ),
    NavigationItem(
      title: context.l10n.fourthDegree,
      content: MultiBlocProvider(
        providers: [
          BlocProvider<PolynomialBloc>.value(
            value: quarticBloc,
          ),
          BlocProvider<PlotZoomCubit>.value(
            value: quarticPlot,
          ),
        ],
        child: const PolynomialBody(),
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
