import 'package:equations_solver/src/features/app/widgets/input_kind_dialog_button.dart';
import 'package:equations_solver/src/localization/localization.dart';
import 'package:flutter/material.dart';

class PolynomialSolveActions extends StatelessWidget {
  final VoidCallback onSolve;
  final VoidCallback onClear;
  const PolynomialSolveActions({
    required this.onSolve,
    required this.onClear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Solving the polynomial
        ElevatedButton(
          key: const Key('Polynomial-button-solve'),
          onPressed: onSolve,
          child: Text(context.l10n.solve),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: InputKindDialogButton(
            inputKindMessage: InputKindMessage.numbers,
          ),
        ),

        // Cleaning the inputs
        ElevatedButton(
          key: const Key('Polynomial-button-clean'),
          onPressed: onClear,
          child: Text(context.l10n.clear),
        ),
      ],
    );
  }
}
