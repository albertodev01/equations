import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:flutter/material.dart';

/// This page contains a series of integral evaluation algorithms. There only
/// is a single page where the user simply writes the equation and then the
/// algorithm evaluates the integral.
///
/// The function is also plotted and the area is highlighted on the chart.
class IntegralPage extends StatelessWidget {
  /// Creates a [IntegralPage] widget.
  const IntegralPage();

  @override
  Widget build(BuildContext context) {
    return const EquationScaffold(
      body: Center(
        child: Text('Integrals'),
      ),
    );
  }
}
