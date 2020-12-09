import 'dart:math' as math;
import 'package:petitparser/petitparser.dart';
import 'package:equations/equations.dart';

/// This function alias is used to create a "callable" parser in [ExpressionParser].
typedef _Evaluator = num Function(num value);

/// Parses mathematical expressions with real numbers and the `x` variable (if
/// any). The only allowed variable name is `x`: any other type of value isn't
/// recognized. Some expressions examples are:
///
///   - `"3*x - 6"`
///   - `"5 + 3 * (4^2)"`
///   - `sqrt(x - 3) - log(10)`
///
/// Note that the multiplication requires the star (*) symbol. Here's a list of
/// all the operators supported by the parser:
///
///   - + (sum)
///   - - (difference)
///   - * (product)
///   - / (division)
///   - ^ (power)
///   - sqrt(x) (square root of `x`)
///   - sin(x) (sine of `x`)
///   - cos(x) (cosine of `x`)
///   - tan(x) (tangent of `x`)
///   - exp(x) (exponential, which is `e^x`)
///   - log() (natural logarithm of `x`)
///   - acos() (arc cosine of `x`)
///   - asin() (arc sine of `x`)
///   - atan() (arc tangent of `x`)
///
/// An exception of type [ExpressionParserException] is thrown in case the string
/// being parsed is malformed.
class ExpressionParser {
  /// A "cached" instance of a parser to be used to evaluate expressions on a
  /// given point.
  static late final double Function(String, double) _parser = (expression, value) {
    final builder = ExpressionBuilder();

    // This primitive is fundamental as it recognzes real numbers from the input
    // and parses them using 'parse'.
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

      // Recognze the 'x' variable
      ..primitive(char('x').trim().map((_) => (num value) => value))

      // Enable the parentheses
      ..wrapper(char('(').trim(), char(')').trim(), (_, _Evaluator a, __) => a)

      // Addin various mathematical operators
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
    builder.group()
      ..left(char('*').trim(), (_Evaluator a, _, _Evaluator b) => a(value) * b(value))
      ..left(char('/').trim(), (_Evaluator a, _, _Evaluator b) => a(value) / b(value));
    builder.group()
      ..left(char('+').trim(), (_Evaluator a, _, _Evaluator b) => a(value) + b(value))
      ..left(char('-').trim(), (_Evaluator a, _, _Evaluator b) => a(value) - b(value));

    // Build the parser
    final parser = builder.build().end();
    return parser.parse(expression).value as double;
  };

  /// Builds a new expression parser accepting strings with a single `x` variable.
  /// For example, valid expressions are:
  ///
  ///   - `2 + x`
  ///   - `3 * x - 6`
  ///   - `x^2 + cos(x / 2)`
  ///
  /// Note that `2*(1+3)` is **valid** while `2(1+3)` is **invalid**.
  const ExpressionParser();

  /// Evaluates the mathematical [expression] in the given [evaluationPoint].
  double evaluate(String expression, double evaluationPoint) =>
    _parser(expression, evaluationPoint);
}
