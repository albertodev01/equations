import 'package:equations/equations.dart';

/// Exception object thrown by [Interpolation].
class InterpolationException extends EquationException {
  /// Represents an error for the [Interpolation] class.
  const InterpolationException(String message)
      : super(
          message: message,
          messagePrefix: 'InterpolationException',
        );
}
