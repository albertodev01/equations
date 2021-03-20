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
/// An exception of type [ExpressionParserException] is thrown in case the
/// string being parsed is malformed. This parser is also able to recognize some
/// constants:
///
///  - pi (pi, the ratio of the circumference on the diameter)
///  - e (Euler's number)
///  - sqrt2 (the square root of 2)
///  - sqrt3 (the square root of 3)
///  - G (Gauss constant)
class ExpressionParser {
  /// Gauss constant
  static const _g = 0.8346268416740;

  /// Square root of 3
  static const _sqrt3 = 1.7320508075688;

  /// A "cached" instance of a parser to be used to evaluate expressions on a
  /// given point.
  static late final Parser _parser = () {
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

      // Constants
      ..primitive(char('e').trim().map((_) => (num value) => math.e))
      ..primitive(string('pi').trim().map((_) => (num value) => math.pi))
      ..primitive(string('sqrt2').trim().map((_) => (num value) => math.sqrt2))
      ..primitive(string('sqrt3').trim().map((_) => (num value) => _sqrt3))
      ..primitive(string('G').trim().map((_) => (num value) => _g))

      // Enable the parentheses
      ..wrapper(char('(').trim(), char(')').trim(), (_, _Evaluator a, __) => a)

      // Adding various mathematical operators
      ..wrapper(string('sqrt(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => math.sqrt(a(value)))
      ..wrapper(string('sin(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => math.sin(a(value)))
      ..wrapper(string('cos(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => math.cos(a(value)))
      ..wrapper(string('tan(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => math.tan(a(value)))
      ..wrapper(string('exp(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => math.exp(a(value)))
      ..wrapper(string('log(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => math.log(a(value)))
      ..wrapper(string('acos(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => math.acos(a(value)))
      ..wrapper(string('asin(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => math.asin(a(value)))
      ..wrapper(string('atan(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => math.atan(a(value)));

    // Defining operations among operators.
    builder.group().prefix(
        char('-').trim(), (_, _Evaluator a) => (num value) => -a(value));
    builder.group().right(
        char('^').trim(),
        (_Evaluator a, _, _Evaluator b) =>
            (num value) => math.pow(a(value), b(value)));
    builder.group()
      ..left(char('*').trim(),
          (_Evaluator a, _, _Evaluator b) => (num value) => a(value) * b(value))
      ..left(
          char('/').trim(),
          (_Evaluator a, _, _Evaluator b) =>
              (num value) => a(value) / b(value));
    builder.group()
      ..left(char('+').trim(),
          (_Evaluator a, _, _Evaluator b) => (num value) => a(value) + b(value))
      ..left(
          char('-').trim(),
          (_Evaluator a, _, _Evaluator b) =>
              (num value) => a(value) - b(value));

    // Build the parser
    return builder.build().end();
  }();

  /// Builds a new expression parser accepting strings with a single `x` variable.
  /// For example, valid expressions are:
  ///
  ///   - `2 + x`
  ///   - `3 * x - 6`
  ///   - `x^2 + cos(x / 2)`
  ///
  /// Note that `2*(1+3)` is **valid** while `2(1+3)` is **invalid**.
  const ExpressionParser();

  /// Evaluates the mathematical [expression] and returns the result.
  num evaluate(String expression) => evaluateOn(expression, 0);

  /// Evaluates the mathematical [expression] and replaces the `x` variable with
  /// the value of the given [evaluationPoint].
  num evaluateOn(String expression, double evaluationPoint) {
    if (!_parser.accept(expression)) {
      throw const ExpressionParserException('The given expression cannot be '
          'parsed! Make sure that all operators are supported. Make also sure '
          "that the product of two values explicitly has the '*' symbol.");
    }

    return _parser.parse(expression).value(evaluationPoint) as num;
  }
}
