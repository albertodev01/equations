import 'package:equations/equations.dart';

/// {@template numerical_integration_exception}
/// Exception object thrown by [NumericalIntegration].
/// {@endtemplate}
class NumericalIntegrationException extends EquationException {
  /// {@macro numerical_integration_exception}
  const NumericalIntegrationException(String message)
    : super(
        message: message,
        messagePrefix: 'NumericalIntegrationException',
      );
}
