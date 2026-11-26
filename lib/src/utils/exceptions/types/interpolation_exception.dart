import 'package:equations/equations.dart';

/// {@template interpolation_exception}
/// Exception object thrown by [Interpolation].
/// {@endtemplate}
class InterpolationException extends EquationException {
  /// {@macro interpolation_exception}
  const new(String message)
    : super(
        message: message,
        messagePrefix: 'InterpolationException',
      );
}
