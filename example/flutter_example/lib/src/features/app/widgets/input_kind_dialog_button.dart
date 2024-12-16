import 'package:equations_solver/src/localization/localization.dart';
import 'package:flutter/material.dart';

/// Determines which message should the [InputKindDialogButton] widget show. In
/// particular:
///
///  - [InputKindMessage.numbers] will show a message saying that only numbers
///    and constants (`e` and `pi`) are allowed.
///
///  - [InputKindMessage.equations] will show a message saying that expressions
///    and functions (such as `sin` or `log`) are allowed.
enum InputKindMessage {
  /// Only allows numbers and special constants (`e` and `pi` are allowed).
  numbers,

  /// Equations with operators and functions are allowed.
  equations,
}

/// This is a wrapper of an [IconButton], containing an [Icons.info_outline],
/// that shows an [AlertDialog] telling which kind of inputs are allowed by
/// a form.
class InputKindDialogButton extends StatelessWidget {
  /// Determines which inputs are allowed by a form.
  final InputKindMessage inputKindMessage;

  /// Creates a [InputKindDialogButton] widget.
  const InputKindDialogButton({
    required this.inputKindMessage,
    super.key,
  });

  Future<void> _buttonPressed(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text('${context.l10n.input_allowed_values}:'),
          content: Column(
            children: [
              if (inputKindMessage == InputKindMessage.numbers)
                const _AllowedNumbers()
              else
                const _AllowsFunctions(),

              // Button that closes the dialog
              const Divider(
                height: 35,
              ),

              Center(
                child: ElevatedButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.info_outline,
        size: 18,
      ),
      color: Colors.lightBlueAccent,
      splashRadius: 18,
      onPressed: () async => _buttonPressed(context),
    );
  }
}

/// Lists all allowed numbers and constants.
class _AllowedNumbers extends StatelessWidget {
  /// Creates a [_AllowedNumbers] widget.
  const _AllowedNumbers();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.input_allowed_numbers),
        Text(context.l10n.input_allowed_fractions),
        Text(context.l10n.input_allowed_constants),
      ],
    );
  }
}

/// Lists all allowed numbers, constants and mathematical functions.
class _AllowsFunctions extends StatelessWidget {
  /// Creates a [_AllowsFunctions] widget.
  const _AllowsFunctions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Allows numbers
        const _AllowedNumbers(),

        // Separator line
        const Divider(
          height: 35,
        ),

        // Lists the supported functions
        Text(context.l10n.input_allowed_functions),
        const SizedBox(height: 15),
        const Wrap(
          runSpacing: 5,
          spacing: 5,
          children: [
            _FunctionCard(functionName: 'sqrt(x)'),
            _FunctionCard(functionName: 'sin(x)'),
            _FunctionCard(functionName: 'cos(x)'),
            _FunctionCard(functionName: 'tan(x)'),
            _FunctionCard(functionName: 'log(x)'),
            _FunctionCard(functionName: 'acos(x)'),
            _FunctionCard(functionName: 'asin(x)'),
            _FunctionCard(functionName: 'atan(x)'),
            _FunctionCard(functionName: 'csc(x)'),
            _FunctionCard(functionName: 'sec(x)'),
          ],
        ),

        // Warning about the multiplication
        const _MultiplicationSign(),
      ],
    );
  }
}

/// A wrapper of [Card] that holds a mathematical function sign. This is used
/// within [_AllowsFunctions].
class _FunctionCard extends StatelessWidget {
  /// The function name.
  final String functionName;
  const _FunctionCard({
    required this.functionName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(5),
      shadowColor: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(functionName),
      ),
    );
  }
}

class _MultiplicationSign extends StatelessWidget {
  /// Creates a [_MultiplicationSign] widget.
  const _MultiplicationSign();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Warning about the multiplication
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 12,
          ),
          child: Text(context.l10n.input_allowed_multiplication_sign),
        ),

        // Good example
        const Text.rich(
          TextSpan(
            text: ' - ',
            children: [
              TextSpan(
                text: 'OK',
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ': 2*x-cos(3*x)',
              ),
            ],
          ),
        ),

        // Bad example
        const Text.rich(
          TextSpan(
            text: ' - ',
            children: [
              TextSpan(
                text: 'NO',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ': 2x-cos(3x)',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
