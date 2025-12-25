import 'package:equations/equations.dart';

/// {@template interpolation_exception}
/// Exception object thrown by [Interpolation].
/// {@endtemplate}
class InterpolationException extends EquationException {
  /// {@macro interpolation_exception}
  const InterpolationException(String message)
    : super(
        message: message,
        messagePrefix: 'InterpolationException',
      );
}
