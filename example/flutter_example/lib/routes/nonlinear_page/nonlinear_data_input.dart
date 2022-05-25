import 'dart:math' as math;

import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:equations_solver/routes/models/plot_zoom/inherited_plot_zoom.dart';
import 'package:equations_solver/routes/models/precision_slider/inherited_precision_slider.dart';
import 'package:equations_solver/routes/models/text_controllers/inherited_text_controllers.dart';
import 'package:equations_solver/routes/nonlinear_page/model/inherited_nonlinear.dart';
import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/precision_slider.dart';
import 'package:equations_solver/routes/utils/equation_input.dart';
import 'package:flutter/material.dart';

/// This widget contains a series of input widgets needed to parse the
/// coefficients of the nonlinear equation to be solved.
class NonlinearDataInput extends StatefulWidget {
  /// Creates a [NonlinearDataInput] widget.
  const NonlinearDataInput({super.key});

  @override
  _NonlinearDataInputState createState() => _NonlinearDataInputState();
}

class _NonlinearDataInputState extends State<NonlinearDataInput> {
  /// Manually caching the equation input field.
  late final functionInput = EquationInput(
    key: const Key('EquationInput-function'),
    controller: context.textControllers.first,
    placeholderText: 'f(x)',
  );

  /// Manually caching the inputs.
  final guessesInput = const _GuessesInput();

  /// Form validation key.
  final formKey = GlobalKey<FormState>();

  /// This is required to figure out how many inputs are required for the
  /// equation to be solved.
  NonlinearType get getType => context.nonlinearState.nonlinearType;

  /// Form and chart cleanup.
  void cleanInput() {
    for (final controller in context.textControllers) {
      controller.clear();
    }

    formKey.currentState?.reset();
    context.nonlinearState.clear();
    context.plotZoomState.reset();
    context.precisionState.reset();
    context.dropdownValue.value = context.textControllers.length == 2
        ? NonlinearDropdownItems.newton.name
        : NonlinearDropdownItems.bisection.name;

    FocusScope.of(context).unfocus();
  }

  /// Solves a nonlinear equation.
  void solve() {
    if (formKey.currentState?.validate() ?? false) {
      final precision = context.precisionState.value;
      final algorithm = context.dropdownValue.value.toNonlinearDropdownItems();

      if (getType == NonlinearType.singlePoint) {
        context.nonlinearState.solveWithSinglePoint(
          method: NonlinearState.singlePointResolve(algorithm),
          function: context.textControllers.first.text,
          initialGuess: context.textControllers[1].text,
          precision: 1.0 * math.pow(10, -precision),
        );
      } else {
        context.nonlinearState.solveWithBracketing(
          method: NonlinearState.brackedingResolve(algorithm),
          function: context.textControllers.first.text,
          lowerBound: context.textControllers[1].text,
          upperBound: context.textControllers[2].text,
          precision: 1.0 * math.pow(10, -precision),
        );
      }
    } else {
      // Invalid input
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Some space from the top
          const SizedBox(height: 40),

          // The equation input
          Flexible(
            child: functionInput,
          ),

          // The guesses required by the app
          guessesInput,

          // Some spacing
          const SizedBox(height: 40),

          // Which algorithm has to be used
          const NonlinearDropdownSelection(),

          // Some spacing
          const SizedBox(height: 40),

          // The slider
          const PrecisionSlider(),

          // Some spacing
          const SizedBox(height: 50),

          // Two buttons needed to "solve" and "clear" the equation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Solving the equation
              ElevatedButton(
                key: const Key('Nonlinear-button-solve'),
                onPressed: solve,
                child: Text(context.l10n.solve),
              ),

              // Some spacing
              const SizedBox(width: 30),

              // Cleaning the inputs
              ElevatedButton(
                key: const Key('Nonlinear-button-clean'),
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

/// Either 1 or 2 [EquationInput] widgets asking for the initial values of the
/// root finding algorithm.
class _GuessesInput extends StatelessWidget {
  /// Creates a [_GuessesInput] instance.
  const _GuessesInput();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 30,
      children: [
        EquationInput(
          key: const Key('EquationInput-first-param'),
          controller: context.textControllers[1],
          placeholderText: 'x0',
          baseWidth: 80,
          maxLength: 8,
          onlyRealValues: true,
        ),
        if (context.nonlinearState.nonlinearType == NonlinearType.bracketing)
          EquationInput(
            key: const Key('EquationInput-second-param'),
            controller: context.textControllers[2],
            placeholderText: 'x1',
            baseWidth: 80,
            maxLength: 8,
            onlyRealValues: true,
          ),
      ],
    );
  }
}
