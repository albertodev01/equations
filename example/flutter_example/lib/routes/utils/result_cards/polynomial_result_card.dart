import 'package:equations/equations.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// This widget shows an [Algebraic] value into a [Card] widget.
class PolynomialResultCard extends StatefulWidget {
  /// The [Algebraic] type to be displayed.
  ///
  /// The coefficients are printed with 6 decimal digits.
  final Algebraic algebraic;

  /// Decides whether a fraction has to appear at the bottom.
  ///
  /// This is `true` by default.
  final bool withFraction;

  /// Creates a [PolynomialResultCard] widget.
  const PolynomialResultCard({
    super.key,
    required this.algebraic,
    this.withFraction = true,
  });

  @override
  State<PolynomialResultCard> createState() => _PolynomialResultCardState();
}

class _PolynomialResultCardState extends State<PolynomialResultCard> {
  /// Caching the list of children containing the results.
  late List<Widget> children = List<Widget>.generate(
    widget.algebraic.coefficients.length,
    createListItem,
    growable: false,
  );

  /// Creates a list with all of the solutions mapped to [ListTile] widgets.
  Widget createListItem(int index) {
    final coefficient = widget.algebraic.coefficients[index];
    final fraction = widget.withFraction
        ? Text(
            '${context.l10n.fraction}: '
            '${coefficient.toStringAsFraction()}',
            key: Key('PolynomialResultCard-Item-$index'),
          )
        : null;

    return ListTile(
      title: Text(coefficient.toStringAsFixed(6)),
      subtitle: fraction,
      trailing: _ExponentOnVariable(
        exponent: index,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant PolynomialResultCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.algebraic != oldWidget.algebraic) {
      children = List<Widget>.generate(
        widget.algebraic.coefficients.length,
        createListItem,
        growable: false,
      );
    }
  }

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
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
    required this.exponent,
  });

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
