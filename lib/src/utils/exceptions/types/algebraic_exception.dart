import 'package:equations/equations.dart';

/// Exception object thrown by [Algebraic].
class AlgebraicException extends EquationException {
  /// Represents an error for the [Complex] class.
  const AlgebraicException(String message)
      : super(message: message, messagePrefix: "AlgebraicException");
}
