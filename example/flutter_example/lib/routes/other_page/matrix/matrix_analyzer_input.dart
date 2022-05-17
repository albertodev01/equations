import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/number_switcher/inherited_number_switcher.dart';
import 'package:equations_solver/routes/other_page/model/inherited_other.dart';
import 'package:equations_solver/routes/system_page/utils/matrix_input.dart';
import 'package:equations_solver/routes/system_page/utils/size_picker.dart';
import 'package:flutter/material.dart';

/// This widget contains a [MatrixInput] needed to parse the values of the matrix
/// to be analyzed.
class MatrixAnalyzerInput extends StatefulWidget {
  /// Creates a [MatrixAnalyzerInput] widget.
  const MatrixAnalyzerInput({super.key});

  @override
  State<MatrixAnalyzerInput> createState() => _MatrixAnalyzerInputState();
}

class _MatrixAnalyzerInputState extends State<MatrixAnalyzerInput> {
  /// The text input controllers for the matrix.
  late final matrixControllers = List<TextEditingController>.generate(
    25,
    _generateTextController,
  );

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
    for (final controller in matrixControllers) {
      controller.clear();
    }

    context.otherState.clear();
    FocusScope.of(context).unfocus();
  }

  /// Analyzes the matrix.
  void matrixAnalyze() {
    if (formKey.currentState?.validate() ?? false) {
      final size = context.numberSwitcherState.state;

      // Getting the inputs
      final matrixInputs = matrixControllers.sublist(0, size * size).map((c) {
        return c.text;
      }).toList();

      // Analyze the input
      context.otherState.matrixAnalyze(
        matrix: matrixInputs,
        size: size,
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
    for (final controller in matrixControllers) {
      controller.dispose();
    }

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

          // Size changer
          const SizePicker(),

          // Some spacing
          const SizedBox(
            height: 35,
          ),

          // Matrix input
          AnimatedBuilder(
            animation: context.numberSwitcherState,
            builder: (context, _) {
              return MatrixInput(
                matrixControllers: matrixControllers,
                matrixSize: context.numberSwitcherState.state,
              );
            },
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
                key: const Key('MatrixAnalyze-button-analyze'),
                onPressed: matrixAnalyze,
                child: Text(context.l10n.analyze),
              ),

              // Some spacing
              const SizedBox(width: 30),

              // Cleaning the inputs
              ElevatedButton(
                key: const Key('MatrixAnalyze-button-clean'),
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
