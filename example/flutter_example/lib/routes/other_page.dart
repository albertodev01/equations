import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:equations_solver/blocs/textfield_values/textfield_values.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/other_page/complex_numbers_body.dart';
import 'package:equations_solver/routes/other_page/matrix_body.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This page contains a series of utilities to analyze matrices (determinant,
/// eigenvalues, trace, decompositions...) and complex numbers.
class OtherPage extends StatefulWidget {
  /// Creates a [OtherPage] widget.
  const OtherPage({Key? key}) : super(key: key);

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  /*
   * Caching blocs here in the state since `EquationScaffold` is creating a
   * tab view and thus `BlocProvider`s might be destroyed when the body is not
   * visible anymore.
   *
   */

  // Bloc for working on matrices and complex numbers.
  final matrixBloc = OtherBloc();
  final complexBloc = OtherBloc();

  // TextFields values blocs
  final matrixTextfields = TextFieldValuesCubit();
  final complexTextfields = TextFieldValuesCubit();

  // Bloc for the matrix size
  final matrixSize = NumberSwitcherCubit(
    min: 1,
    max: 5,
  );

  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.matrices,
      content: MultiBlocProvider(
        providers: [
          BlocProvider<NumberSwitcherCubit>.value(
            value: matrixSize,
          ),
          BlocProvider<OtherBloc>.value(
            value: matrixBloc,
          ),
          BlocProvider<TextFieldValuesCubit>.value(
            value: matrixTextfields,
          ),
        ],
        child: const MatrixOtherBody(),
      ),
    ),
    NavigationItem(
      title: context.l10n.complex_numbers,
      content: MultiBlocProvider(
        providers: [
          BlocProvider<OtherBloc>.value(
            value: complexBloc,
          ),
          BlocProvider<TextFieldValuesCubit>.value(
            value: complexTextfields,
          ),
        ],
        child: const ComplexNumberOtherBody(),
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
