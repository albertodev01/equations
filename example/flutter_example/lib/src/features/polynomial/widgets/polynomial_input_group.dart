import 'package:equations/equations.dart';
import 'package:flutter/material.dart';

class PolynomialInputGroup extends StatefulWidget {
  final List<TextEditingController> controllers;

  const PolynomialInputGroup({
    required this.controllers,
    super.key,
  });

  @override
  State<PolynomialInputGroup> createState() => _PolynomialInputGroupState();
}

class _PolynomialInputGroupState extends State<PolynomialInputGroup> {
  late var inputs = generateInputs();

  /// Increments by [index] the char code unit to get a specific letter. For
  /// example:
  ///   - [index] = 0 -> 'a'
  ///   - [index] = 1 -> 'b'
  ///   - [index] = 2 -> 'c'
  ///   - [index] = 6 -> 'g'
  String placeholderLetter(int index) {
    const firstLetter = 'a';
    return String.fromCharCode(firstLetter.codeUnitAt(0) + index);
  }

  List<_PolynomialInputField> generateInputs() {
    return List<_PolynomialInputField>.generate(
      widget.controllers.length,
      (index) {
        final controller = widget.controllers[index];
        final placeholder = placeholderLetter(index);

        return _PolynomialInputField(
          controller: controller,
          placeholder: placeholder,
          key: Key('PolynomialInputField-$placeholder'),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant PolynomialInputGroup oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controllers != oldWidget.controllers) {
      inputs = generateInputs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: inputs,
      ),
    );
  }
}

/// This is just a wrapper of a [TextFormField] that parses and validates the
/// coefficients of a polynomial equation.
class _PolynomialInputField extends StatelessWidget {
  /// The [TextEditingController] controller.
  final TextEditingController controller;

  /// The placeholder text to show in the input field.
  final String placeholder;

  /// Creates a [_PolynomialInputField] widget.
  const _PolynomialInputField({
    required this.controller,
    required this.placeholder,
    super.key,
  });

  String? _validationLogic(String? value, BuildContext context) {
    if (value != null) {
      if (!value.isNumericalExpression) {
        return 'error todo';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: TextFormField(
        key: const Key('PolynomialInputField-TextFormField'),
        controller: controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueAccent,
            ),
          ),
          hintText: placeholder,
        ),
        validator: (value) => _validationLogic(value, context),
      ),
    );
  }
}
