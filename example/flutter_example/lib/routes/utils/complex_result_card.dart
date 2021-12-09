import 'package:equations/equations.dart';
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

  /// Creates a [ComplexResultCard] widget.
  const ComplexResultCard({
    Key? key,
    required this.value,
    this.leading = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: SizedBox(
          width: 250,
          child: Card(
            elevation: 5,
            child: ListTile(
              title: Text('$leading ${value.toStringAsFixed(8)}'),
              subtitle: Text(
                value.toStringAsFraction(),
                key: const Key('Fraction-ComplexResultCard'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
