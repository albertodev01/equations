import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
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
  /// The [OtherBloc] instance for matrix analysis.
  final matrixBloc = OtherBloc();

  /// The [OtherBloc] instance for complex numbers analysis.
  final complexBloc = OtherBloc();

  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.matrices,
      content: MultiBlocProvider(
        providers: [
          BlocProvider<NumberSwitcherCubit>(
            create: (_) => NumberSwitcherCubit(
              min: 1,
              max: 5,
            ),
          ),
          BlocProvider<OtherBloc>.value(
            value: matrixBloc,
          ),
        ],
        child: const MatrixOtherBody(),
      ),
    ),
    NavigationItem(
      title: context.l10n.complex_numbers,
      content: BlocProvider<OtherBloc>.value(
        value: complexBloc,
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
