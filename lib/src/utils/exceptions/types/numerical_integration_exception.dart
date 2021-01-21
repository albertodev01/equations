import 'package:equations/equations.dart';

/// Exception object thrown by [NumericalIntegration].
class NumericalIntegrationException extends EquationException {
  /// Represents an error for the [NumericalIntegration] class.
  const NumericalIntegrationException(String message)
      : super(message: message, messagePrefix: "NumericalIntegrationException");
}
