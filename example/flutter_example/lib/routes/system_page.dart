import 'package:equations_solver/blocs/system_solver/system_solver.dart';
import 'package:equations_solver/routes/system_page/system_body.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This page contains a series of linear systems solvers. There are 3 tabs
/// to solve various size of systems:
///
///  - 2x2 systems
///  - 3x3 systems
///  - 4x4 systems
class SystemPage extends StatefulWidget {
  /// Creates a [SystemPage] widget.
  const SystemPage();

  @override
  _SystemPageState createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage> {
  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.row_reduction,
      content: BlocProvider<SystemBloc>(
        create: (_) => SystemBloc(SystemType.rowReduction),
        child: const SystemBody(),
      ),
    ),
    NavigationItem(
      title: context.l10n.factorization,
      content: BlocProvider<SystemBloc>(
        create: (_) => SystemBloc(SystemType.factorization),
        child: const SystemBody(),
      ),
    ),
    NavigationItem(
      title: context.l10n.iterative,
      content: BlocProvider<SystemBloc>(
        create: (_) => SystemBloc(SystemType.iterative),
        child: const SystemBody(),
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
