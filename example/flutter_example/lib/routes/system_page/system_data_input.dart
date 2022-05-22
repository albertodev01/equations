import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:equations_solver/routes/models/number_switcher/inherited_number_switcher.dart';
import 'package:equations_solver/routes/models/system_text_controllers/inherited_system_controllers.dart';
import 'package:equations_solver/routes/system_page/model/inherited_system.dart';
import 'package:equations_solver/routes/system_page/model/system_state.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/system_page/utils/jacobi_initial_vector.dart';
import 'package:equations_solver/routes/system_page/utils/matrix_input.dart';
import 'package:equations_solver/routes/system_page/utils/size_picker.dart';
import 'package:equations_solver/routes/system_page/utils/sor_relaxation_factor.dart';
import 'package:equations_solver/routes/system_page/utils/vector_input.dart';
import 'package:flutter/material.dart';

/// A wrapper of [MatrixInput] which also handles other specific inputs to
/// solve systems in the `Ax = b` form using different algorithms.
class SystemDataInput extends StatefulWidget {
  /// Creates a [SystemDataInput] widget.
  const SystemDataInput({super.key});

  @override
  SystemDataInputState createState() => SystemDataInputState();
}

/// State of the [SystemDataInput] widget.
@visibleForTesting
class SystemDataInputState extends State<SystemDataInput> {
  /// Form validation key.
  final formKey = GlobalKey<FormState>();

  /// Caching the text that describes what the vector does.
  late final vectorText = Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
    child: Text(
      context.l10n.vector_description,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
    ),
  );

  /// Caching the text that describes what the matrix does.
  late final matrixText = Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
    child: Text(
      context.l10n.matrix_description,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
    ),
  );

  /// This is required to figure out which system solving algorithm has to be
  /// used.
  SystemType get _getType => context.systemState.systemType;

  /// Form cleanup.
  void cleanInput() {
    for (final controller in context.systemTextControllers.matrixControllers) {
      controller.clear();
    }

    for (final controller in context.systemTextControllers.vectorControllers) {
      controller.clear();
    }

    for (final controller in context.systemTextControllers.jacobiControllers) {
      controller.clear();
    }

    context.systemTextControllers.wSorController.clear();

    // Making sure to also clear the form completely
    formKey.currentState?.reset();
    context.systemState.clear();
    context.numberSwitcherState.reset();

    FocusScope.of(context).unfocus();
  }

  /// Solves a system of equations.
  void solve() {
    if (formKey.currentState?.validate() ?? false) {
      final algorithm = context.dropdownValue.value;
      final size = context.numberSwitcherState.state;

      // Getting the inputs
      final systemInputs = context.systemTextControllers.matrixControllers
          .sublist(0, size * size)
          .map((c) => c.text)
          .toList(growable: false);

      final vectorInputs = context.systemTextControllers.vectorControllers
          .sublist(0, size)
          .map((c) => c.text)
          .toList(growable: false);

      // Solving the system
      switch (_getType) {
        case SystemType.rowReduction:
          context.systemState.rowReductionSolver(
            flatMatrix: systemInputs,
            knownValues: vectorInputs,
            size: size,
          );
          break;
        case SystemType.factorization:
          context.systemState.factorizationSolver(
            flatMatrix: systemInputs,
            knownValues: vectorInputs,
            size: size,
            method: SystemState.factorizationResolve(algorithm),
          );
          break;
        case SystemType.iterative:
          final initialGuesses = context.systemTextControllers.jacobiControllers
              .sublist(0, size)
              .map((c) => c.text)
              .toList(growable: false);

          context.systemState.iterativeSolver(
            flatMatrix: systemInputs,
            knownValues: vectorInputs,
            size: size,
            method: SystemState.iterativeResolve(algorithm),
            jacobiInitialVector: initialGuesses,
            w: context.systemTextControllers.wSorController.text,
          );
          break;
      }
    } else {
      // The user entered invalid values,
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
                matrixControllers:
                    context.systemTextControllers.matrixControllers,
                matrixSize: context.numberSwitcherState.state,
              );
            },
          ),

          // The description associated to the matrix widget
          matrixText,

          // Some spacing
          const SizedBox(
            height: 30,
          ),

          // Vector input
          AnimatedBuilder(
            animation: context.numberSwitcherState,
            builder: (context, _) {
              return VectorInput(
                vectorControllers:
                    context.systemTextControllers.vectorControllers,
                vectorSize: context.numberSwitcherState.state,
              );
            },
          ),

          // The description associated to the matrix widget
          vectorText,

          // Algorithm type picker
          const SystemDropdownSelection(),

          // The optional input for the relaxation value
          const _RelaxationFactor(),

          // The optional input for the initial guesses vector
          // Vector input
          AnimatedBuilder(
            animation: context.numberSwitcherState,
            builder: (context, _) {
              return JacobiVectorInput(
                controllers: context.systemTextControllers.jacobiControllers,
                vectorSize: context.numberSwitcherState.state,
              );
            },
          ),

          // Spacing
          const SizedBox(height: 45),

          // Two buttons needed to "solve" and "clear" the system
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Solving the system
              ElevatedButton(
                key: const Key('System-button-solve'),
                onPressed: solve,
                child: Text(context.l10n.solve),
              ),

              // Some spacing
              const SizedBox(width: 30),

              // Cleaning the inputs
              ElevatedButton(
                key: const Key('System-button-clean'),
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

/// The widget asking for the relaxation factor `w` of the SOR algorithm.
class _RelaxationFactor extends StatelessWidget {
  /// Creates a [_RelaxationFactor] widget.
  const _RelaxationFactor({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: context.dropdownValue,
      builder: (context, value, child) {
        final sorValue = SystemDropdownItems.sor.asString().toLowerCase();

        if (value.toLowerCase() == sorValue) {
          return child!;
        }

        // Nothing is displayed if SOR isn't the currently selected option.
        return const SizedBox.shrink();
      },
      child: RelaxationFactorInput(
        textEditingController: context.systemTextControllers.wSorController,
      ),
    );
  }
}
