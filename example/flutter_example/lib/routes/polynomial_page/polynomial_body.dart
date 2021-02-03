import 'package:equations_solver/routes/polynomial_page/data_input.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_results.dart';
import 'package:equations_solver/routes/utils/sections_logos.dart';
import 'package:flutter/material.dart';
import 'package:equations_solver/localization/localization.dart';

/// Represents the type of polynomial that this widget is asked to handle
enum PolynomialType {
  /// A polynomial whose degree is 1
  linear,

  /// A polynomial whose degree is 2
  quadratic,

  /// A polynomial whose degree is 3
  cubic,

  /// A polynomial whose degree is 4
  quartic,
}

class PolynomialBody extends StatefulWidget {
  final PolynomialType polynomialType;
  const PolynomialBody({
    required this.polynomialType,
  });

  @override
  _PolynomialBodyState createState() => _PolynomialBodyState();
}

class _PolynomialBodyState extends State<PolynomialBody> {
  late final pageTitle = getLocalizedName(context);

  /// Getting the title of the page according with the type of polynomial that
  /// is going to be solved.
  String getLocalizedName(BuildContext context) {
    switch (widget.polynomialType) {
      case PolynomialType.linear:
        return context.l10n.firstDegree;
      case PolynomialType.quadratic:
        return context.l10n.secondDegree;
      case PolynomialType.cubic:
        return context.l10n.thirdDegree;
      case PolynomialType.quartic:
        return context.l10n.fourthDegree;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // The title
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: const PolynomialLogo(
                size: 50,
              ),
            ),
            Text(
              pageTitle,
              style: const TextStyle(fontSize: 26, color: Colors.blueGrey),
            ),
          ],
        ),

        // Data input
        const DataInput(),

        // The results
        const PolynomialResults(),
      ],
    );
  }
}
