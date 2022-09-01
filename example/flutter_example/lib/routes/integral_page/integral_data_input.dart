import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/integral_page/integral_body.dart';
import 'package:equations_solver/routes/integral_page/model/inherited_integral.dart';
import 'package:equations_solver/routes/integral_page/model/integral_state.dart';
import 'package:equations_solver/routes/integral_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:equations_solver/routes/models/plot_zoom/inherited_plot_zoom.dart';
import 'package:equations_solver/routes/models/text_controllers/inherited_text_controllers.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/equation_input.dart';
import 'package:equations_solver/routes/utils/input_kind_dialog_button.dart';
import 'package:flutter/material.dart';

/// This widget contains a series of input widgets for [IntegralBody] to parse
/// the equation and the integration bounds.
class IntegralDataInput extends StatefulWidget {
  /// Creates an [IntegralDataInput] widget.
  const IntegralDataInput({super.key});

  @override
  State<IntegralDataInput> createState() => _IntegralDataInputState();
}

class _IntegralDataInputState extends State<IntegralDataInput> {
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

  /// The [TextEditingController] for the function.
  TextEditingController get functionController => context.textControllers.first;

  /// The [TextEditingController] for the lower integration bound.
  TextEditingController get lowerBoundController => context.textControllers[1];

  /// The [TextEditingController] for the upper integration bound.
  TextEditingController get upperBoundController => context.textControllers[2];

  /// Form and chart cleanup.
  void cleanInput() {
    functionController.clear();
    lowerBoundController.clear();
    upperBoundController.clear();

    formKey.currentState?.reset();
    context.integralState.clear();
    context.plotZoomState.reset();

    FocusScope.of(context).unfocus();
  }

  /// Integrates over the given interval.
  void solve() {
    if (formKey.currentState?.validate() ?? false) {
      final dropdown = context.dropdownValue.value;
      IntegralType type;

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

      context.integralState.solveIntegral(
        function: functionController.text,
        lowerBound: lowerBoundController.text,
        upperBound: upperBoundController.text,
        intervals: 32,
        integralType: type,
      );
    } else {
      // Error message in case of malformed inputs
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
          const IntegralDropdownSelection(),

          // Some spacing
          const SizedBox(height: 50),

          // Two buttons needed to "evaluate" and "clear" the integral
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Evaluating the integral
              ElevatedButton(
                key: const Key('Integral-button-solve'),
                onPressed: solve,
                child: Text(context.l10n.solve),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: InputKindDialogButton(
                  inputKindMessage: InputKindMessage.equations,
                ),
              ),

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
