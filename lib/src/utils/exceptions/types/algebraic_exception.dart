import 'package:equations/equations.dart';

/// Exception object thrown by [Algebraic].
class AlgebraicException extends EquationException {
  /// Represents an exception from the [Algebraic] class.
  const AlgebraicException(String message)
      : super(
          message: message,
          messagePrefix: 'AlgebraicException',
        );
}
