import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/system_page/utils/matrix_input.dart';
import 'package:equations_solver/routes/system_page/utils/size_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget contains a [MatrixInput] needed to parse the values of the matrix
/// to be analyzed.
class MatrixAnalyzerInput extends StatefulWidget {
  /// Creates a [MatrixAnalyzerInput] widget.
  const MatrixAnalyzerInput({
    Key? key,
  }) : super(key: key);

  @override
  State<MatrixAnalyzerInput> createState() => _MatrixAnalyzerInputState();
}

class _MatrixAnalyzerInputState extends State<MatrixAnalyzerInput> {
  /// The text input controllers for the matrix.
  late final matrixControllers = List<TextEditingController>.generate(
    25,
    (_) => TextEditingController(),
  );

  /// Form validation key.
  final formKey = GlobalKey<FormState>();

  /// Form and results cleanup.
  void cleanInput() {
    for (final controller in matrixControllers) {
      controller.clear();
    }

    context.read<OtherBloc>().add(const OtherClean());
  }

  /// Analyzes the matrix.
  void matrixAnalyze() {
    if (formKey.currentState?.validate() ?? false) {
      final bloc = context.read<OtherBloc>();
      final size = context.read<NumberSwitcherCubit>().state;

      // Getting the inputs
      final matrixInputs = matrixControllers.sublist(0, size * size).map((c) {
        return c.text;
      }).toList();

      // Analyze the input
      bloc.add(MatrixAnalyze(
        matrix: matrixInputs,
        size: size,
      ));
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
    return BlocListener<NumberSwitcherCubit, int>(
      listenWhen: (prev, curr) => prev != curr,
      listener: (context, state) => cleanInput(),
      child: Form(
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
            BlocBuilder<NumberSwitcherCubit, int>(
              builder: (context, state) => MatrixInput(
                matrixControllers: matrixControllers,
                matrixSize: state,
              ),
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
      ),
    );
  }
}
