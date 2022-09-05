import 'package:equations_solver/routes/polynomial_page/model/inherited_polynomial.dart';
import 'package:equations_solver/routes/polynomial_page/utils/no_discriminant.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:flutter/material.dart';

/// Shows the discriminant of the polynomial.
class PolynomialDiscriminant extends StatelessWidget {
  /// Creates a [PolynomialDiscriminant] widget.
  const PolynomialDiscriminant({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: context.polynomialState,
      builder: (context, _) {
        final algebraic = context.polynomialState.state.algebraic;

        if (algebraic != null) {
          return ComplexResultCard(
            value: algebraic.discriminant(),
          );
        }

        return const NoDiscriminant();
      },
    );
  }
}
