import 'package:equations/equations.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// This widget shows an [Algebraic] value into a [Card] widget.
class PolynomialResultCard extends StatelessWidget {
  /// The [Algebraic] type to be displayed.
  ///
  /// This coefficients are printed with 6 decimal digits.
  final Algebraic algebraic;

  /// Decides whether a fraction has to appear at the bottom.
  ///
  /// This is `true` by default.
  final bool withFraction;

  /// Creates a [PolynomialResultCard] widget.
  const PolynomialResultCard({
    Key? key,
    required this.algebraic,
    this.withFraction = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 35,
        ),
        child: SizedBox(
          width: cardWidgetsWidth,
          child: Card(
            elevation: 5,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: algebraic.coefficients.length,
              itemBuilder: (context, index) {
                final coefficient = algebraic.coefficients[index];
                final fraction = withFraction
                    ? Text(
                        '${context.l10n.fraction}: '
                        '${coefficient.toStringAsFraction()}',
                      )
                    : null;

                return ListTile(
                  title: Text(coefficient.toStringAsFixed(6)),
                  subtitle: fraction,
                  trailing: _ExponentOnVariable(
                    exponent: index,
                  ),
                );
              },
              separatorBuilder: (_, __) {
                return const SizedBox(
                  height: 5,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Nicely prints the exponent as superscript next to the `x` letter, like
/// x<sup>2</sup>.
class _ExponentOnVariable extends StatelessWidget {
  /// The exponent of the `x` unknown.
  final int exponent;

  /// Creates an [_ExponentOnVariable] widget.
  const _ExponentOnVariable({
    Key? key,
    required this.exponent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (exponent == 0) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The 'x' unknown
        const Padding(
          padding: EdgeInsets.only(
            top: 10,
          ),
          child: Text(
            'x',
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),

        // The superscript
        if (exponent > 1)
          Text(
            '$exponent',
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
      ],
    );
  }
}
