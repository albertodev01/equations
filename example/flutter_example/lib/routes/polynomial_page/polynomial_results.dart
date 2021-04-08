import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:equations_solver/routes/polynomial_page/complex_result_card.dart';
import 'package:equations_solver/routes/polynomial_page/no_discriminant.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:equations_solver/localization/localization.dart';

/// The results of the polynomial equations.
class PolynomialResults extends StatelessWidget {
  /// Creates a [PolynomialResults] widget.
  const PolynomialResults();

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
        const _PolynomialDiscriminant(),
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
      (previous != current) &&
      ((current is PolynomialRoots) || (current is PolynomialNone));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PolynomialBloc, PolynomialState>(
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

class _PolynomialDiscriminant extends StatefulWidget {
  const _PolynomialDiscriminant();

  @override
  __PolynomialDiscriminantState createState() =>
      __PolynomialDiscriminantState();
}

class __PolynomialDiscriminantState extends State<_PolynomialDiscriminant> {
  /// Listen condition for the [BlocBuilder].
  ///
  /// Listens **only** when the state is [PolynomialRoots] or [PolynomialNone].
  bool buildCondition(PolynomialState previous, PolynomialState current) =>
      (previous != current) &&
      ((current is PolynomialRoots) || (current is PolynomialNone));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: BlocBuilder<PolynomialBloc, PolynomialState>(
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
