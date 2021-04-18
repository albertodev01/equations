import 'package:equations/equations.dart';

/// Exception object thrown by [PolynomialLongDivision].
class PolynomialLongDivisionException extends EquationException {
  /// Represents an error for the [PolynomialLongDivision] class.
  const PolynomialLongDivisionException(String message)
      : super(
          message: message,
          messagePrefix: 'PolynomialLongDivisionException',
        );
}
