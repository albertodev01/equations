import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:equations_solver/routes/nonlinear_page/model/inherited_nonlinear.dart';
import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_data_input.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// Dropdown button used to choose which root finding algorithm has to be used
/// in a [NonlinearDataInput] widget.
class NonlinearDropdownSelection extends StatefulWidget {
  /// Creates a [NonlinearDropdownSelection] widget.
  const NonlinearDropdownSelection({super.key});

  @override
  NonlinearDropdownSelectionState createState() =>
      NonlinearDropdownSelectionState();
}

/// The state of the [NonlinearDropdownSelection] class.
@visibleForTesting
class NonlinearDropdownSelectionState
    extends State<NonlinearDropdownSelection> {
  /// The cached dropdown items.
  late final dropdownItems = nonlinearType == NonlinearType.singlePoint
      ? const [
          DropdownMenuItem<NonlinearDropdownItems>(
            key: Key('Newton-Dropdown'),
            value: NonlinearDropdownItems.newton,
            child: Text('Newton'),
          ),
          DropdownMenuItem<NonlinearDropdownItems>(
            key: Key('Steffensen-Dropdown'),
            value: NonlinearDropdownItems.steffensen,
            child: Text('Steffensen'),
          ),
        ]
      : const [
          DropdownMenuItem<NonlinearDropdownItems>(
            key: Key('Bisection-Dropdown'),
            value: NonlinearDropdownItems.bisection,
            child: Text('Bisection'),
          ),
          DropdownMenuItem<NonlinearDropdownItems>(
            key: Key('Secant-Dropdown'),
            value: NonlinearDropdownItems.secant,
            child: Text('Secant'),
          ),
          DropdownMenuItem<NonlinearDropdownItems>(
            key: Key('Brent-Dropdown'),
            value: NonlinearDropdownItems.brent,
            child: Text('Brent'),
          ),
        ];

  /// Updates the currently selected value in the dropdown.
  void changeSelected(NonlinearDropdownItems newValue) =>
      context.dropdownValue.value = newValue.name;

  /// The currently selected nonlinear type.
  NonlinearType get nonlinearType => context.nonlinearState.nonlinearType;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: nonlinearDropdownWidth,
        child: ValueListenableBuilder<String>(
          valueListenable: context.dropdownValue,
          builder: (context, value, _) {
            return DropdownButtonFormField<NonlinearDropdownItems>(
              key: const Key('Integral-Dropdown-Button-Selection'),
              isExpanded: true,
              value: value.toNonlinearDropdownItems(),
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

/// The possible values of the [NonlinearDropdownSelection] dropdown.
enum NonlinearDropdownItems {
  /// Newton's method.
  newton('Newton'),

  /// Steffensen's method.
  steffensen('Steffensen'),

  /// Bisection method.
  bisection('Bisection'),

  /// Secant method.
  secant('Secant'),

  /// Brent's method.
  brent('Brent');

  /// The string representation.
  final String name;

  /// [NonlinearDropdownItems] constructor.
  const NonlinearDropdownItems(this.name);
}

/// Extension method on [String] to convert into a [NonlinearDropdownItems] the
/// string value.
extension StringExt on String {
  static const _argumentErrorMessage =
      'The given string does NOT map to a NonlinearDropdownItems value';

  /// Converts a [String] into a [NonlinearDropdownItems] value.
  NonlinearDropdownItems toNonlinearDropdownItems() => switch (toLowerCase()) {
        'newton' => NonlinearDropdownItems.newton,
        'steffensen' => NonlinearDropdownItems.steffensen,
        'bisection' => NonlinearDropdownItems.bisection,
        'secant' => NonlinearDropdownItems.secant,
        'brent' => NonlinearDropdownItems.brent,
        _ => throw ArgumentError(_argumentErrorMessage)
      };
}
