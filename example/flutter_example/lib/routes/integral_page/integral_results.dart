import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The results of the numerical integration.
class IntegralResultsWidget extends StatelessWidget {
  /// Creates an [IntegralResultsWidget] widget.
  const IntegralResultsWidget({super.key});

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
        const _IntegralSolutions(),
      ],
    );
  }
}

/// The numerical value produced by the integral evaluation.
class _IntegralSolutions extends StatelessWidget {
  /// Creates an [_IntegralSolutions] widget.
  const _IntegralSolutions();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IntegralBloc, IntegralState>(
      listener: (context, state) {
        if (state is IntegralError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.nonlinear_error),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is IntegralResult) {
          return RealResultCard(
            value: state.result,
          );
        }

        return const NoResults();
      },
    );
  }
}
