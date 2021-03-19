import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_input_field.dart';
import 'package:equations_solver/routes/utils/equation_text_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equations_solver/localization/localization.dart';

/// TODO documentation
class DataInput extends StatelessWidget {
  const DataInput();

  /// This is required to figure out how many inputs are required for the
  /// polynomial to be solved
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

class _InputWidget extends StatefulWidget {
  final int inputLength;
  final String equationTemplate;
  const _InputWidget({
    required this.inputLength,
    required this.equationTemplate,
  });

  @override
  __InputWidget createState() => __InputWidget();
}

class __InputWidget extends State<_InputWidget> {
  late final controllers = List<TextEditingController>.generate(
    widget.inputLength,
    (_) => TextEditingController(),
    growable: false,
  );

  late final cachedEquationTitle = Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: EquationTextFormatter(equation: widget.equationTemplate),
  );

  final formKey = GlobalKey<FormState>();

  late final cachedWrapBody = generateWrapBody();
  List<PolynomialInputField> generateWrapBody() {
    final body = <PolynomialInputField>[];

    var placeholderLetter = 'a';

    for (var i = 0; i < widget.inputLength; ++i) {
      body.add(PolynomialInputField(
        controller: controllers[i],
        placeholder: placeholderLetter,
      ));

      final newChar = placeholderLetter.codeUnitAt(0) + 1;
      placeholderLetter = String.fromCharCode(newChar);
    }

    return body;
  }

  void _processInput(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      final event = PolynomialSolve(
        coefficients: controllers.map<String>((c) => c.text).toList(),
      );

      context.read<PolynomialBloc>().add(event);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.polynomial_error),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _cleanInput(BuildContext context) {
    for (final controller in controllers) {
      controller.text = '';
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
            ElevatedButton(
              onPressed: () => _processInput(context),
              child: Text(context.l10n.solve),
            ),
            const SizedBox(width: 30),
            ElevatedButton(
              onPressed: () => _cleanInput(context),
              child: Text(context.l10n.clean),
            ),
          ],
        )
      ],
    );
  }
}
