import 'package:equations_solver/routes/polynomial_page/polynomial_data_input.dart';
import 'package:flutter/material.dart';

/// This widget appends a blue `f(x) = ` text in front of an equation. This is
/// used in [PolynomialDataInput].
class EquationTextFormatter extends StatelessWidget {
  /// The equation.
  final String equation;

  /// Creates a [EquationTextFormatter] widget.
  const EquationTextFormatter({
    required this.equation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final style = DefaultTextStyle.of(context).style.copyWith(
          color: Colors.blueAccent,
          fontStyle: FontStyle.italic,
          fontSize: 20,
        );

    return RichText(
      text: TextSpan(
        text: 'f(x) =  ',
        style: style,
        children: [
          TextSpan(
            text: equation,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontStyle: FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}
