import 'package:equations/equations.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// This widget shows a [Complex] value into a [Card] widget and places the
/// fractional representation of the real/imaginary part at the bottom.
class ComplexResultCard extends StatelessWidget {
  /// The complex number to be displayed.
  ///
  /// This value is printed with 10 decimal digits.
  final Complex value;

  /// Text to be displayed in front of the complex number.
  ///
  /// By default, this value is an empty string.
  final String leading;

  /// Decides whether a fraction has to appear at the bottom.
  ///
  /// This is `true` by default.
  final bool withFraction;

  /// Creates a [ComplexResultCard] widget.
  const ComplexResultCard({
    super.key,
    required this.value,
    this.leading = '',
    this.withFraction = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget? subtitle;

    if (withFraction) {
      subtitle = Text(
        '${context.l10n.fraction}: ${value.toStringAsFraction()}',
        key: const Key('Fraction-ComplexResultCard'),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: SizedBox(
          width: cardWidgetsWidth,
          child: Card(
            elevation: 5,
            child: ListTile(
              title: Text('$leading${value.toStringAsFixed(8)}'),
              subtitle: subtitle,
            ),
          ),
        ),
      ),
    );
  }
}
