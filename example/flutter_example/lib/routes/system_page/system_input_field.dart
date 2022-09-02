import 'package:equations/equations.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// This is just a wrapper of a [TextFormField] that parses and validates the
/// entries of a matrix.
class SystemInputField extends StatefulWidget {
  /// The [TextEditingController] controller.
  final TextEditingController controller;

  /// The placeholder text to show in the input field.
  final String placeholder;

  /// Whether the field is in read-only mode or not. When `true`, the background
  /// color is set to [Colors.white].
  ///
  /// By default, this is set to `false`.
  final bool isReadOnly;

  /// Creates a [SystemInputField] widget.
  const SystemInputField({
    required this.controller,
    this.placeholder = '',
    this.isReadOnly = false,
    super.key,
  });

  @override
  State<SystemInputField> createState() => _SystemInputFieldState();
}

class _SystemInputFieldState extends State<SystemInputField> {
  String? _validationLogic(String? value) {
    if (value != null) {
      if (!value.isNumericalExpression) {
        return 'Uh! :(';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: systemInputFieldSize,
      child: TextFormField(
        key: const Key('SystemInputField-TextFormField'),
        controller: widget.controller,
        readOnly: widget.isReadOnly,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          fillColor: widget.isReadOnly ? Colors.white : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 3,
          ),
          hintText: widget.placeholder,
        ),
        validator: _validationLogic,
      ),
    );
  }
}
