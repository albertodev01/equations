import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dropdown button used to choose which root finding algorithm has to be used
class DropdownSelection extends StatefulWidget {
  /// Creates a [DropdownSelection] widget.
  const DropdownSelection();

  @override
  _DropdownSelectionState createState() => _DropdownSelectionState();
}

class _DropdownSelectionState extends State<DropdownSelection> {
  late final dropdownItems = dropdownValues(context);

  List<DropdownMenuItem<String>> dropdownValues(BuildContext context) {
    final type = context.read<NonlinearBloc>().nonlinearType;

    if (type == NonlinearType.singlePoint) {
      return const [
        DropdownMenuItem<String>(
          value: 'Newton',
          child: Text('Newton'),
        ),
        DropdownMenuItem<String>(
          value: 'Steffensen',
          child: Text('Steffensen'),
        )
      ];
    } else {
      return const [
        DropdownMenuItem<String>(
          value: 'Bisection',
          child: Text('Bisection'),
        ),
        DropdownMenuItem<String>(
          value: 'Secant',
          child: Text('Secant'),
        ),
        DropdownMenuItem<String>(
          value: 'Brent',
          child: Text('Brent'),
        ),
      ];
    }
  }

  void changeSelected(String newValue) =>
      context.read<DropdownCubit>().changeValue(newValue);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: context.watch<DropdownCubit>().state,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            onChanged: (value) => changeSelected(value!),
            items: dropdownItems),
      ),
    );
  }
}
