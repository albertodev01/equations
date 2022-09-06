import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:equations_solver/routes/system_page/model/inherited_system.dart';
import 'package:equations_solver/routes/system_page/model/system_state.dart';
import 'package:flutter/material.dart';

/// Dropdown button used to choose which system solving algorithm has to be
/// used.
class SystemDropdownSelection extends StatefulWidget {
  /// Creates a [SystemDropdownSelection] widget.
  const SystemDropdownSelection({super.key});

  @override
  SystemDropdownSelectionState createState() => SystemDropdownSelectionState();
}

/// The state of the [SystemDropdownSelection] class.
@visibleForTesting
class SystemDropdownSelectionState extends State<SystemDropdownSelection> {
  /// The cached dropdown items.
  late final dropdownItems = systemType == SystemType.factorization
      ? const [
          DropdownMenuItem<SystemDropdownItems>(
            key: Key('LU-Dropdown'),
            value: SystemDropdownItems.lu,
            child: Text('LU'),
          ),
          DropdownMenuItem<SystemDropdownItems>(
            key: Key('Cholesky-Dropdown'),
            value: SystemDropdownItems.cholesky,
            child: Text('Cholesky'),
          ),
        ]
      : const [
          DropdownMenuItem<SystemDropdownItems>(
            key: Key('SOR-Dropdown'),
            value: SystemDropdownItems.sor,
            child: Text('SOR'),
          ),
          DropdownMenuItem<SystemDropdownItems>(
            key: Key('Jacobi-Dropdown'),
            value: SystemDropdownItems.jacobi,
            child: Text('Jacobi'),
          ),
        ];

  /// Updates the currently selected value in the dropdown.
  void changeSelected(SystemDropdownItems newValue) =>
      context.dropdownValue.value = newValue.asString;

  /// The currently selected system type.
  SystemType get systemType => context.systemState.systemType;

  @override
  Widget build(BuildContext context) {
    // Gauss is the only supported row reduction system and it doesn't require
    // an algorithm. As such, we can remove the dropdown.
    if (systemType == SystemType.rowReduction) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Spacing
          const SizedBox(height: 45),

          // Dropdown picker
          SizedBox(
            width: 250,
            child: ValueListenableBuilder<String>(
              valueListenable: context.dropdownValue,
              builder: (context, value, _) {
                return DropdownButtonFormField<SystemDropdownItems>(
                  key: const Key('System-Dropdown-Button-Selection'),
                  isExpanded: true,
                  value: value.toSystemDropdownItems(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  onChanged: (value) => changeSelected(value!),
                  items: dropdownItems,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// The possible values of the [SystemDropdownSelection] dropdown.
enum SystemDropdownItems {
  /// LU factorization.
  lu('LU'),

  /// Cholesky factorization.
  cholesky('Cholesky'),

  /// SOR iterative method.
  sor('SOR'),

  /// Jacobi iterative method.
  jacobi('Jacobi');

  /// The string representation of the value.
  final String asString;

  /// Creates a [SystemDropdownItems] enumeration
  const SystemDropdownItems(this.asString);
}

/// Extension method on [String] to convert into a [SystemDropdownItems] the
/// string value.
extension StringExt on String {
  /// Converts a [String] into a [SystemDropdownItems] value.
  SystemDropdownItems toSystemDropdownItems() {
    switch (toLowerCase()) {
      case 'lu':
        return SystemDropdownItems.lu;
      case 'cholesky':
        return SystemDropdownItems.cholesky;
      case 'sor':
        return SystemDropdownItems.sor;
      case 'jacobi':
        return SystemDropdownItems.jacobi;
      default:
        throw ArgumentError(
          'The given string does NOT map to a SystemDropdownItems value',
        );
    }
  }
}
