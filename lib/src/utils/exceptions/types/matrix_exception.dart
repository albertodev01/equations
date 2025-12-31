import 'package:equations/equations.dart';

/// {@template matrix_exception}
/// Exception object thrown by [Matrix].
/// {@endtemplate}
class MatrixException extends EquationException {
  /// {@macro matrix_exception}
  const MatrixException(String message)
    : super(
        message: message,
        messagePrefix: 'MatrixException',
      );
}
