import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/integral_page/model/inherited_integral.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter/material.dart';

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
    return ListenableBuilder(
      listenable: context.integralState,
      builder: (context, _) {
        final integration = context.integralState.state.numericalIntegration;

        if (integration != null) {
          return RealResultCard(
            value: integration.integrate().result,
            leading: 'F(x) = ',
          );
        }

        return const NoResults();
      },
    );
  }
}
