import 'package:equations/equations.dart';

/// Exception object thrown by [Complex].
class ComplexException extends EquationException {
  /// Represents an error for the [Complex] class.
  const ComplexException(String message)
      : super(
          message: message,
          messagePrefix: 'ComplexException',
        );
}
