import 'dart:math' as math;
import 'package:petitparser/petitparser.dart';

typedef _Evaluator = num Function(num value);

/// Parses mathematical expressions with support for variables.
class ExpressionParser {
  /// A "cached" instance of a parser to be used to evaluate expressions on a
  /// given point.
  static late final double Function(String, double) _parser = (expression, value) {
    final builder = ExpressionBuilder();
    builder.group()
      ..primitive(digit()
          .plus()
          .seq(char('.').seq(digit().plus()).optional())
          .flatten()
          .trim()
          .map((a) {
        final number = num.parse(a);
        return (num value) => number;
      }))
      ..primitive(char('x').trim().map((_) => (num value) => value))
      ..wrapper(char('(').trim(), char(')').trim(), (_, _Evaluator a, __) => a)
      ..wrapper(string('sqrt(').trim(), char(')').trim(), (_, _Evaluator a, __) => a(math.sqrt(value)))
      ..wrapper(string('sin(').trim(), char(')').trim(), (_, _Evaluator a, __) => a(math.sin(value)))
      ..wrapper(string('cos(').trim(), char(')').trim(), (_, _Evaluator a, __) => a(math.cos(value)))
      ..wrapper(string('tan(').trim(), char(')').trim(), (_, _Evaluator a, __) => a(math.tan(value)))
      ..wrapper(string('exp(').trim(), char(')').trim(), (_, _Evaluator a, __) => a(math.exp(value)))
      ..wrapper(string('log(').trim(), char(')').trim(), (_, _Evaluator a, __) => a(math.log(value)))
      ..wrapper(string('acos(').trim(), char(')').trim(), (_, _Evaluator a, __) => a(math.acos(value)))
      ..wrapper(string('asin(').trim(), char(')').trim(), (_, _Evaluator a, __) => a(math.asin(value)))
      ..wrapper(string('atan(').trim(), char(')').trim(), (_, _Evaluator a, __) => a(math.atan(value)));

    // Defining operations among operators.
    builder.group()..prefix(char('-').trim(), (_, _Evaluator a) => -a(value));
    builder.group()
      ..right(char('^').trim(), (_Evaluator a, _, _Evaluator b) => math.pow(a(value), b(value)));

    // multiplication and addition are left-associative
    builder.group()
      ..left(char('*').trim(), (_Evaluator a, _, _Evaluator b) => a(value) * b(value))
      ..left(char('/').trim(), (_Evaluator a, _, _Evaluator b) => a(value) / b(value));
    builder.group()
      ..left(char('+').trim(), (_Evaluator a, _, _Evaluator b) => a(value) + b(value))
      ..left(char('-').trim(), (_Evaluator a, _, _Evaluator b) => a(value) - b(value));

    final parser = builder.build().end();
    return parser.parse(expression).value as double;
  };

  /// Builds a new expression parser accepting strings with a single `x` variable.
  /// For example, valid expressions are:
  ///
  ///   - `2 + x`
  ///   - `3 * x - 6`
  ///   - `x^2 + cos(x / 2)`
  const ExpressionParser();

  /// Evaluates the parsed expression using the given [evaluationPoint].
  double evaluate(String expression, double evaluationPoint) =>
    _parser(expression, evaluationPoint);
}
