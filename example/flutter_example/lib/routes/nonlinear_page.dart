import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_body.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This page contains a series of nonlinear equations solvers. There are 2 tabs
/// that group a series of well-known root finding algorithms:
///
///  - Single point methods (like Newton's method)
///  - Bracketing methods (like secant method or bisection)
class NonlinearPage extends StatefulWidget {
  /// Creates a [NonlinearPage] widget.
  const NonlinearPage();

  @override
  _NonlinearPageState createState() => _NonlinearPageState();
}

class _NonlinearPageState extends State<NonlinearPage> {
  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.single_point,
      content: BlocProvider<NonlinearBloc>(
        create: (_) => NonlinearBloc(NonlinearType.singlePoint),
        child: const NonlinearBody(),
      ),
    ),
    NavigationItem(
      title: context.l10n.bracketing,
      content: BlocProvider<NonlinearBloc>(
        create: (_) => NonlinearBloc(NonlinearType.bracketing),
        child: const NonlinearBody(),
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
