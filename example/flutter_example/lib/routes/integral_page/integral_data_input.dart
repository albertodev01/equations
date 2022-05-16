import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';
import 'package:equations_solver/blocs/plot_zoom/plot_zoom.dart';
import 'package:equations_solver/blocs/textfield_values/textfield_values.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/integral_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/equation_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget contains a series of input widgets needed to parse the
/// equation and the integration bounds.
class IntegralDataInput extends StatefulWidget {
  /// Creates an [IntegralDataInput] widget.
  const IntegralDataInput({super.key});

  @override
  _IntegralDataInputState createState() => _IntegralDataInputState();
}

class _IntegralDataInputState extends State<IntegralDataInput> {
  /// The [TextEditingController] of the function to integrate.
  late final functionController = _generateTextController(0);

  /// The [TextEditingController] of the lower integration bound.
  late final lowerBoundController = _generateTextController(1);

  /// The [TextEditingController] of the upper integration bound.
  late final upperBoundController = _generateTextController(2);

  /// Form validation key.
  final formKey = GlobalKey<FormState>();

  /// Manually caching the equation input field.
  late final functionInput = EquationInput(
    key: const Key('EquationInput-function'),
    controller: functionController,
    placeholderText: 'f(x)',
  );

  /// Manually caching the inputs.
  late final guessesInput = _GuessesInput(
    lowerBound: lowerBoundController,
    upperBound: upperBoundController,
  );

  /// Generates the controllers and hooks them to the [TextFieldValuesCubit] in
  /// order to cache the user input.
  TextEditingController _generateTextController(int index) {
    // Initializing with the cached value, if any
    final controller = TextEditingController(
      text: context.read<TextFieldValuesCubit>().getValue(index),
    );

    // Listener that updates the value
    controller.addListener(() {
      context.read<TextFieldValuesCubit>().setValue(
            index: index,
            value: controller.text,
          );
    });

    return controller;
  }

  /// Form and chart cleanup.
  void cleanInput() {
    functionController.clear();
    lowerBoundController.clear();
    upperBoundController.clear();

    formKey.currentState?.reset();
    context.read<IntegralBloc>().add(const IntegralClean());
    context.read<PlotZoomCubit>().reset();
    context.read<TextFieldValuesCubit>().reset();

    FocusScope.of(context).unfocus();
  }

  /// Solves a nonlinear equation.
  void solve() {
    if (formKey.currentState?.validate() ?? false) {
      final bloc = context.read<IntegralBloc>();
      final dropdown = context.read<DropdownCubit>().state;
      late IntegralType type;

      switch (dropdown.toIntegralDropdownItems()) {
        case IntegralDropdownItems.simpson:
          type = IntegralType.simpson;
          break;
        case IntegralDropdownItems.trapezoid:
          type = IntegralType.trapezoid;
          break;
        case IntegralDropdownItems.midpoint:
          type = IntegralType.midPoint;
          break;
      }

      bloc.add(
        IntegralSolve(
          function: functionController.text,
          lowerBound: lowerBoundController.text,
          upperBound: upperBoundController.text,
          intervals: 32,
          integralType: type,
        ),
      );
    } else {
      // Malformed inputs
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
    return BlocListener<TextFieldValuesCubit, Map<int, String>>(
      listener: (_, state) {
        if (state.isEmpty) {
          functionController.clear();
          lowerBoundController.clear();
          upperBoundController.clear();
        }
      },
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Some space from the top
            const SizedBox(height: 40),

            // The equation input
            functionInput,

            // The guesses required by the app
            guessesInput,

            // Some spacing
            const SizedBox(height: 40),

            // Which algorithm has to be used
            const IntegralDropdownSelection(),

            // Some spacing
            const SizedBox(height: 50),

            // Two buttons needed to "solve" and "clear" the equation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Solving the equation
                ElevatedButton(
                  key: const Key('Integral-button-solve'),
                  onPressed: solve,
                  child: Text(context.l10n.solve),
                ),

                // Some spacing
                const SizedBox(width: 30),

                // Cleaning the inputs
                ElevatedButton(
                  key: const Key('Integral-button-clean'),
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

/// The two [TextFormField] widgets asking for the upper and lower integration
/// bounds.
class _GuessesInput extends StatelessWidget {
  /// The [TextEditingController] of the lower integration bound.
  final TextEditingController lowerBound;

  /// The [TextEditingController] of the upper integration bound.
  final TextEditingController upperBound;

  /// Creates a [_GuessesInput] instance.
  const _GuessesInput({
    required this.lowerBound,
    required this.upperBound,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 30,
      children: [
        EquationInput(
          key: const Key('IntegralInput-lower-bound'),
          controller: lowerBound,
          placeholderText: 'a',
          baseWidth: integrationBoundsWidth,
          maxLength: 8,
          onlyRealValues: true,
        ),
        EquationInput(
          key: const Key('IntegralInput-upper-bound'),
          controller: upperBound,
          placeholderText: 'b',
          baseWidth: integrationBoundsWidth,
          maxLength: 8,
          onlyRealValues: true,
        ),
      ],
    );
  }
}
