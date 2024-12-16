import 'package:equations/equations.dart';
import 'package:equations_solver/src/features/polynomial/state/polynomial_state.dart';
import 'package:flutter/material.dart';

class PolynomialSolutions extends StatelessWidget {
  const PolynomialSolutions({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: context.polynomialState,
      builder: (_, emptyStateWidget) {
        if (context.polynomialState.solutions.isEmpty) {
          return emptyStateWidget!;
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: context.polynomialState.solutions.map(_Temp.new).toList(),
        );
      },
      child: const SizedBox(height: 16),
    );
  }
}

class _Temp extends StatelessWidget {
  final Complex value;
  const _Temp(this.value);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 35),
      elevation: 5,
      child: Text('$value'),
    );
  }
}
