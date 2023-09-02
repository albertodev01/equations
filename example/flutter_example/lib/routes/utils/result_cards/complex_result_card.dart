import 'package:equations/equations.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/collapsible.dart';
import 'package:equations_solver/routes/utils/result_cards/colored_text.dart';
import 'package:equations_solver/routes/utils/result_cards/number_printer_extension.dart';
import 'package:flutter/material.dart';

/// This widget shows a [Complex] value into a [Card] widget and expands to show
/// other details.
class ComplexResultCard extends StatelessWidget {
  /// The number to be displayed.
  ///
  /// This value is printed with [resultCardPrecisionDigits] decimal digits.
  final Complex value;

  /// Text displayed in front of [value].
  ///
  /// By default, this value is an empty string.
  final String leading;

  /// Widget displayed after [value].
  ///
  /// By default, this value is initialized with [SizedBox.shrink].
  final Widget trailing;

  /// Creates a [ComplexResultCard] widget.
  const ComplexResultCard({
    required this.value,
    this.leading = '',
    this.trailing = const SizedBox.shrink(),
    super.key,
  });

  String _printComplex({
    required BuildContext context,
    required Complex value,
    bool isPrimary = true,
  }) {
    if (!value.real.isFinite || !value.imaginary.isFinite) {
      return context.l10n.not_computed;
    }

    return isPrimary
        ? value.toStringApproximated(resultCardPrecisionDigits)
        : '$value';
  }

  String _printComplexFraction({
    required BuildContext context,
    required Complex value,
  }) {
    try {
      return value.toStringAsFraction();
    } on Exception {
      return context.l10n.not_computed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fraction = _printComplexFraction(context: context, value: value);
    final primaryText = _printComplex(context: context, value: value);
    final secondaryText = _printComplex(
      context: context,
      value: value,
      isPrimary: false,
    );

    return SizedBox(
      width: cardWidgetsWidth,
      child: Card(
        margin: const EdgeInsets.only(top: 35),
        elevation: 5,
        child: Collapsible(
          primary: Row(
            children: [
              Expanded(
                child: Text(
                  '$leading$primaryText',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              trailing,
            ],
          ),
          secondary: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Not approximated value
              ColoredText(
                leading: context.l10n.more_digits,
                value: secondaryText,
              ),

              const SizedBox(height: 15),

              // Fraction
              ColoredText(
                leading: context.l10n.fraction,
                value: ': $fraction',
              ),

              const SizedBox(height: 8),

              // Warning
              Text(
                context.l10n.fraction_warning,
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
