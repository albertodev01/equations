import 'package:equations/equations.dart';

/// {@template complex_exception}
/// Exception object thrown by [Complex].
/// {@endtemplate}
class ComplexException extends EquationException {
  /// {@macro complex_exception}
  const ComplexException(String message)
    : super(
        message: message,
        messagePrefix: 'ComplexException',
      );
}
