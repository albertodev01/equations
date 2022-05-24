import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/polynomial_page/model/inherited_polynomial.dart';
import 'package:equations_solver/routes/polynomial_page/utils/polynomial_discriminant.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';

/// The results of the polynomial equations.
class PolynomialResults extends StatelessWidget {
  /// Creates a [PolynomialResults] widget.
  const PolynomialResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Some spacing
        const SizedBox(
          height: 80,
        ),

        SectionTitle(
          pageTitle: context.l10n.solutions,
          icon: const EquationSolution(),
        ),

        // Showing the solutions of the polynomial
        const _PolynomialSolutions(),

        // Separator line
        const SizedBox(
          height: 80,
        ),

        SectionTitle(
          pageTitle: context.l10n.discriminant,
          icon: const SystemsLogo(),
        ),

        // Showing the solutions of the polynomial
        const PolynomialDiscriminant(
          key: Key('PolynomialDiscriminant'),
        ),
      ],
    );
  }
}

class _PolynomialSolutions extends StatelessWidget {
  const _PolynomialSolutions();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: context.polynomialState,
      builder: (context, _) {
        final algebraic = context.polynomialState.state.algebraic;

        if (algebraic != null) {
          final roots = algebraic.solutions();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final root in roots)
                ComplexResultCard(
                  value: root,
                ),
            ],
          );
        }

        return const NoResults();
      },
    );
  }
}
