import 'package:equations_solver/blocs/system_solver/system_solver.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/real_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The vector with the solutions of the system of equations.
class SystemResults extends StatelessWidget {
  /// Creates a [SystemResults] widget.
  const SystemResults({Key? key}) : super(key: key);

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

        // Additional spacing
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}

class _SystemSolutions extends StatelessWidget {
  const _SystemSolutions();

  /// Listen condition for the [BlocBuilder].
  ///
  /// Listens **only** when the state is [NonlinearGuesses] or [NonlinearNone].
  bool buildCondition(SystemState previous, SystemState current) =>
      (previous != current) &&
      ((current is SystemGuesses) || (current is SystemNone));

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SystemBloc, SystemState>(
      listener: (context, state) {
        if (state is SystemError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.polynomial_error),
              duration: const Duration(seconds: 2),
            ),
          );
        }

        if (state is SingularSystemError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.singular_matrix_error),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      buildWhen: buildCondition,
      builder: (context, state) {
        if (state is SystemGuesses) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.solution.length,
            itemBuilder: (context, index) => RealResultCard(
              value: state.solution[index],
              leading: 'x[$index] = ',
            ),
          );
        }

        return const NoResults();
      },
    );
  }
}
