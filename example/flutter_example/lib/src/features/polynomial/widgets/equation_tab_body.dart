import 'package:equations_solver/src/features/app/widgets/inherited_object.dart';
import 'package:equations_solver/src/features/polynomial/state/polynomial_state.dart';
import 'package:equations_solver/src/features/polynomial/widgets/polynomial_header.dart';
import 'package:equations_solver/src/features/polynomial/widgets/polynomial_input_group.dart';
import 'package:equations_solver/src/features/polynomial/widgets/polynomial_solutions.dart';
import 'package:equations_solver/src/features/polynomial/widgets/polynomial_solve_actions.dart';
import 'package:flutter/material.dart';

class EquationTabBody extends StatelessWidget {
  final int degree;
  const EquationTabBody({
    required this.degree,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InheritedObject<PolynomialState>(
      object: PolynomialState(degree: degree),
      child: const EquationTabBodyView(),
    );
  }
}

@visibleForTesting
class EquationTabBodyView extends StatefulWidget {
  const EquationTabBodyView({super.key});

  @override
  State<EquationTabBodyView> createState() => _EquationTabBodyViewState();
}

class _EquationTabBodyViewState extends State<EquationTabBodyView>
    with AutomaticKeepAliveClientMixin {
  late final controllers = List<TextEditingController>.generate(
    context.polynomialState.degree + 1,
    (_) => TextEditingController(),
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.polynomialState.addListener(() {
      if (context.polynomialState.tabState == PolynomialTabState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error')),
        );
      }
    });
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PolynomialHeader(),
            PolynomialInputGroup(
              controllers: controllers,
            ),
            PolynomialSolveActions(
              onSolve: () => context.polynomialState.solve(
                coefficients: controllers.map((e) => e.text).toList(),
              ),
              onClear: () {
                for (final controller in controllers) {
                  controller.clear();
                }

                context.polynomialState.clear();
              },
            ),
            const PolynomialSolutions(),
          ],
        ),
      ),
    );
  }
}
