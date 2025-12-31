import 'package:equations/equations.dart';

/// {@template polynomial_long_division_exception}
/// Exception object thrown by [PolynomialLongDivision].
/// {@endtemplate}
class PolynomialLongDivisionException extends EquationException {
  /// {@macro polynomial_long_division_exception}
  const PolynomialLongDivisionException(String message)
    : super(
        message: message,
        messagePrefix: 'PolynomialLongDivisionException',
      );
}
