import 'package:equations/equations.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:flutter/material.dart';

/// This widget shows a [double] value into a [Card] widget and optionally
/// places the fractional representation at the bottom.
class RealResultCard extends StatelessWidget {
  /// The number to be displayed.
  final double value;

  /// Text to be displayed in front of the complex number.
  ///
  /// By default, this value is `x =`.
  final String leading;

  /// Decides whether a fraction has to appear at the bottom.
  ///
  /// This is `false` by default.
  final bool withFraction;

  /// Creates a [RealResultCard] widget.
  const RealResultCard({
    Key? key,
    required this.value,
    this.leading = 'x =',
    this.withFraction = false,
  }) : super(key: key);

  String _checkNan(BuildContext context, double value) {
    if (value.isNaN) {
      return context.l10n.not_computed;
    }

    return '$value';
  }

  @override
  Widget build(BuildContext context) {
    Widget? subtitle;

    if (withFraction) {
      final fraction = Fraction.fromDouble(value);
      subtitle = Text(
        '${context.l10n.fraction}: $fraction',
        key: const Key('Fraction-ResultCard'),
      );
    }

    final valueString = _checkNan(context, value);

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: SizedBox(
          width: 250,
          child: Card(
            elevation: 5,
            child: ListTile(
              title: Text('$leading $valueString'),
              subtitle: subtitle,
            ),
          ),
        ),
      ),
    );
  }
}
