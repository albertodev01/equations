import 'package:equations/equations.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// This widget allows for the insertion of the real and the imaginary part of
/// the complex number to be analyzed.
class ComplexNumberInput extends StatefulWidget {
  /// The [TextEditingController] controller for the real part.
  final TextEditingController realController;

  /// The [TextEditingController] controller for the imaginary part.
  final TextEditingController imaginaryController;

  /// Whether the input should be in read-only mode or not.
  ///
  /// By default, this is set to `false`.
  final bool isReadOnly;

  /// Creates a [ComplexNumberInput] widget.
  const ComplexNumberInput({
    required this.realController,
    required this.imaginaryController,
    this.isReadOnly = false,
    super.key,
  });

  @override
  State<ComplexNumberInput> createState() => _ComplexNumberInputState();
}

class _ComplexNumberInputState extends State<ComplexNumberInput> {
  String? _validationLogic(String? value) {
    if (value != null) {
      if (!value.isNumericalExpression) {
        return context.l10n.wrong_input;
      }
    }

    return null;
  }

  /// The decoration of the [TextFormField]s needed to receive the real and
  /// imaginary part.
  InputDecoration get decoration {
    return const InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Real part
        SizedBox(
          width: complexInputWidth,
          child: TextFormField(
            key: const Key('ComplexNumberInput-TextFormField-RealPart'),
            controller: widget.realController,
            textAlign: TextAlign.center,
            decoration: decoration,
            validator: _validationLogic,
            readOnly: widget.isReadOnly,
          ),
        ),

        // The sign
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Text(
            '+',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),

        // Imaginary part
        SizedBox(
          width: complexInputWidth,
          child: TextFormField(
            key: const Key('ComplexNumberInput-TextFormField-ImaginaryPart'),
            controller: widget.imaginaryController,
            textAlign: TextAlign.center,
            decoration: decoration,
            validator: _validationLogic,
            readOnly: widget.isReadOnly,
          ),
        ),

        // The symbol of the imaginary unit
        const Padding(
          padding: EdgeInsets.only(
            left: 5,
          ),
          child: Text(
            'i',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
