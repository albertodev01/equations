import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/polynomial_page/utils/no_discriminant.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocBuilder<PolynomialBloc, PolynomialState>(
      builder: (context, state) {
        if (state is PolynomialRoots) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.roots.length,
            itemBuilder: (context, index) => ComplexResultCard(
              value: state.roots[index],
            ),
          );
        }

        return const NoResults();
      },
    );
  }
}

/// Shows the discriminant of the polynomial equation to be solved.
@visibleForTesting
class PolynomialDiscriminant extends StatelessWidget {
  /// Creates a [PolynomialDiscriminant] widget.
  const PolynomialDiscriminant({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: BlocConsumer<PolynomialBloc, PolynomialState>(
        listener: (context, state) {
          if (state is PolynomialError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.polynomial_error),
                duration: const Duration(
                  seconds: 2,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PolynomialRoots) {
            return ComplexResultCard(
              value: state.discriminant,
            );
          }

          return const NoDiscriminant();
        },
      ),
    );
  }
}
