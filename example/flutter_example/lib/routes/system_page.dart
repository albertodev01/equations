import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:equations_solver/routes/models/number_switcher/inherited_number_switcher.dart';
import 'package:equations_solver/routes/models/number_switcher/number_switcher_state.dart';
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
  /// Caching navigation items since they'll never change.
  late final cachedItems = [
    NavigationItem(
      title: context.l10n.row_reduction,
      content: InheritedSystem(
        systemState: SystemState(SystemType.rowReduction),
        child: InheritedNumberSwitcher(
          numberSwitcherState: NumberSwitcherState(min: 1, max: 4),
          child: InheritedDropdownValue(
            dropdownValue: ValueNotifier<String>(''),
            child: const SystemBody(),
          ),
        ),
      ),
    ),
    NavigationItem(
      title: context.l10n.factorization,
      content: InheritedSystem(
        systemState: SystemState(SystemType.factorization),
        child: InheritedNumberSwitcher(
          numberSwitcherState: NumberSwitcherState(min: 1, max: 4),
          child: InheritedDropdownValue(
            dropdownValue: ValueNotifier<String>(
              SystemDropdownItems.lu.asString(),
            ),
            child: const SystemBody(),
          ),
        ),
      ),
    ),
    NavigationItem(
      title: context.l10n.iterative,
      content: InheritedSystem(
        systemState: SystemState(SystemType.iterative),
        child: InheritedNumberSwitcher(
          numberSwitcherState: NumberSwitcherState(min: 1, max: 4),
          child: InheritedDropdownValue(
            dropdownValue: ValueNotifier<String>(
              SystemDropdownItems.sor.asString(),
            ),
            child: const SystemBody(),
          ),
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
