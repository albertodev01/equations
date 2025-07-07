import 'package:equations/equations.dart';

/// Exception object thrown by [ExpressionParser].
class ExpressionParserException extends EquationException {
  /// Represents an exception from the [ExpressionParser] class.
  const ExpressionParserException(String message)
    : super(
        message: message,
        messagePrefix: 'ExpressionParserException',
      );
}
