import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/system_page/model/inherited_system.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/result_cards/message_card.dart';
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
class _SystemSolutions extends StatefulWidget {
  const _SystemSolutions();

  @override
  State<_SystemSolutions> createState() => _SystemSolutionsState();
}

class _SystemSolutionsState extends State<_SystemSolutions> {
  /// This widget is rendered whenever the matrix is singular.
  late final singularErrorWidget = Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      MessageCard(
        message: context.l10n.singular_matrix_error,
      ),
      const SizedBox(
        height: 30,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: context.systemState,
      builder: (context, child) {
        final state = context.systemState.state;

        if (state.systemSolver != null) {
          final solutions = state.systemSolver!.solve();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < solutions.length; ++i)
                RealResultCard(
                  value: solutions[i],
                  leading: '${String.fromCharCode('a'.codeUnitAt(0) + i)} = ',
                ),
              const SizedBox(
                height: 30,
              ),
            ],
          );
        }

        if (state.isSingular) {
          return singularErrorWidget;
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
