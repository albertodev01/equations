import 'package:equations/equations.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:flutter/material.dart';

/// This is just a wrapper of a [TextFormField] that parses and validates the
/// entries of a matrix.
class SystemInputField extends StatefulWidget {
  /// The [TextEditingController] controller.
  final TextEditingController controller;

  /// The placeholder text to show in the input field.
  final String placeholder;

  /// Creates a [SystemInputField] widget.
  const SystemInputField({
    Key? key,
    required this.controller,
    this.placeholder = '',
  }) : super(key: key);

  @override
  State<SystemInputField> createState() => _SystemInputFieldState();
}

class _SystemInputFieldState extends State<SystemInputField>
    with AutomaticKeepAliveClientMixin {
  String? _validationLogic(String? value, BuildContext context) {
    if (value != null) {
      if (!value.isNumericalExpression) {
        return context.l10n.wrong_input;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SizedBox(
      width: 60,
      height: 50,
      child: TextFormField(
        key: const Key('SystemInputField-TextFormField'),
        controller: widget.controller,
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
          hintText: widget.placeholder,
        ),
        validator: (value) => _validationLogic(value, context),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
