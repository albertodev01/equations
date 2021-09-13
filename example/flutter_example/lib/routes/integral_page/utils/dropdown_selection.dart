import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dropdown button used to choose which numerical integration algorithm has to
/// be used.
class IntegralDropdownSelection extends StatefulWidget {
  /// Creates a [IntegralDropdownSelection] widget.
  const IntegralDropdownSelection({Key? key}) : super(key: key);

  @override
  IntegralDropdownSelectionState createState() =>
      IntegralDropdownSelectionState();
}

/// The state of the [IntegralDropdownSelection] class.
@visibleForTesting
class IntegralDropdownSelectionState extends State<IntegralDropdownSelection> {
  /// The items of the dropdown.
  final dropdownItems = const [
    DropdownMenuItem<IntegralDropdownItems>(
      key: Key('Simpson-Dropdown'),
      value: IntegralDropdownItems.simpson,
      child: Text('Simpson'),
    ),
    DropdownMenuItem<IntegralDropdownItems>(
      key: Key('Trapezoid-Dropdown'),
      value: IntegralDropdownItems.trapezoid,
      child: Text('Trapezoid'),
    ),
    DropdownMenuItem<IntegralDropdownItems>(
      key: Key('Midpoint-Dropdown'),
      value: IntegralDropdownItems.midpoint,
      child: Text('Midpoint'),
    ),
  ];

  /// Updates the currently selected value in the dropdown.
  void changeSelected(IntegralDropdownItems newValue) =>
      context.read<DropdownCubit>().changeValue(newValue.asString());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        child: BlocBuilder<DropdownCubit, String>(
          builder: (context, state) {
            return DropdownButtonFormField<IntegralDropdownItems>(
              key: const Key('Integral-Dropdown-Button-Selection'),
              isExpanded: true,
              value: state.toIntegralDropdownItems(),
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

/// The possible values of the [IntegralDropdownSelection] dropdown.
enum IntegralDropdownItems {
  /// Simpson rule.
  simpson,

  /// Midpoint rule.
  midpoint,

  /// Trapezoid rule.
  trapezoid,
}

/// Extension method on [IntegralDropdownItems] to convert a value to a string.
extension IntegralDropdownItemsExt on IntegralDropdownItems {
  /// Converts the enum into a [String].
  String asString() {
    switch (this) {
      case IntegralDropdownItems.simpson:
        return 'Simpson';
      case IntegralDropdownItems.midpoint:
        return 'Midpoint';
      case IntegralDropdownItems.trapezoid:
        return 'Trapezoid';
    }
  }
}

/// Extension method on [String] to convert into a [IntegralDropdownItems] the
/// string value.
extension StringExt on String {
  /// Converts a [String] into a [IntegralDropdownItems] value.
  IntegralDropdownItems toIntegralDropdownItems() {
    switch (toLowerCase()) {
      case 'simpson':
        return IntegralDropdownItems.simpson;
      case 'midpoint':
        return IntegralDropdownItems.midpoint;
      case 'trapezoid':
        return IntegralDropdownItems.trapezoid;
      default:
        throw ArgumentError(
          'The given string does NOT map to a IntegralDropdownItems value',
        );
    }
  }
}
