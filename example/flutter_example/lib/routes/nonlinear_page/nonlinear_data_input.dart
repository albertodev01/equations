import 'dart:math' as math;

import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/blocs/slider/slider.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/precision_slider.dart';
import 'package:equations_solver/routes/utils/equation_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget contains a series of input widgets needed to parse the
/// coefficients of the nonlinear equation to be solved.
class NonlinearDataInput extends StatefulWidget {
  /// Creates a [NonlinearDataInput] widget.
  const NonlinearDataInput({Key? key}) : super(key: key);

  @override
  _NonlinearDataInputState createState() => _NonlinearDataInputState();
}

class _NonlinearDataInputState extends State<NonlinearDataInput> {
  /// The controllers needed by the [TextFormField]s of the widget.
  late final controllers = List<TextEditingController>.generate(
    fieldsCount,
    (_) => TextEditingController(),
    growable: false,
  );

  /// Manually caching the equation input field.
  late final functionInput = EquationInput(
    key: const Key('EquationInput-function'),
    controller: controllers[0],
    placeholderText: 'f(x)',
  );

  /// Manually caching the inputs.
  late final guessesInput = _GuessesInput(
    controllers: controllers,
    type: _getType,
  );

  /// Form validation key.
  final formKey = GlobalKey<FormState>();

  /// This is required to figure out how many inputs are required for the
  /// equation to be solved.
  NonlinearType get _getType => context.read<NonlinearBloc>().nonlinearType;

  /// How many input fields the widget requires.
  int get fieldsCount => _getType == NonlinearType.singlePoint ? 2 : 3;

  /// Form and chart cleanup.
  void cleanInput() {
    for (final controller in controllers) {
      controller.clear();
    }

    formKey.currentState?.reset();
    context.read<NonlinearBloc>().add(const NonlinearClean());
  }

  /// Solves a nonlinear equation.
  void solve() {
    if (formKey.currentState?.validate() ?? false) {
      final bloc = context.read<NonlinearBloc>();
      final precision = context.read<SliderCubit>().state;
      final algorithm =
          context.read<DropdownCubit>().state.toNonlinearDropdownItems();

      if (_getType == NonlinearType.singlePoint) {
        bloc.add(
          SinglePointMethod(
            method: SinglePointMethod.resolve(algorithm),
            initialGuess: controllers[1].text,
            function: controllers[0].text,
            precision: 1.0 * math.pow(10, -precision),
          ),
        );
      } else {
        bloc.add(
          BracketingMethod(
            method: BracketingMethod.resolve(algorithm),
            lowerBound: controllers[1].text,
            upperBound: controllers[2].text,
            function: controllers[0].text,
            precision: 1.0 * math.pow(10, -precision),
          ),
        );
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
          functionInput,

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

/// Either 1 or 2 [TextFormField] widgets asking for the initial values of the
/// root finding algorithm.
class _GuessesInput extends StatelessWidget {
  /// The controllers of the [TextFormField] widgets.
  final List<TextEditingController> controllers;

  /// The root finding algorithm to be used.
  ///
  /// This determines how many starting points for the algorithm are needed.
  final NonlinearType type;

  /// Creates a [_GuessesInput] instance.
  const _GuessesInput({
    required this.controllers,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 30,
      children: [
        EquationInput(
          key: const Key('EquationInput-first-param'),
          controller: controllers[1],
          placeholderText: 'x0',
          baseWidth: 80,
          maxLength: 8,
          onlyRealValues: true,
        ),
        if (type == NonlinearType.bracketing)
          EquationInput(
            key: const Key('EquationInput-second-param'),
            controller: controllers[2],
            placeholderText: 'x1',
            baseWidth: 80,
            maxLength: 8,
            onlyRealValues: true,
          ),
      ],
    );
  }
}
