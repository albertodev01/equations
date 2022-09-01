import 'package:equations_solver/localization/localization.dart';
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

  void _buttonPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text('${context.l10n.input_allowed_values}:'),
          content: inputKindMessage == InputKindMessage.numbers
              ? const _AllowedNumbers()
              : const _AllowsFunctions(),
          actions: [
            ElevatedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.info_outline,
        size: 14,
      ),
      color: Colors.lightGreen,
      splashRadius: 14,
      onPressed: () => _buttonPressed(context),
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
        const _AllowedNumbers(),
        const SizedBox(height: 10),
        Text(context.l10n.input_allowed_functions),
        const SizedBox(height: 10),
        const Text(' - sqrt(x)'),
        const Text(' - sin(x)'),
        const Text(' - cos(x)'),
        const Text(' - tan(x)'),
        const Text(' - log(x)'),
        const Text(' - acos(x)'),
        const Text(' - asin(x)'),
        const Text(' - atan(x)'),
        const Text(' - csc(x)'),
        const Text(' - sec(x)'),
      ],
    );
  }
}
