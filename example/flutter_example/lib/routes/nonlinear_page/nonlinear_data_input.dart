import 'dart:math' as math;
import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/blocs/slider/slider.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/precision_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

/// This widget contains a series of XX widgets needed to
/// parse the coefficients of the polynomial to be solved.
class NonlinearDataInput extends StatefulWidget {
  /// Creates a [NonlinearDataInput] widget.
  const NonlinearDataInput();

  @override
  _NonlinearDataInputState createState() => _NonlinearDataInputState();
}

class _NonlinearDataInputState extends State<NonlinearDataInput> {
  /// The controllers needed by the [TextFormField]s of the widget
  late final controllers = List<TextEditingController>.generate(
    fieldsCount,
    (_) => TextEditingController(),
    growable: false,
  );

  /// Manually caching the equation input field
  late final functionInput = _NonlinearInput(
    controller: controllers[0],
    placeholderText: 'f(x)',
  );

  /// Manually caching the inputs
  late final guessesInput = _GuessesInput(
    controllers: controllers,
    type: _getType(context),
  );

  /// This is required to figure out how many inputs are required for the
  /// equation to be solved.
  NonlinearType _getType(BuildContext context) =>
      context.read<NonlinearBloc>().nonlinearType;

  /// How many input fields the widget requires.
  int get fieldsCount => _getType(context) == NonlinearType.singlePoint ? 2 : 3;

  /// Form and chart cleanup
  void cleanInput(BuildContext context) {
    for (final controller in controllers) {
      controller.text = '';
    }

    context.read<NonlinearBloc>().add(const NonlinearClean());
  }

  /// Solves a nonlinear equation.
  void solve(BuildContext context) {
    final precision = context.read<SliderBloc>().state;
    final algorithm = context.read<DropdownCubit>().state;

    if (_getType(context) == NonlinearType.singlePoint) {
      context.read<NonlinearBloc>().add(SinglePointMethod(
        method: SinglePointMethod.resolve(algorithm),
        initialGuess: controllers[1].text,
        function: controllers[0].text,
        precision: 1.0 * math.pow(10, precision),
      ));
    } else {
      context.read<NonlinearBloc>().add(BracketingMethod(
        method: BracketingMethod.resolve(algorithm),
        lowerBound: controllers[1].text,
        upperBound: controllers[2].text,
        function: controllers[0].text,
        precision: 1.0 * math.pow(10, precision),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const DropdownSelection(),

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
            ElevatedButton(
              onPressed: () => solve(context),
              child: Text(context.l10n.solve),
            ),
            const SizedBox(width: 30),
            ElevatedButton(
              onPressed: () => cleanInput(context),
              child: Text(context.l10n.clean),
            ),
          ],
        )
      ],
    );
  }
}

/// A [TextFormField] used to input the function `f(x)`
class _NonlinearInput extends StatelessWidget {
  /// The controller of the function's [TextFormField]
  final TextEditingController controller;

  /// The placeholder text of the widget
  final String placeholderText;

  /// The width of the input, which will scale if the horizontal space is not
  /// enough
  final double baseWidth;

  /// The maximum length of the input
  final int maxLength;

  /// Creates a [_FunctionInput] instance
  const _NonlinearInput({
    required this.controller,
    required this.placeholderText,
    this.baseWidth = 300,
    this.maxLength = 100,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, dimensions) {
        var inputWidth = baseWidth;

        if (dimensions.maxWidth <= baseWidth + 100) {
          inputWidth = dimensions.maxWidth / 1.5;
        }

        return SizedBox(
          width: inputWidth,
          child: TextFormField(
            controller: controller,
            maxLength: maxLength,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: placeholderText,
            ),
          ),
        );
      },
    );
  }
}

/// Either 1 or 2 [TextFormField] widgets asking for the initial values of the
/// root finding algorithm.
class _GuessesInput extends StatelessWidget {
  /// The controllers of the [TextFormField] widgets
  final List<TextEditingController> controllers;

  /// The root finding algorithm to be used.
  ///
  /// This determines how many starting points for the algorithm are needed.
  final NonlinearType type;

  /// Creates a [_GuessesInput] instance
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
        _NonlinearInput(
          controller: controllers[1],
          placeholderText: 'x0',
          baseWidth: 80,
          maxLength: 8,
        ),

        if (type == NonlinearType.bracketing)
          _NonlinearInput(
            controller: controllers[2],
            placeholderText: 'x1',
            baseWidth: 80,
            maxLength: 8,
          ),
      ],
    );
  }
}
