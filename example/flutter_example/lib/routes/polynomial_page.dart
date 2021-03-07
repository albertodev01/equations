import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_body.dart';
import 'package:flutter/material.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'file:///C:/Users/AlbertoMiola/Desktop/Programmazione/Dart/equations/example/flutter_example/lib/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/polynomial_solver/polynomial_solver.dart';

/// This page contains a series of polynomial equations solvers. There are 4 tabs
/// dedicated to particular polynomial equations
///
///  - Linear
///  - Quadratic
///  - Cubic
///  - Quartic
class PolynomialPage extends StatelessWidget {
  const PolynomialPage();

  @override
  Widget build(BuildContext context) {
    return EquationScaffold(
      navigationItems: [
        NavigationItem(
          title: context.l10n.firstDegree,
          content: BlocProvider<PolynomialBloc>(
            create: (_) => PolynomialBloc(
              polynomialType: PolynomialType.linear,
            ),
            child: const PolynomialBody(),
          ),
        ),
        NavigationItem(
          title: context.l10n.secondDegree,
          content: BlocProvider<PolynomialBloc>(
            create: (_) => PolynomialBloc(
              polynomialType: PolynomialType.quadratic,
            ),
            child: const PolynomialBody(),
          ),
        ),
        NavigationItem(
          title: context.l10n.thirdDegree,
          content: BlocProvider<PolynomialBloc>(
            create: (_) => PolynomialBloc(
              polynomialType: PolynomialType.cubic,
            ),
            child: const PolynomialBody(),
          ),
        ),
        NavigationItem(
          title: context.l10n.fourthDegree,
          content: BlocProvider<PolynomialBloc>(
            create: (_) => PolynomialBloc(
              polynomialType: PolynomialType.quartic,
            ),
            child: const PolynomialBody(),
          ),
        ),
      ],
    );
  }
}
