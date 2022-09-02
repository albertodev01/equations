import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/number_switcher/inherited_number_switcher.dart';
import 'package:equations_solver/routes/models/text_controllers/inherited_text_controllers.dart';
import 'package:equations_solver/routes/other_page/model/inherited_other.dart';
import 'package:equations_solver/routes/system_page/utils/matrix_input.dart';
import 'package:equations_solver/routes/system_page/utils/size_picker.dart';
import 'package:equations_solver/routes/utils/input_kind_dialog_button.dart';
import 'package:flutter/material.dart';

/// Contains the [MatrixInput] widget that parses the matrix to analyze.
class MatrixAnalyzerInput extends StatefulWidget {
  /// Creates a [MatrixAnalyzerInput] widget.
  const MatrixAnalyzerInput({super.key});

  @override
  State<MatrixAnalyzerInput> createState() => _MatrixAnalyzerInputState();
}

class _MatrixAnalyzerInputState extends State<MatrixAnalyzerInput> {
  /// Form validation key.
  final formKey = GlobalKey<FormState>();

  /// Form and results cleanup.
  void cleanInput() {
    for (final controller in context.textControllers) {
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
      final matrixInputs = context.textControllers
          .sublist(0, size * size)
          .map((c) => c.text)
          .toList(growable: false);

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
                matrixControllers: context.textControllers,
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
                key: const Key('MatrixAnalyze-button-clean'),
                onPressed: cleanInput,
                child: Text(context.l10n.clean),
              ),
            ],
          ),

          // Some spacing
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
