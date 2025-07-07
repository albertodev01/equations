import 'package:equations/equations.dart';

/// Exception object thrown by [NumericalIntegration].
class NumericalIntegrationException extends EquationException {
  /// Represents an exception from the [NumericalIntegration] class.
  const NumericalIntegrationException(String message)
    : super(
        message: message,
        messagePrefix: 'NumericalIntegrationException',
      );
}
