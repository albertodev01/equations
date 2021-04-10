import 'package:equations_solver/routes/nonlinear_page/nonlinear_data_input.dart';
import 'package:flutter/material.dart';
import 'package:equations/equations.dart';

/// A [TextFormField] used in a [NonlinearDataInput] widget to receive the
/// parameters of the root finding algorithm.
class NonlinearInput extends StatelessWidget {
  /// The controller of the [TextFormField].
  final TextEditingController controller;

  /// The placeholder text of the widget.
  final String placeholderText;

  /// The width of the input, which will scale if the horizontal space is not
  /// enough.
  final double baseWidth;

  /// The maximum length of the input.
  final int maxLength;

  /// Determines whether the validator function of the input should allow for
  /// real values or not.
  ///
  /// In other words, when `onlyRealValues = true` then equations aren't accepted
  /// but numbers are.
  ///
  /// This is `false` by default.
  final bool onlyRealValues;

  /// Creates a [NonlinearInput] instance.
  const NonlinearInput({
    Key? key,
    required this.controller,
    required this.placeholderText,
    this.baseWidth = 300,
    this.maxLength = 100,
    this.onlyRealValues = false,
  }) : super(key: key);

  String? _validator(String? value) {
    if (value != null) {
      if (onlyRealValues) {
        return value.isRealFunction ? null : 'Uh! :(';
      }
      return value.isRealFunction ? null : 'Uh! :(';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, dimensions) {
        var inputWidth = baseWidth;

        // The '+100' adds some extra spacing to not be too much close to the
        // sides of the bounds
        if (dimensions.maxWidth <= baseWidth + 100) {
          inputWidth = dimensions.maxWidth / 1.5;
        }

        return SizedBox(
          width: inputWidth,
          child: TextFormField(
            controller: controller,
            maxLength: maxLength,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: placeholderText,
            ),
            validator: _validator,
          ),
        );
      },
    );
  }
}
