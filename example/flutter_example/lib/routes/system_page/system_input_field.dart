import 'package:flutter/material.dart';
import 'package:equations/equations.dart';
import 'package:equations_solver/localization/localization.dart';

/// This is just a wrapper of a [TextFormField] that parses and validates the
/// entries of a matrix.
class SystemInputField extends StatelessWidget {
  /// The [TextEditingController] controller.
  final TextEditingController controller;

  /// The placeholder text to show in the input field.
  final String placeholder;

  /// Creates a [PolynomialBody] widget.
  const SystemInputField({
    Key? key,
    required this.controller,
    this.placeholder = '',
  }) : super(key: key);

  String? _validationLogic(String? value, BuildContext context) {
    if (value != null) {
      if (!value.isNumericalExpression) {
        return context.l10n.wrong_input;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 50,
      child: TextFormField(
        key: const Key('SystemInputField-TextFormField'),
        controller: controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 3,
          ),
          hintText: placeholder,
        ),
        validator: (value) => _validationLogic(value, context),
      ),
    );
  }
}
