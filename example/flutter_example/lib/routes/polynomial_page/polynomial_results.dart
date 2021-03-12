import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
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
        // Separator line to divide the input field section from the results
        // section underneath
        const SizedBox(
          height: 80,
        ),

        SectionTitle(
          pageTitle: context.l10n.solutions,
          icon: SvgPicture.asset(
            "assets/solutions.svg",
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
  bool buildCondition(PolynomialState previous, PolynomialState current) =>
      (previous != current) &&
      ((current is PolynomialRoots) || (current is PolynomialNone));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PolynomialBloc, PolynomialState>(
      builder: (context, state) {
        debugPrint(state.runtimeType.toString());
        if (state is PolynomialRoots) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.roots.length,
            itemBuilder: (context, index) => _PolynomialRoot(
              root: state.roots[index],
            ),
          );
        }

        return noResults;
      },
    );
  }
}

class _PolynomialRoot extends StatelessWidget {
  final Complex root;
  const _PolynomialRoot({
    required this.root,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: SizedBox(
          width: 250,
          child: Card(
            elevation: 5,
            child: ListTile(
              title: Text("x = $root"),
              subtitle: Text("Tap to see nore"),
            ),
          ),
        ),
      ),
    );
  }
}
