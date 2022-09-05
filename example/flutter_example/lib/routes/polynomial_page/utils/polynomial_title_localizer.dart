import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/polynomial_page/model/inherited_polynomial.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_body.dart';
import 'package:flutter/material.dart';

/// Mixin for [PolynomialBody] widgets that helps localizing the page title.
mixin PolynomialTitleLocalizer on StatelessWidget {
  /// Localizes the title of a polynomial solver tab.
  String getLocalizedName(BuildContext context) {
    final polynomialType = context.polynomialState.polynomialType;

    switch (polynomialType) {
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
}
