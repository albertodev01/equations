import 'package:equations/equations.dart';

/// {@template expression_parser_exception}
/// Exception object thrown by [ExpressionParser].
/// {@endtemplate}
class ExpressionParserException extends EquationException {
  /// {@macro expression_parser_exception}
  const ExpressionParserException(String message)
    : super(
        message: message,
        messagePrefix: 'ExpressionParserException',
      );
}
