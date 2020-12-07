import 'package:equations/equations.dart';
import 'package:equations/src/utils/expression_parser.dart';

/// Exception object thrown by [Expression].
class ExpressionParserException extends EquationException {
  /// Represents an error for the [Complex] class.
  const ExpressionParserException(String message)
      : super(message: message, messagePrefix: "ExpressionParserException");
}
