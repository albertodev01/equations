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
  /// The [PolynomialBloc] instance used to manage linear polynomials.
  final linearBloc = PolynomialBloc(PolynomialType.linear);

  /// The [PolynomialBloc] instance used to manage quadratic polynomials.
  final quadraticBloc = PolynomialBloc(PolynomialType.quadratic);

  /// The [PolynomialBloc] instance used to manage cubic polynomials.
  final cubicBloc = PolynomialBloc(PolynomialType.cubic);

  /// The [PolynomialBloc] instance used to manage quartic polynomials.
  final quarticBloc = PolynomialBloc(PolynomialType.quartic);

  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.firstDegree,
      content: BlocProvider<PolynomialBloc>.value(
        value: linearBloc,
        child: const PolynomialBody(),
      ),
    ),
    NavigationItem(
      title: context.l10n.secondDegree,
      content: BlocProvider<PolynomialBloc>.value(
        value: quadraticBloc,
        child: const PolynomialBody(),
      ),
    ),
    NavigationItem(
      title: context.l10n.thirdDegree,
      content: BlocProvider<PolynomialBloc>.value(
        value: cubicBloc,
        child: const PolynomialBody(),
      ),
    ),
    NavigationItem(
      title: context.l10n.fourthDegree,
      content: BlocProvider<PolynomialBloc>.value(
        value: quarticBloc,
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
