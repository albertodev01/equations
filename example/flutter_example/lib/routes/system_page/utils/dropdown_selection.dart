import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/blocs/system_solver/bloc/bloc.dart';
import 'package:equations_solver/blocs/system_solver/system_solver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dropdown button used to choose which system solving algorithm has to be used.
class SystemDropdownSelection extends StatefulWidget {
  /// Creates a [SystemDropdownSelection] widget.
  const SystemDropdownSelection();

  @override
  SystemDropdownSelectionState createState() => SystemDropdownSelectionState();
}

/// The state of the [NonlinearDropdownSelection] class.
@visibleForTesting
class SystemDropdownSelectionState extends State<SystemDropdownSelection> {
  /// The items of the dropdown.
  late final dropdownItems = _dropdownValues(context);

  List<DropdownMenuItem<String>> _dropdownValues(BuildContext context) {
    if (systemType == SystemType.factorization) {
      return const [
        DropdownMenuItem<String>(
          key: Key('LU-Dropdown'),
          value: 'LU',
          child: Text('LU'),
        ),
        DropdownMenuItem<String>(
          key: Key('Cholesky-Dropdown'),
          value: 'Cholesky',
          child: Text('Cholesky'),
        )
      ];
    } else {
      return const [
        DropdownMenuItem<String>(
          key: Key('SOR-Dropdown'),
          value: 'SOR',
          child: Text('SOR'),
        ),
        DropdownMenuItem<String>(
          key: Key('Jacobi-Dropdown'),
          value: 'Jacobi',
          child: Text('Jacobi'),
        ),
      ];
    }
  }

  /// Updates the currently selected value in the dropdown.
  void changeSelected(String newValue) =>
      context.read<DropdownCubit>().changeValue(newValue);

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
                return DropdownButtonFormField<String>(
                  key: const Key('System-Dropdown-Button-Selection'),
                  isExpanded: true,
                  value: state,
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
