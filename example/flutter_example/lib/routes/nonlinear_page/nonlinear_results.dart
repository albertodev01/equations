import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/routes/nonlinear_page/real_result_card.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The results of the nonlinear equation.
class NonlinearResults extends StatelessWidget {
  /// Creates a [NonlinearResults] widget.
  const NonlinearResults();

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

class _NonlinearSolutions extends StatefulWidget {
  const _NonlinearSolutions();

  @override
  _NonlinearSolutionsState createState() => _NonlinearSolutionsState();
}

class _NonlinearSolutionsState extends State<_NonlinearSolutions> {
  /// Listen condition for the [BlocBuilder].
  ///
  /// Listens **only** when the state is [NonlinearGuesses] or [NonlinearNone].
  bool buildCondition(NonlinearState previous, NonlinearState current) =>
      (previous != current) &&
      ((current is NonlinearGuesses) || (current is NonlinearNone));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonlinearBloc, NonlinearState>(
      builder: (context, state) {
        if (state is NonlinearGuesses) {
          // Computation results
          final guess = state.nonlinearResults.guesses.last;
          final convergence = state.nonlinearResults.convergence;
          final efficiency = state.nonlinearResults.efficiency;

          return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
