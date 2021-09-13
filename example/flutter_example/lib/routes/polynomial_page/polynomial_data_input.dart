import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_input_field.dart';
import 'package:equations_solver/routes/utils/body_pages/equation_text_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget contains a series of [PolynomialInputField] widgets needed to
/// parse the coefficients of the polynomial to be solved.
class PolynomialDataInput extends StatelessWidget {
  /// Creates a [PolynomialDataInput] widget.
  const PolynomialDataInput({Key? key}) : super(key: key);

  /// This is required to figure out how many inputs are required for the
  /// polynomial to be solved.
  PolynomialType _getType(BuildContext context) =>
      context.read<PolynomialBloc>().polynomialType;

  @override
  Widget build(BuildContext context) {
    final polynomialType = _getType(context);

    switch (polynomialType) {
      case PolynomialType.linear:
        return const _InputWidget(
          inputLength: 2,
          equationTemplate: 'ax + b',
        );
      case PolynomialType.quadratic:
        return const _InputWidget(
          inputLength: 3,
          equationTemplate: 'ax^2 + bx + c',
        );
      case PolynomialType.cubic:
        return const _InputWidget(
          inputLength: 4,
          equationTemplate: 'ax^3 + bx^2 + cx + d',
        );
      case PolynomialType.quartic:
        return const _InputWidget(
          inputLength: 5,
          equationTemplate: 'ax^4 + bx^3 + cx^2 + dx + e',
        );
    }
  }
}

/// The actual input container.
class _InputWidget extends StatefulWidget {
  /// How many input fields the screen has to display.
  final int inputLength;

  /// The 'form' of the equation. This can be, for example, `ax^2 + bx + c` in
  /// the case of a quadratic polynomial.
  final String equationTemplate;

  /// Creates a [_InputWIdget] widget.
  const _InputWidget({
    required this.inputLength,
    required this.equationTemplate,
  });

  @override
  __InputWidget createState() => __InputWidget();
}

class __InputWidget extends State<_InputWidget> {
  /// Controllers of the various input fields are "cached" because they'll never
  /// change during the lifetime of the widget.
  late final controllers = List<TextEditingController>.generate(
    widget.inputLength,
    (_) => TextEditingController(),
    growable: false,
  );

  /// This is displayed at the top of the input box
  late final cachedEquationTitle = Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: EquationTextFormatter(
      equation: widget.equationTemplate,
    ),
  );

  /// Form validation key
  final formKey = GlobalKey<FormState>();

  /// The input fields are placed inside a [Wrap] widget which will take care of
  /// responsively laying out children in the UI according with the available
  /// width.
  ///
  /// This is cached because the number of input fields won't change.
  late final cachedWrapBody = _generateWrapBody();

  /// Generates the input fields of the coefficients.
  List<PolynomialInputField> _generateWrapBody() {
    final body = <PolynomialInputField>[];
    var placeholderLetter = 'a';

    for (var i = 0; i < widget.inputLength; ++i) {
      body.add(PolynomialInputField(
        // This key is used for testing purposes
        key: Key('PolynomialInputField-coefficient-$i'),
        controller: controllers[i],
        placeholder: placeholderLetter,
      ));

      // Increments by 1 the char code unit. Basically, with the below code we
      // can move from 'a' to 'b' to 'c'...
      final newChar = placeholderLetter.codeUnitAt(0) + 1;
      placeholderLetter = String.fromCharCode(newChar);
    }

    return body;
  }

  /// Validates the input and, if it's valid, sends the data to the bloc
  void _processInput() {
    if (formKey.currentState?.validate() ?? false) {
      final event = PolynomialSolve(
        coefficients: controllers.map<String>((c) => c.text).toList(),
      );

      context.read<PolynomialBloc>().add(event);
    } else {
      context.read<PolynomialBloc>().add(const PolynomialClean());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.polynomial_error),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Form and chart cleanup
  void _cleanInput() {
    for (final controller in controllers) {
      controller.clear();
    }

    formKey.currentState?.reset();
    context.read<PolynomialBloc>().add(const PolynomialClean());
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Some space from the top
        const SizedBox(height: 40),

        cachedEquationTitle,

        // Responsively placing input fields using 'Wrap'
        Padding(
          padding: const EdgeInsets.only(left: 60, right: 60),
          child: Form(
            key: formKey,
            child: Wrap(
              spacing: 30,
              alignment: WrapAlignment.center,
              children: cachedWrapBody,
            ),
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
