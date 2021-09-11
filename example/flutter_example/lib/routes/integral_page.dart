import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';
import 'package:equations_solver/routes/integral_page/integral_body.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This page contains a series of integral evaluation algorithms. There only
/// is a single page where the user simply writes the equation and then the
/// algorithm evaluates the integral.
///
/// The function is also plotted and the area is highlighted on the chart.
class IntegralPage extends StatelessWidget {
  /// Creates a [IntegralPage] widget.
  const IntegralPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IntegralBloc>(
      create: (_) => IntegralBloc(),
      child: const EquationScaffold(
        body: IntegralBody(),
      ),
    );
  }
}
