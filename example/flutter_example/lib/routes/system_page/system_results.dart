import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/system_page/model/inherited_system.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';

/// The vector with the solutions of the system of equations.
class SystemResults extends StatelessWidget {
  /// Creates a [SystemResults] widget.
  const SystemResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Separator line
        const SizedBox(
          height: 80,
        ),

        SectionTitle(
          pageTitle: context.l10n.solutions,
          icon: const EquationSolution(),
        ),

        // Showing the solutions of the nonlinear equation
        const _SystemSolutions(),
      ],
    );
  }
}

/// The solution vector, which is simply a list of [RealResultCard]s.
class _SystemSolutions extends StatelessWidget {
  const _SystemSolutions();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: context.systemState,
      builder: (context, child) {
        final system = context.systemState.state.systemSolver;

        if (system != null) {
          final solutions = system.solve();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final solution in solutions)
                RealResultCard(
                  value: solution,
                ),
              const SizedBox(
                height: 30,
              ),
            ],
          );
        }

        return child!;
      },
      child: const Padding(
        padding: EdgeInsets.only(
          bottom: 30,
        ),
        child: NoResults(),
      ),
    );
  }
}
