import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/system_solver/system_solver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dropdown button used to choose which system solving algorithm has to be used.
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
      context.read<DropdownCubit>().changeValue(newValue.asString());

  /// The currently selected system type.
  SystemType get systemType => context.read<SystemBloc>().systemType;

  @override
  Widget build(BuildContext context) {
    // Gauss is the only supported row reduction system and it doesn't require
    // an algorithm to be picked so we can go this way.
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
            child: BlocBuilder<DropdownCubit, String>(
              builder: (context, state) {
                return DropdownButtonFormField<SystemDropdownItems>(
                  key: const Key('System-Dropdown-Button-Selection'),
                  isExpanded: true,
                  value: state.toSystemDropdownItems(),
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
  lu,

  /// Cholesky factorization.
  cholesky,

  /// SOR iterative method.
  sor,

  /// Jacobi iterative method.
  jacobi,
}

/// Extension method on [SystemDropdownItems] to convert a value to a string.
extension SystemDropdownItemsExt on SystemDropdownItems {
  /// Converts the enum into a [String].
  String asString() {
    switch (this) {
      case SystemDropdownItems.lu:
        return 'LU';
      case SystemDropdownItems.cholesky:
        return 'Cholesky';
      case SystemDropdownItems.sor:
        return 'SOR';
      case SystemDropdownItems.jacobi:
        return 'Jacobi';
    }
  }
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
