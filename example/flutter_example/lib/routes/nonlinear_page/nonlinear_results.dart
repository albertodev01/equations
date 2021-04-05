import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/routes/nonlinear_page/real_result_card.dart';
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

        // Showing the solutions of the polynomial
        const _PolynomialSolutions(),
      ],
    );
  }
}

class _PolynomialSolutions extends StatefulWidget {
  const _PolynomialSolutions();

  @override
  __PolynomialSolutionsState createState() => __PolynomialSolutionsState();
}

class __PolynomialSolutionsState extends State<_PolynomialSolutions> {
  /// Manually caching this subtree portion which doesn't need to be updated
  late final noResults = Center(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(80, 35, 80, 35),
      child: Text(
        context.l10n.no_solutions,
        style: const TextStyle(fontSize: 16),
      ),
    ),
  );

  /// Listen condition for the [BlocBuilder].
  ///
  /// Listens **only** when the state is [PolynomialRoots] or [PolynomialNone].
  bool buildCondition(NonlinearState previous, NonlinearState current) =>
      (previous != current) &&
          ((current is NonlinearGuesses) || (current is NonlinearNone));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonlinearBloc, NonlinearState>(
      builder: (context, state) {
        if (state is NonlinearGuesses) {
          final guess = state.nonlinearResults.guesses.last;
          final convergence = state.nonlinearResults.convergence;
          final efficiency = state.nonlinearResults.efficiency;

          return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              RealResultCard(
                leading: 'x0',
                value: guess,
              ),

              RealResultCard(
                leading: context.l10n.convergence,
                value: convergence,
              ),

              RealResultCard(
                leading: context.l10n.efficiency,
                value: efficiency,
              ),
            ],
          );
        }

        return noResults;
      },
    );
  }
}