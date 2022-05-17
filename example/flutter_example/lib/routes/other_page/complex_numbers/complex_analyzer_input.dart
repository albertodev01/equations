import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/other_page/complex_numbers/complex_number_input.dart';
import 'package:equations_solver/routes/other_page/model/inherited_other.dart';
import 'package:flutter/material.dart';

/// This widget contains a [ComplexNumberInput] needed to parse the values of
/// the complex number to be analyzed.
class ComplexAnalyzerInput extends StatefulWidget {
  /// Creates a [ComplexAnalyzerInput] widget.
  const ComplexAnalyzerInput({super.key});

  @override
  State<ComplexAnalyzerInput> createState() => _ComplexAnalyzerInputState();
}

class _ComplexAnalyzerInputState extends State<ComplexAnalyzerInput> {
  /// The [TextEditingController] for the real part of the complex number.
  late final realController = _generateTextController(0);

  /// The [TextEditingController] for the real part of the complex number.
  late final imaginaryController = _generateTextController(1);

  /// Form validation key.
  final formKey = GlobalKey<FormState>();

  /// Generates the controllers and hooks them to the [TextFieldValuesCubit] in
  /// order to cache the user input.
  TextEditingController _generateTextController(int index) {
    // Initializing with the cached value, if any
    final controller = TextEditingController();

    return controller;
  }

  /// Form and results cleanup.
  void cleanInput() {
    realController.clear();
    imaginaryController.clear();

    context.otherState.clear();
    FocusScope.of(context).unfocus();
  }

  /// Analyzes the complex number.
  void complexAnalyze() {
    if (formKey.currentState?.validate() ?? false) {
      context.otherState.complexAnalyze(
        realPart: realController.text,
        imaginaryPart: imaginaryController.text,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.invalid_values),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    realController.dispose();
    imaginaryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Some spacing
          const SizedBox(
            height: 60,
          ),

          // Complex number input
          ComplexNumberInput(
            realController: realController,
            imaginaryController: imaginaryController,
          ),

          // Some spacing
          const SizedBox(
            height: 30,
          ),

          // Two buttons needed to "solve" and "clear" the system
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Solving the equation
              ElevatedButton(
                key: const Key('ComplexAnalyze-button-analyze'),
                onPressed: complexAnalyze,
                child: Text(context.l10n.analyze),
              ),

              // Some spacing
              const SizedBox(width: 30),

              // Cleaning the inputs
              ElevatedButton(
                key: const Key('ComplexAnalyze-button-clean'),
                onPressed: cleanInput,
                child: Text(context.l10n.clean),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
