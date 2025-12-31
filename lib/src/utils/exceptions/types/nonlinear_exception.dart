import 'package:equations/equations.dart';

/// {@template nonlinear_exception}
/// Exception object thrown by [NonLinear].
/// {@endtemplate}
class NonlinearException extends EquationException {
  /// {@macro nonlinear_exception}
  const NonlinearException(String message)
    : super(
        message: message,
        messagePrefix: 'NonlinearException',
      );
}
