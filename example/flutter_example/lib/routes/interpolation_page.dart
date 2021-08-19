import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:flutter/material.dart';

/// This page contains a series of interpolation algorithms. The page contains
/// a series of inputs for the (x, y) points and a chart that plots the points.
class InterpolationPage extends StatelessWidget {
  /// Creates a [InterpolationPage] widget.
  const InterpolationPage();

  @override
  Widget build(BuildContext context) {
    return const EquationScaffold(
      body: Center(
        child: Text('Interpolation'),
      ),
    );
  }
}
