import 'package:equations/equations.dart';
import 'package:flutter/material.dart';
import 'package:equations_solver/localization/localization.dart';

class PolynomialInputField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  const PolynomialInputField({
    required this.controller,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: TextFormField(
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
        validator: (value) {
          try {
            if (value != null) {
              Fraction.fromString(value);
            }
          } on Exception {
            return context.l10n.wrong_input;
          }

          return null;
        },
      ),
    );
  }
}
