import 'package:equations/equations.dart';

/// Exception object thrown by [Matrix].
class MatrixException extends EquationException {
  /// Represents an exception from the [Matrix] class.
  const MatrixException(String message)
      : super(
          message: message,
          messagePrefix: 'MatrixException',
        );
}
