import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/number_switcher/inherited_number_switcher.dart';
import 'package:equations_solver/routes/models/number_switcher/number_switcher_state.dart';
import 'package:equations_solver/routes/models/text_controllers/inherited_text_controllers.dart';
import 'package:equations_solver/routes/other_page/complex_numbers_body.dart';
import 'package:equations_solver/routes/other_page/matrix_body.dart';
import 'package:equations_solver/routes/other_page/model/inherited_other.dart';
import 'package:equations_solver/routes/other_page/model/other_state.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';

/// This page contains a series of utilities to analyze matrices and complex
/// numbers.
class OtherPage extends StatefulWidget {
  /// Creates a [OtherPage] widget.
  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  /*
   * These controllers are exposed to the subtree with [InheritedTextController]
   * because the scaffold uses tabs and when swiping, the controllers get
   * disposed.
   *
   * In order to keep the controllers alive (and thus persist the text), we need
   * to save theme here, which is ABOVE the tabs.
   */
  final realController = TextEditingController();
  final imaginaryController = TextEditingController();

  final matrixControllers = List<TextEditingController>.generate(
    25,
    (_) => TextEditingController(),
    growable: false,
  );

  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.matrices,
      content: InheritedOther(
        otherState: OtherState(),
        child: InheritedTextControllers(
          textControllers: matrixControllers,
          child: InheritedNumberSwitcher(
            numberSwitcherState: NumberSwitcherState(
              min: 1,
              max: 5,
            ),
            child: const MatrixOtherBody(),
          ),
        ),
      ),
    ),
    NavigationItem(
      title: context.l10n.complex_numbers,
      content: InheritedOther(
        otherState: OtherState(),
        child: InheritedTextControllers(
          textControllers: [
            realController,
            imaginaryController,
          ],
          child: const ComplexNumberOtherBody(),
        ),
      ),
    ),
  ];

  @override
  void dispose() {
    for (final controller in matrixControllers) {
      controller.dispose();
    }

    realController.dispose();
    imaginaryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EquationScaffold.navigation(
      navigationItems: cachedItems,
    );
  }
}
