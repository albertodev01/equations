import 'package:equations/equations.dart';

/// Exception object thrown by [Interpolation].
class InterpolationException extends EquationException {
  /// Represents an exception from the [Interpolation] class.
  const InterpolationException(String message)
      : super(
          message: message,
          messagePrefix: 'InterpolationException',
        );
}
