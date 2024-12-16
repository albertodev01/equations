import 'package:equations_solver/src/features/polynomial/state/polynomial_state.dart';
import 'package:flutter/material.dart';

class PolynomialHeader extends StatelessWidget {
  /// Creates a [PolynomialHeader] widget.
  const PolynomialHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: RichText(
        text: TextSpan(
          text: 'f(x) =  ',
          style: defaultStyle.copyWith(
            color: Colors.blueAccent,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          children: [
            TextSpan(
              text: switch (context.polynomialState.degree) {
                1 => 'ax + b',
                2 => 'ax^2 + bx + c',
                3 => 'ax^3 + bx^2 + cx + d',
                _ => 'ax^4 + bx^3 + cx^2 + dx + e',
              },
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
