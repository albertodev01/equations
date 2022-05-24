import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:equations_solver/routes/models/number_switcher/inherited_number_switcher.dart';
import 'package:equations_solver/routes/models/number_switcher/number_switcher_state.dart';
import 'package:equations_solver/routes/models/system_text_controllers/inherited_system_controllers.dart';
import 'package:equations_solver/routes/models/system_text_controllers/system_text_controllers.dart';
import 'package:equations_solver/routes/system_page/model/inherited_system.dart';
import 'package:equations_solver/routes/system_page/model/system_state.dart';
import 'package:equations_solver/routes/system_page/system_body.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:flutter/material.dart';

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
   * These controllers are exposed to the subtree with [InheritedTextController]
   * because the scaffold uses tabs and when swiping, the controllers get
   * disposed.
   *
   * In order to keep the controllers alive (and thus persist the text), we need
   * to save theme here, which is ABOVE the tabs.
   */

  final matrixRowReductionControllers = List<TextEditingController>.generate(
    16,
    (_) => TextEditingController(),
    growable: false,
  );

  final vectorRowReductionControllers = List<TextEditingController>.generate(
    4,
    (_) => TextEditingController(),
    growable: false,
  );

  final matrixFactorizationControllers = List<TextEditingController>.generate(
    16,
    (_) => TextEditingController(),
    growable: false,
  );

  final vectorFactorizationControllers = List<TextEditingController>.generate(
    4,
    (_) => TextEditingController(),
    growable: false,
  );

  final matrixIterativeControllers = List<TextEditingController>.generate(
    16,
    (_) => TextEditingController(),
    growable: false,
  );

  final vectorIterativeControllers = List<TextEditingController>.generate(
    4,
    (_) => TextEditingController(),
    growable: false,
  );

  final jacobiControllers = List<TextEditingController>.generate(
    4,
    (_) => TextEditingController(),
    growable: false,
  );

  final wSorController = TextEditingController();

  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.row_reduction,
      content: InheritedSystem(
        systemState: SystemState(SystemType.rowReduction),
        child: InheritedNumberSwitcher(
          numberSwitcherState: NumberSwitcherState(
            min: 1,
            max: 4,
          ),
          child: InheritedDropdownValue(
            dropdownValue: ValueNotifier<String>(''),
            child: InheritedSystemControllers(
              systemTextControllers: SystemTextControllers(
                matrixControllers: matrixRowReductionControllers,
                vectorControllers: vectorRowReductionControllers,
                jacobiControllers: jacobiControllers,
                wSorController: wSorController,
              ),
              child: const SystemBody(),
            ),
          ),
        ),
      ),
    ),
    NavigationItem(
      title: context.l10n.factorization,
      content: InheritedSystem(
        systemState: SystemState(SystemType.factorization),
        child: InheritedNumberSwitcher(
          numberSwitcherState: NumberSwitcherState(
            min: 1,
            max: 4,
          ),
          child: InheritedDropdownValue(
            dropdownValue: ValueNotifier<String>(
              SystemDropdownItems.lu.asString(),
            ),
            child: InheritedSystemControllers(
              systemTextControllers: SystemTextControllers(
                matrixControllers: matrixFactorizationControllers,
                vectorControllers: vectorFactorizationControllers,
                jacobiControllers: jacobiControllers,
                wSorController: wSorController,
              ),
              child: const SystemBody(),
            ),
          ),
        ),
      ),
    ),
    NavigationItem(
      title: context.l10n.iterative,
      content: InheritedSystem(
        systemState: SystemState(SystemType.iterative),
        child: InheritedNumberSwitcher(
          numberSwitcherState: NumberSwitcherState(
            min: 1,
            max: 4,
          ),
          child: InheritedDropdownValue(
            dropdownValue: ValueNotifier<String>(
              SystemDropdownItems.sor.asString(),
            ),
            child: InheritedSystemControllers(
              systemTextControllers: SystemTextControllers(
                matrixControllers: matrixIterativeControllers,
                vectorControllers: vectorIterativeControllers,
                jacobiControllers: jacobiControllers,
                wSorController: wSorController,
              ),
              child: const SystemBody(),
            ),
          ),
        ),
      ),
    ),
  ];

  @override
  void dispose() {
    for (final controller in matrixRowReductionControllers) {
      controller.dispose();
    }

    for (final controller in matrixFactorizationControllers) {
      controller.dispose();
    }

    for (final controller in matrixIterativeControllers) {
      controller.dispose();
    }

    for (final controller in vectorRowReductionControllers) {
      controller.dispose();
    }

    for (final controller in vectorFactorizationControllers) {
      controller.dispose();
    }

    for (final controller in vectorIterativeControllers) {
      controller.dispose();
    }

    for (final controller in jacobiControllers) {
      controller.dispose();
    }

    wSorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EquationScaffold.navigation(
      navigationItems: cachedItems,
    );
  }
}
