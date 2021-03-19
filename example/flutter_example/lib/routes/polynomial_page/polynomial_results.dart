import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:equations_solver/routes/polynomial_page/complex_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:equations_solver/localization/localization.dart';

class PolynomialResults extends StatelessWidget {
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

        return noResults;
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
  /// Manually caching this subtree portion which doesn't need to be updated
  late final noDiscriminant = Center(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(80, 35, 80, 35),
      child: Text(
        context.l10n.no_discriminant,
        style: const TextStyle(fontSize: 16),
      ),
    ),
  );

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
          debugPrint(state.runtimeType.toString());
          if (state is PolynomialRoots) {
            return ComplexResultCard(
              value: state.discriminant,
              leading: 'D(f) =',
            );
          }

          return noDiscriminant;
        },
      ),
    );
  }
}
