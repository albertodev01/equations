import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/number_switcher/inherited_number_switcher.dart';
import 'package:equations_solver/routes/models/number_switcher/number_switcher_state.dart';
import 'package:equations_solver/routes/other_page/complex_numbers_body.dart';
import 'package:equations_solver/routes/other_page/matrix_body.dart';
import 'package:equations_solver/routes/other_page/model/inherited_other.dart';
import 'package:equations_solver/routes/other_page/model/other_state.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';

/// This page contains a series of utilities to analyze matrices (determinant,
/// eigenvalues, trace, decompositions...) and complex numbers.
class OtherPage extends StatefulWidget {
  /// Creates a [OtherPage] widget.
  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.matrices,
      content: InheritedOther(
        otherState: OtherState(),
        child: InheritedNumberSwitcher(
          numberSwitcherState: NumberSwitcherState(
            min: 1,
            max: 5,
          ),
          child: const MatrixOtherBody(),
        ),
      ),
    ),
    NavigationItem(
      title: context.l10n.complex_numbers,
      content: InheritedOther(
        otherState: OtherState(),
        child: InheritedNumberSwitcher(
          numberSwitcherState: NumberSwitcherState(
            min: 1,
            max: 5,
          ),
          child: const ComplexNumberOtherBody(),
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
