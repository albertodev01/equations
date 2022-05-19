import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/plot_zoom/inherited_plot_zoom.dart';
import 'package:equations_solver/routes/models/text_controllers/inherited_text_controllers.dart';
import 'package:equations_solver/routes/polynomial_page/model/inherited_polynomial.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_input_field.dart';
import 'package:equations_solver/routes/utils/body_pages/equation_text_formatter.dart';
import 'package:flutter/material.dart';

/// This widget contains a series of [PolynomialInputField] widgets needed to
/// parse the coefficients of the polynomial to be solved.
class PolynomialDataInput extends StatelessWidget {
  /// Creates a [PolynomialDataInput] widget.
  const PolynomialDataInput({super.key});

  @override
  Widget build(BuildContext context) {
    final polynomialType = context.polynomialState.polynomialType;

    switch (polynomialType) {
      case PolynomialType.linear:
        return const _InputWidget(
          equationTemplate: 'ax + b',
        );
      case PolynomialType.quadratic:
        return const _InputWidget(
          equationTemplate: 'ax^2 + bx + c',
        );
      case PolynomialType.cubic:
        return const _InputWidget(
          equationTemplate: 'ax^3 + bx^2 + cx + d',
        );
      case PolynomialType.quartic:
        return const _InputWidget(
          equationTemplate: 'ax^4 + bx^3 + cx^2 + dx + e',
        );
    }
  }
}

/// The actual input container.
class _InputWidget extends StatefulWidget {
  /// The 'form' of the equation. This can be, for example, `ax^2 + bx + c` in
  /// the case of a quadratic polynomial.
  final String equationTemplate;

  /// Creates a [_InputWidget] widget.
  const _InputWidget({
    required this.equationTemplate,
  });

  @override
  __InputWidget createState() => __InputWidget();
}

class __InputWidget extends State<_InputWidget> {
  /// This is displayed at the top of the input box.
  late final cachedEquationTitle = Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: EquationTextFormatter(
      equation: widget.equationTemplate,
    ),
  );

  /// Form validation key.
  final formKey = GlobalKey<FormState>();

  /// The input fields are placed inside a [Wrap] widget which will take care of
  /// responsively laying out children in the UI according with the available
  /// width.
  ///
  /// This is cached because the number of input fields won't change.
  late final Widget cachedWrap = _InputFieldsWrapWidget(
    controllers: context.textControllers,
    inputLength: context.textControllers.length,
  );

  /// Validates the input and, if it's valid, sends the data to the state class.
  void _processInput() {
    if (formKey.currentState?.validate() ?? false) {
      // Valid input
      context.polynomialState.solvePolynomial(
        context.textControllers
            .map<String>((c) => c.text)
            .toList(growable: false),
      );
    } else {
      context.polynomialState.clear();

      // Error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.polynomial_error),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Form cleanup.
  void _cleanInput() {
    for (final controller in context.textControllers) {
      controller.clear();
    }

    formKey.currentState?.reset();
    context.polynomialState.clear();
    context.plotZoomState.reset();

    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),

        cachedEquationTitle,

        // Responsively placing input fields using 'Wrap'
        Padding(
          padding: const EdgeInsets.only(left: 60, right: 60),
          child: Form(
            key: formKey,
            child: cachedWrap,
          ),
        ),

        // A "spacer" widget
        const SizedBox(height: 40),

        // Two buttons needed to "solve" and "clear" the equation
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Solving the polynomial
            ElevatedButton(
              key: const Key('Polynomial-button-solve'),
              onPressed: _processInput,
              child: Text(context.l10n.solve),
            ),

            // Some spacing
            const SizedBox(width: 30),

            // Cleaning the inputs
            ElevatedButton(
              key: const Key('Polynomial-button-clean'),
              onPressed: _cleanInput,
              child: Text(context.l10n.clean),
            ),
          ],
        ),
      ],
    );
  }
}

/// Generates the input fields of the coefficients and puts them in a [Wrap].
class _InputFieldsWrapWidget extends StatelessWidget {
  /// The [TextEditingController]s of each input field.
  final List<TextEditingController> controllers;

  /// How many input fields the screen has to display.
  final int inputLength;

  const _InputFieldsWrapWidget({
    super.key,
    required this.controllers,
    required this.inputLength,
  });

  /// Increments by [index] the char code unit to get a specific letter. For
  /// example:
  ///
  ///   - [index] = 0 -> 'a'
  ///   - [index] = 1 -> 'b'
  ///   - [index] = 2 -> 'c'
  ///   - [index] = 6 -> 'g'
  String placeholderLetter(int index) {
    const firstLetter = 'a';

    return String.fromCharCode(firstLetter.codeUnitAt(0) + index);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 30,
      alignment: WrapAlignment.center,
      children: [
        for (var i = 0; i < inputLength; ++i)
          PolynomialInputField(
            // This key is used for testing purposes
            key: Key('PolynomialInputField-coefficient-$i'),
            controller: controllers[i],
            placeholder: placeholderLetter(i),
          ),
      ],
    );
  }
}
