import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:equations_solver/blocs/system_solver/system_solver.dart';
import 'package:equations_solver/blocs/textfield_values/textfield_values.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/system_page/system_body.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This page contains a series of linear systems solvers. There are 3 tabs
/// to solve various size of systems:
///
///  - 1x1 systems
///  - 2x2 systems
///  - 3x3 systems
///  - 4x4 systems
///
/// No complex numbers are allowed.
class SystemPage extends StatefulWidget {
  /// Creates a [SystemPage] widget.
  const SystemPage({super.key});

  @override
  _SystemPageState createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage> {
  /*
   * Caching blocs here in the state since `EquationScaffold` is creating a
   * tab view and thus `BlocProvider`s might be destroyed when the body is not
   * visible anymore.
   *
   */

  // System solving blocs
  final rowReductionBloc = SystemBloc(SystemType.rowReduction);
  final factorizationBloc = SystemBloc(SystemType.factorization);
  final iterativeBloc = SystemBloc(SystemType.iterative);

  // TextFields values blocs
  final rowReductionTextFields = TextFieldValuesCubit();
  final factorizationTextFields = TextFieldValuesCubit();
  final iterativeTextFields = TextFieldValuesCubit();

  // Bloc for the matrix size
  final matrixSizeRowReduction = NumberSwitcherCubit(
    min: 1,
    max: 4,
  );
  final matrixSizeFactorization = NumberSwitcherCubit(
    min: 1,
    max: 4,
  );
  final matrixSizeIterative = NumberSwitcherCubit(
    min: 1,
    max: 4,
  );

  // Bloc for the algorithm selection
  final dropdownFactorization = DropdownCubit(
    initialValue: SystemDropdownItems.lu.asString(),
  );
  final dropdownIterative = DropdownCubit(
    initialValue: SystemDropdownItems.sor.asString(),
  );

  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.row_reduction,
      content: MultiBlocProvider(
        providers: [
          BlocProvider<SystemBloc>.value(
            value: rowReductionBloc,
          ),
          BlocProvider<NumberSwitcherCubit>.value(
            value: matrixSizeRowReduction,
          ),
          BlocProvider<TextFieldValuesCubit>.value(
            value: rowReductionTextFields,
          ),
          BlocProvider<DropdownCubit>(
            create: (_) => DropdownCubit(
              initialValue: '',
            ),
          ),
        ],
        child: const SystemBody(),
      ),
    ),
    NavigationItem(
      title: context.l10n.factorization,
      content: MultiBlocProvider(
        providers: [
          BlocProvider<SystemBloc>.value(
            value: factorizationBloc,
          ),
          BlocProvider<NumberSwitcherCubit>.value(
            value: matrixSizeFactorization,
          ),
          BlocProvider<TextFieldValuesCubit>.value(
            value: factorizationTextFields,
          ),
          BlocProvider<DropdownCubit>.value(
            value: dropdownFactorization,
          ),
        ],
        child: const SystemBody(),
      ),
    ),
    NavigationItem(
      title: context.l10n.iterative,
      content: MultiBlocProvider(
        providers: [
          BlocProvider<SystemBloc>.value(
            value: iterativeBloc,
          ),
          BlocProvider<NumberSwitcherCubit>.value(
            value: matrixSizeIterative,
          ),
          BlocProvider<TextFieldValuesCubit>.value(
            value: iterativeTextFields,
          ),
          BlocProvider<DropdownCubit>.value(
            value: dropdownIterative,
          ),
        ],
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
