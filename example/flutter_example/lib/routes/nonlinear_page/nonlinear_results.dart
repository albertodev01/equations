import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/real_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The results of the nonlinear equation.
class NonlinearResults extends StatelessWidget {
  /// Creates a [NonlinearResults] widget.
  const NonlinearResults({
    Key? key,
  }) : super(key: key);

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
          icon: SvgPicture.asset(
            'assets/solutions.svg',
            height: 40,
          ),
        ),

        // Showing the solutions of the nonlinear equation
        const _NonlinearSolutions(),
      ],
    );
  }
}

class _NonlinearSolutions extends StatelessWidget {
  const _NonlinearSolutions();

  /// Listen condition for the [BlocBuilder].
  ///
  /// Listens **only** when the state is [NonlinearGuesses] or [NonlinearNone].
  bool buildCondition(NonlinearState previous, NonlinearState current) =>
      (previous != current) && (current is! NonlinearError);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NonlinearBloc, NonlinearState>(
      listener: (context, state) {
        if (state is NonlinearError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.nonlinear_error),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      buildWhen: buildCondition,
      builder: (context, state) {
        if (state is NonlinearGuesses) {
          // Computation results
          final guess = state.nonlinearResults.guesses.last;
          final convergence = state.nonlinearResults.convergence;
          final efficiency = state.nonlinearResults.efficiency;

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

              // Some spacing
              const SizedBox(
                height: 65,
              ),
            ],
          );
        }

        return const NoResults();
      },
    );
  }
}
