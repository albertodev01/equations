import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dropdown button used to choose which root finding algorithm has to be used
class NonlinearDropdownSelection extends StatefulWidget {
  /// Creates a [NonlinearDropdownSelection] widget.
  const NonlinearDropdownSelection({Key? key}) : super(key: key);

  @override
  NonlinearDropdownSelectionState createState() =>
      NonlinearDropdownSelectionState();
}

/// The state of the [NonlinearDropdownSelection] class.
@visibleForTesting
class NonlinearDropdownSelectionState
    extends State<NonlinearDropdownSelection> {
  /// The items of the dropdown.
  late final dropdownItems = _dropdownValues(context);

  List<DropdownMenuItem<String>> _dropdownValues(BuildContext context) {
    final type = context.read<NonlinearBloc>().nonlinearType;

    if (type == NonlinearType.singlePoint) {
      return const [
        DropdownMenuItem<String>(
          key: Key('Newton-Dropdown'),
          value: 'Newton',
          child: Text('Newton'),
        ),
        DropdownMenuItem<String>(
          key: Key('Steffensen-Dropdown'),
          value: 'Steffensen',
          child: Text('Steffensen'),
        ),
      ];
    } else {
      return const [
        DropdownMenuItem<String>(
          key: Key('Bisection-Dropdown'),
          value: 'Bisection',
          child: Text('Bisection'),
        ),
        DropdownMenuItem<String>(
          key: Key('Secant-Dropdown'),
          value: 'Secant',
          child: Text('Secant'),
        ),
        DropdownMenuItem<String>(
          key: Key('Brent-Dropdown'),
          value: 'Brent',
          child: Text('Brent'),
        ),
      ];
    }
  }

  /// Updates the currently selected value in the dropdown.
  void changeSelected(String newValue) =>
      context.read<DropdownCubit>().changeValue(newValue);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        child: BlocBuilder<DropdownCubit, String>(
          builder: (context, state) {
            return DropdownButtonFormField<String>(
              key: const Key('Dropdown-Button-Selection'),
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
    );
  }
}
