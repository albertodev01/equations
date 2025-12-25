import 'package:equations/equations.dart';

/// {@template algebraic_exception}
/// Exception object thrown by [Algebraic].
/// {@endtemplate}
class AlgebraicException extends EquationException {
  /// {@macro algebraic_exception}
  const AlgebraicException(String message)
    : super(
        message: message,
        messagePrefix: 'AlgebraicException',
      );
}
