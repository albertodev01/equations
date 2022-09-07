import 'package:equations/equations.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:flutter/material.dart';

/// This widget shows a [Algebraic] value into a [Card] widget and expands to
/// show other details.
class PolynomialResultCard extends StatelessWidget {
  /// The [Algebraic] type to be displayed.
  ///
  /// The coefficients are printed with [resultCardPrecisionDigits] decimal
  /// digits.
  final Algebraic algebraic;

  /// Creates a [PolynomialResultCard] widget.
  const PolynomialResultCard({
    required this.algebraic,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < algebraic.coefficients.length; ++i)
          ComplexResultCard(
            value: algebraic.coefficients[i],
            trailing: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
              ),
              child: _ExponentOnVariable(
                exponent: i,
              ),
            ),
          ),
      ],
    );
  }
}

/// Nicely prints the exponent as superscript next to the `x` letter, like
/// x<sup>2</sup>. There are two exceptions:
///
///  - the exponent isn't displayed when [exponent] is `1`;
///  - nothing is displayed when [exponent] is zero.
class _ExponentOnVariable extends StatelessWidget {
  /// The exponent of the `x` unknown.
  final int exponent;

  /// Creates an [_ExponentOnVariable] widget.
  const _ExponentOnVariable({
    required this.exponent,
  });

  @override
  Widget build(BuildContext context) {
    if (exponent == 0) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The 'x' unknown
        const Text(
          'x',
          style: TextStyle(
            fontSize: 16,
          ),
        ),

        // The superscript
        if (exponent > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              '$exponent',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
