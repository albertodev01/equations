import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/nonlinear_page/model/inherited_nonlinear.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';

/// The results of the nonlinear equation.
class NonlinearResults extends StatelessWidget {
  /// Creates a [NonlinearResults] widget.
  const NonlinearResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Separator line.
        const SizedBox(
          height: 80,
        ),

        SectionTitle(
          pageTitle: context.l10n.solutions,
          icon: const EquationSolution(),
        ),

        // Shows the solutions of the nonlinear equation.
        const _NonlinearSolutions(),
      ],
    );
  }
}

class _NonlinearSolutions extends StatelessWidget {
  const _NonlinearSolutions();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: context.nonlinearState,
      builder: (context, _) {
        final nonlinear = context.nonlinearState.state.nonlinear;

        if (nonlinear != null) {
          // Computation results
          final results = nonlinear.solve();

          final guess = results.guesses.last;
          final convergence = results.convergence;
          final efficiency = results.efficiency;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The guess
              RealResultCard(
                leading: 'x0: ',
                value: guess,
              ),

              // The convergence of the algorithm
              RealResultCard(
                leading: '${context.l10n.convergence}: ',
                value: convergence,
              ),

              // The efficiency of the algorithm
              RealResultCard(
                leading: '${context.l10n.efficiency}: ',
                value: efficiency,
              ),
            ],
          );
        }

        return const NoResults();
      },
    );
  }
}
