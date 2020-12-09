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

      // Enable the parentheses
      ..wrapper(char('(').trim(), char(')').trim(), (_, _Evaluator a, __) => a)

      // Addin various mathematical operators
      ..wrapper(string('sqrt(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => a(math.sqrt(value)))
      ..wrapper(string('sin(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => a(math.sin(value)))
      ..wrapper(string('cos(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => a(math.cos(value)))
      ..wrapper(string('tan(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => a(math.tan(value)))
      ..wrapper(string('exp(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => a(math.exp(value)))
      ..wrapper(string('log(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => a(math.log(value)))
      ..wrapper(string('acos(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => a(math.acos(value)))
      ..wrapper(string('asin(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => a(math.asin(value)))
      ..wrapper(string('atan(').trim(), char(')').trim(),
          (_, _Evaluator a, __) => (num value) => a(math.atan(value)));

    // Defining operations among operators.
    builder.group()..prefix(char('-').trim(), (_, _Evaluator a) => (num value) =>  -a(value));
    builder.group()
      ..right(char('^').trim(),
          (_Evaluator a, _, _Evaluator b) => (num value) =>  math.pow(a(value), b(value)));
    builder.group()
      ..left(char('*').trim(),
          (_Evaluator a, _, _Evaluator b) => (num value) => a(value) * b(value))
      ..left(char('/').trim(),
          (_Evaluator a, _, _Evaluator b) => (num value) => a(value) / b(value));
    builder.group()
      ..left(char('+').trim(),
          (_Evaluator a, _, _Evaluator b) => (num value) => a(value) + b(value))
      ..left(char('-').trim(),
          (_Evaluator a, _, _Evaluator b) => (num value) => a(value) - b(value));

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
  num evaluateOn(String expression, double evaluationPoint) =>
      _parser.parse(expression).value(evaluationPoint) as num;
}
