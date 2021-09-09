import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/polynomial_page/utils/complex_result_card.dart';
import 'package:equations_solver/routes/polynomial_page/utils/no_discriminant.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The results of the polynomial equations.
class PolynomialResults extends StatelessWidget {
  /// Creates a [PolynomialResults] widget.
  const PolynomialResults({Key? key}) : super(key: key);

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

        // Separator line
        const SizedBox(
          height: 80,
        ),

        SectionTitle(
          pageTitle: context.l10n.discriminant,
          icon: SvgPicture.asset(
            'assets/matrix.svg',
            height: 40,
          ),
        ),

        // Showing the solutions of the polynomial
        const PolynomialDiscriminant(
          key: Key('PolynomialDiscriminant'),
        ),
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
  /// Listen condition for the [BlocBuilder].
  ///
  /// Listens **only** when the state is [PolynomialRoots] or [PolynomialNone].
  bool buildCondition(PolynomialState previous, PolynomialState current) =>
      (previous != current) && (current is! PolynomialError);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PolynomialBloc, PolynomialState>(
      buildWhen: buildCondition,
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
class PolynomialDiscriminant extends StatefulWidget {
  /// Creates a [PolynomialDiscriminant] widget.
  const PolynomialDiscriminant({
    Key? key,
  }) : super(key: key);

  @override
  _PolynomialDiscriminantState createState() => _PolynomialDiscriminantState();
}

class _PolynomialDiscriminantState extends State<PolynomialDiscriminant> {
  /// Listen condition for the [BlocBuilder].
  ///
  /// Listens **only** when the state is [PolynomialRoots] or [PolynomialNone].
  bool buildCondition(PolynomialState previous, PolynomialState current) =>
      (previous != current) && (current is! PolynomialError);

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
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        buildWhen: buildCondition,
        builder: (context, state) {
          if (state is PolynomialRoots) {
            return ComplexResultCard(
              value: state.discriminant,
              leading: 'D(f) =',
            );
          }

          return const NoDiscriminant();
        },
      ),
    );
  }
}
