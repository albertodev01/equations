import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:equations_solver/blocs/system_solver/bloc/bloc.dart';
import 'package:equations_solver/blocs/system_solver/bloc/events.dart';
import 'package:equations_solver/blocs/system_solver/system_solver.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/system_page/utils/jacobi_initial_vector.dart';
import 'package:equations_solver/routes/system_page/utils/matrix_input.dart';
import 'package:equations_solver/routes/system_page/utils/size_picker.dart';
import 'package:equations_solver/routes/system_page/utils/sor_relaxation_factor.dart';
import 'package:equations_solver/routes/system_page/utils/vector_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget contains a series of [PolynomialInputField] widgets needed to
/// parse the values of the matrix of the system in the `Ax = b` equation.
class SystemDataInput extends StatefulWidget {
  /// Creates a [SystemDataInput] widget.
  const SystemDataInput({
    Key? key,
  }) : super(key: key);

  @override
  SystemDataInputState createState() => SystemDataInputState();
}

/// State of the [SystemDataInput] widget.
@visibleForTesting
class SystemDataInputState extends State<SystemDataInput> {
  /// The text input controllers for the matrix.
  ///
  /// This is asking for `A` in the `Ax = b` equation where:
  ///
  ///  - `A` is the matrix
  ///  - `b` is the known values vector
  late final matrixControllers = List<TextEditingController>.generate(
    16,
    (_) => _generateTextController(),
  );

  /// The text input controllers for the vector.
  ///
  /// This is asking for `b` in the `Ax = b` equation where:
  ///
  ///  - `A` is the matrix
  ///  - `b` is the known values vector
  late final vectorControllers = List<TextEditingController>.generate(
    4,
    (_) => _generateTextController(),
  );

  /// The text input controllers for the initial guess vector of the Jacobi
  /// algorithm.
  late final jacobiControllers = List<TextEditingController>.generate(
    4,
    (_) => _generateTextController(),
  );

  /// A controller for the relaxation factor `w` of the SOR algorithm.
  final wSorController = TextEditingController();

  /// Form validation key.
  final formKey = GlobalKey<FormState>();

  /// The text that describes what the matrix does.
  late final matrixText = descriptionText(
    context.l10n.matrix_description,
  );

  /// The text that describes what the vector does.
  late final vectorText = descriptionText(
    context.l10n.vector_description,
  );

  /// The widget asking for the relaxation factor `w` of the SOR algorithm.
  late final wInput = RelaxationFactorInput(
    textEditingController: wSorController,
  );

  /// This is required to figure out which system solving algorithm has to be
  /// used.
  SystemType get _getType => context.read<SystemBloc>().systemType;

  /// Returns a [TextEditingController] for the list generator.
  TextEditingController _generateTextController() => TextEditingController();

  /// Builds a grey [Text] widget that describes what some parts of the UI do.
  Widget descriptionText(String description) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
      // Row + Expanded can easily make the text go to a new line
      child: Text(
        description,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// Form and chart cleanup.
  void cleanInput() {
    for (final controller in matrixControllers) {
      controller.clear();
    }

    for (final controller in vectorControllers) {
      controller.clear();
    }

    for (final controller in jacobiControllers) {
      controller.clear();
    }

    formKey.currentState?.reset();
    wSorController.clear();

    context.read<SystemBloc>().add(const SystemClean());
  }

  /// Solves a system of equations.
  void solve() {
    if (formKey.currentState?.validate() ?? false) {
      final algorithm = context.read<DropdownCubit>().state;
      final bloc = context.read<SystemBloc>();
      final size = context.read<NumberSwitcherCubit>().state;

      // Getting the inputs
      final systemInputs = matrixControllers.sublist(0, size * size).map((c) {
        return c.text;
      }).toList();

      final vectorInputs = vectorControllers.sublist(0, size).map((c) {
        return c.text;
      }).toList();

      // Solving the system
      switch (_getType) {
        case SystemType.rowReduction:
          bloc.add(RowReductionMethod(
            matrix: systemInputs,
            knownValues: vectorInputs,
            size: size,
          ));
          break;
        case SystemType.factorization:
          bloc.add(FactorizationMethod(
            matrix: systemInputs,
            knownValues: vectorInputs,
            size: size,
            method: FactorizationMethod.resolve(algorithm),
          ));
          break;
        case SystemType.iterative:
          final initialGuesses = jacobiControllers.sublist(0, size).map((c) {
            return c.text;
          }).toList();

          bloc.add(IterativeMethod(
            matrix: systemInputs,
            knownValues: vectorInputs,
            size: size,
            method: IterativeMethod.resolve(algorithm),
            w: wSorController.text,
            jacobiInitialVector: initialGuesses,
          ));
          break;
      }
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
    wSorController.dispose();

    for (final controller in matrixControllers) {
      controller.dispose();
    }

    for (final controller in vectorControllers) {
      controller.dispose();
    }

    for (final controller in jacobiControllers) {
      controller.clear();
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

            // The description associated to the matrix widget
            matrixText,

            // Some spacing
            const SizedBox(
              height: 30,
            ),

            // Vector input
            BlocBuilder<NumberSwitcherCubit, int>(
              builder: (context, state) => VectorInput(
                vectorControllers: vectorControllers,
                vectorSize: state,
              ),
            ),

            // The description associated to the matrix widget
            vectorText,

            // Algorithm type picker
            const SystemDropdownSelection(),

            // The optional input for the relaxation value
            wInput,

            // The optional input for the initial guesses vector
            // Vector input
            BlocBuilder<NumberSwitcherCubit, int>(
              builder: (context, state) => JacobiVectorInput(
                controllers: jacobiControllers,
                vectorSize: state,
              ),
            ),

            // Spacing
            const SizedBox(height: 45),

            // Two buttons needed to "solve" and "clear" the system
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Solving the equation
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
      ),
    );
  }
}
