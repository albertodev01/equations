import 'package:equations/equations.dart';
import 'package:flutter/material.dart';

/// A wrapper of a [TextFormField] that allows the input of either an equation
/// or simple real numbers.
class EquationInput extends StatelessWidget {
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

  /// Creates a [EquationInput] instance.
  const EquationInput({
    super.key,
    required this.controller,
    required this.placeholderText,
    this.baseWidth = 300,
    this.maxLength = 100,
    this.onlyRealValues = false,
  });

  String? _validator(String? value) {
    if (value != null) {
      if (onlyRealValues) {
        return value.isNumericalExpression ? null : 'Uh! :(';
      }

      return value.isRealFunction ? null : 'Uh! :(';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: SizedBox(
        width: baseWidth,
        child: TextFormField(
          controller: controller,
          maxLength: maxLength,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: placeholderText,
          ),
          validator: _validator,
        ),
      ),
    );
  }
}
