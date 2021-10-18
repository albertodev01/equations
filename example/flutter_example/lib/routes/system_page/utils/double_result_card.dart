import 'package:equations/equations.dart';
import 'package:flutter/material.dart';

/// This widget shows a [double] value into a [Card] widget and places the
/// fractional representation at the bottom.
class DoubleResultCard extends StatelessWidget {
  /// The number to be displayed.
  final double value;

  /// Text to be displayed in front of the complex number.
  ///
  /// By default, this value is `x =`.
  final String leading;

  /// Creates a [DoubleResultCard] widget.
  const DoubleResultCard({
    Key? key,
    required this.value,
    this.leading = 'x =',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 35,
        ),
        child: SizedBox(
          width: 250,
          child: Card(
            elevation: 5,
            child: ListTile(
              title: Text('$leading $value'),
              subtitle: Text(
                'Fraction: ${value.toFraction()}',
                key: const Key('Fraction-DoubleResultCard'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
