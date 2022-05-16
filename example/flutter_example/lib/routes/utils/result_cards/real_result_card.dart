import 'package:equations/equations.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// This widget shows a [double] value into a [Card] widget and optionally
/// places the fractional representation at the bottom.
class RealResultCard extends StatelessWidget {
  /// The number to be displayed.
  ///
  /// This value is printed with 8 decimal digits.
  final double value;

  /// Text to be displayed in front of the complex number.
  ///
  /// By default, this value is an empty string.
  final String leading;

  /// Decides whether a fraction has to appear at the bottom.
  ///
  /// This is `true` by default.
  final bool withFraction;

  /// Creates a [RealResultCard] widget.
  const RealResultCard({
    super.key,
    required this.value,
    this.leading = '',
    this.withFraction = true,
  });

  String _nanToString(BuildContext context, double value) {
    if (!value.isFinite) {
      return context.l10n.not_computed;
    }

    return value.toStringAsFixed(8);
  }

  @override
  Widget build(BuildContext context) {
    Widget? subtitle;

    if (withFraction && value.isFinite) {
      final fraction = Fraction.fromDouble(value);

      subtitle = Text(
        '${context.l10n.fraction}: $fraction',
        key: const Key('Fraction-ResultCard'),
      );
    }

    final valueString = _nanToString(context, value);

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: SizedBox(
          width: cardWidgetsWidth,
          child: Card(
            elevation: 5,
            child: ListTile(
              title: Text('$leading$valueString'),
              subtitle: subtitle,
            ),
          ),
        ),
      ),
    );
  }
}
