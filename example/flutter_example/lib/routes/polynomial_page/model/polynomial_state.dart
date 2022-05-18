import 'package:equations/equations.dart';
import 'package:equations_solver/routes/polynomial_page.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_result.dart';
import 'package:flutter/widgets.dart';

/// The types of polynomials that can be solved.
enum PolynomialType {
  /// A polynomial whose degree is 1.
  linear(2),

  /// A polynomial whose degree is 2.
  quadratic(3),

  /// A polynomial whose degree is 3.
  cubic(4),

  /// A polynomial whose degree is 4.
  quartic(5);

  /// How many coefficients the associated polynomial type has.
  final int coefficients;

  /// Creates a [PolynomialType] enumeration type.
  const PolynomialType(this.coefficients);
}

/// Holds the state of the [PolynomialPage] page.
class PolynomialState extends ChangeNotifier {
  var state = const PolynomialResult();

  /// The type of polynomial represented by this class.
  final PolynomialType polynomialType;

  /// Creates a [PolynomialState] object.
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
    if (rawInput.length != polynomialType.coefficients) {
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
}
