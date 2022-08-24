import 'package:equations/equations.dart';

/// Exception object thrown by [PolynomialLongDivision].
class PolynomialLongDivisionException extends EquationException {
  /// Represents an exception from the [PolynomialLongDivision] class.
  const PolynomialLongDivisionException(String message)
      : super(
          message: message,
          messagePrefix: 'PolynomialLongDivisionException',
        );
}
