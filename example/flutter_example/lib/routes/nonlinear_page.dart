import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_body.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This page contains a series of nonlinear equations solvers. There are 2 tabs
/// that group a series of well-known root finding algorithms:
///
///  - Single point methods (like Newton's method)
///  - Bracketing methods (like secant method or bisection)
class NonlinearPage extends StatefulWidget {
  /// Creates a [NonlinearPage] widget.
  const NonlinearPage({Key? key}) : super(key: key);

  @override
  _NonlinearPageState createState() => _NonlinearPageState();
}

class _NonlinearPageState extends State<NonlinearPage> {
  /// The [NonlinearBloc] instance for single point root finding algorithms.
  final singlePointBloc = NonlinearBloc(NonlinearType.singlePoint);

  /// The [NonlinearBloc] instance for bracketing root finding algorithms.
  final bracketingBloc = NonlinearBloc(NonlinearType.bracketing);

  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.single_point,
      content: BlocProvider<NonlinearBloc>.value(
        value: singlePointBloc,
        child: const NonlinearBody(
          key: Key('NonlinearPage-SinglePoint-Body'),
        ),
      ),
    ),
    NavigationItem(
      title: context.l10n.bracketing,
      content: BlocProvider<NonlinearBloc>.value(
        value: bracketingBloc,
        child: const NonlinearBody(
          key: Key('NonlinearPage-Bracketing-Body'),
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
