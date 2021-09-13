import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:flutter/material.dart';

/// This page contains a series of utilities to analyze matrices (determinant,
/// eigenvalues, trace, decompositions...) and polyomials (roots, derivative,
/// degree, operations...).
class ToolsPage extends StatelessWidget {
  /// Creates a [ToolsPage] widget.
  const ToolsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const EquationScaffold(
      body: Center(
        child: Text('ToolsPage'),
      ),
    );
  }
}
