import 'package:equations_solver/routes/polynomial_page/polynomial_body.dart';
import 'package:flutter/material.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/navigation_item.dart';
import 'package:equations_solver/localization/localization.dart';

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
          content: const PolynomialBody(
            polynomialType: PolynomialType.linear,
          ),
        ),
        NavigationItem(
          title: context.l10n.secondDegree,
          content: const PolynomialBody(
            polynomialType: PolynomialType.quadratic,
          ),
        ),
        NavigationItem(
          title: context.l10n.thirdDegree,
          content: const PolynomialBody(
            polynomialType: PolynomialType.cubic,
          ),
        ),
        NavigationItem(
          title: context.l10n.anyDegree,
          content: const PolynomialBody(
            polynomialType: PolynomialType.quartic,
          ),
        ),
      ],
    );
  }
}
