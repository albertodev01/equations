import 'package:equations/equations.dart';
import 'package:equations_solver/routes/polynomial_page.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_result.dart';
import 'package:flutter/widgets.dart';

/// Represents the analyzers of polynomials that can be solved.
enum PolynomialType {
  /// A polynomial whose degree is 1.
  linear,

  /// A polynomial whose degree is 2.
  quadratic,

  /// A polynomial whose degree is 3.
  cubic,

  /// A polynomial whose degree is 4.
  quartic,
}

/// Holds the state of the [PolynomialPage] page.
class PolynomialState extends ChangeNotifier {
  var state = const PolynomialResult();

  /// The type of polynomial this bloc has to solve.
  final PolynomialType polynomialType;

  /// Creates a
  PolynomialState(this.polynomialType);

  /// Tries to solve a polynomial equation with the given coefficients.
  void solvePolynomial(List<String> coefficients) {
    try {
      // Parsing coefficients
      final params = _parseCoefficients(coefficients);

      state = PolynomialResult(
        algebraic: Algebraic.from(params),
      );
    } on Exception {
      state = const PolynomialResult();
    }

    notifyListeners();
  }

  /// Clears the state.
  void clear() {
    state = const PolynomialResult();
    notifyListeners();
  }

  /// Converts a list of strings into a list of numbers, if possible.
  List<Complex> _parseCoefficients(List<String> rawInput) {
    if (rawInput.length != _coefficientsListLength) {
      throw const FormatException(
        "The coefficients list length doesn't match the coefficients number "
        'expected from the given degree.',
      );
    }

    // Fractions are accepted so this method throws only if the given string is
    // NOT a number or a string
    const parser = ExpressionParser();

    return rawInput.map<Complex>((value) {
      if (!value.isNumericalExpression) {
        throw FormatException('The "$value" input is not a valid number.');
      }

      return Complex.fromReal(parser.evaluate(value));
    }).toList(growable: false);
  }

  int get _coefficientsListLength {
    switch (polynomialType) {
      case PolynomialType.linear:
        return 2;
      case PolynomialType.quadratic:
        return 3;
      case PolynomialType.cubic:
        return 4;
      case PolynomialType.quartic:
        return 5;
    }
  }
}
