import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// Dropdown button needed to choose the numerical integration algorithm.
class IntegralDropdownSelection extends StatefulWidget {
  /// Creates a [IntegralDropdownSelection] widget.
  const IntegralDropdownSelection({super.key});

  @override
  IntegralDropdownSelectionState createState() =>
      IntegralDropdownSelectionState();
}

/// The state of the [IntegralDropdownSelection] class.
@visibleForTesting
class IntegralDropdownSelectionState extends State<IntegralDropdownSelection> {
  /// The dropdown items.
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
      context.dropdownValue.value = newValue.name;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: integralDropdownWidth,
        child: ValueListenableBuilder<String>(
          valueListenable: context.dropdownValue,
          builder: (context, value, _) {
            return DropdownButtonFormField<IntegralDropdownItems>(
              key: const Key('Integral-Dropdown-Button-Selection'),
              isExpanded: true,
              value: value.toIntegralDropdownItems(),
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
  simpson('Simpson'),

  /// Midpoint rule.
  midpoint('Midpoint'),

  /// Trapezoid rule.
  trapezoid('Trapezoid');

  /// The string representation.
  final String name;

  /// [IntegralDropdownItems] constructor.
  const IntegralDropdownItems(this.name);
}

/// Extension method on [String] to convert into a [IntegralDropdownItems] the
/// string value.
extension StringExt on String {
  static const _argumentErrorMessage =
      'The given string does NOT map to a IntegralDropdownItems value';

  /// Converts a [String] into a [IntegralDropdownItems] value.
  IntegralDropdownItems toIntegralDropdownItems() => switch (toLowerCase()) {
        'simpson' => IntegralDropdownItems.simpson,
        'midpoint' => IntegralDropdownItems.midpoint,
        'trapezoid' => IntegralDropdownItems.trapezoid,
        _ => throw ArgumentError(_argumentErrorMessage)
      };
}
