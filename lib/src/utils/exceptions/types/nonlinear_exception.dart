import 'package:equations/equations.dart';

/// Exception object thrown by [NonLinear].
class NonlinearException extends EquationException {
  /// Represents an error for the [NonLinear] class.
  const NonlinearException(String message)
      : super(
          message: message,
          messagePrefix: 'NonlinearException',
        );
}
