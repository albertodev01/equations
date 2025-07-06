import 'dart:math' as math;

import 'package:equations/equations.dart';
import 'package:petitparser/petitparser.dart';

/// This function alias is used to create a "callable" parser in
/// [ExpressionParser].
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
///   - log(x) (natural logarithm of `x`)
///   - acos(x) (arc cosine of `x`)
///   - asin(x) (arc sine of `x`)
///   - atan(x) (arc tangent of `x`)
///   - csc(x) (cosecant of `x`)
///   - sec(x) (secant of `x`)
///
/// An exception of type [ExpressionParserException] is thrown if the parsed is
/// malformed. This parser is also able to recognize some constants:
///
///  - pi (pi, the ratio of the circumference on the diameter)
///  - e (Euler's number)
///  - sqrt2 (the square root of 2)
///  - sqrt3 (the square root of 3)
///  - G (Gauss constant)
final class ExpressionParser {
  /// Gauss constant.
  static const _g = 0.834626841674;

  /// Square root of 3.
  static const _sqrt3 = 1.7320508075688;

  /// A "cached" instance of a parser that is used to evaluate expressions.
  static final Parser<_Evaluator> _parser = () {
    final builder =
        ExpressionBuilder<_Evaluator>()
          // This primitive is fundamental as it recognizes real numbers from
          // the input and parses them using 'parse'.
          ..primitive(
            digit()
                .plus()
                .seq(char('.').seq(digit().plus()).optional())
                .flatten()
                .trim()
                .map((value) => (_) => num.parse(value)),
          )
          // Recognze the 'x' variable
          ..primitive(char('x').trim().map((_) => (value) => value))
          // Constants
          ..primitive(char('e').trim().map((_) => (value) => math.e))
          ..primitive(string('pi').trim().map((_) => (value) => math.pi))
          ..primitive(string('sqrt2').trim().map((_) => (value) => math.sqrt2))
          ..primitive(string('sqrt3').trim().map((_) => (value) => _sqrt3))
          ..primitive(string('G').trim().map((_) => (value) => _g));

    // Enable the parentheses
    builder.group()
      ..wrapper(char('(').trim(), char(')').trim(), (_, a, _) => a)
      // Adding various mathematical operators
      ..wrapper(
        string('sqrt(').trim(),
        char(')').trim(),
        (_, a, _) => (value) => math.sqrt(a(value)),
      )
      ..wrapper(
        string('abs(').trim(),
        char(')').trim(),
        (_, a, _) => (value) => a(value).abs(),
      )
      ..wrapper(
        string('sin(').trim(),
        char(')').trim(),
        (_, a, _) => (value) => math.sin(a(value)),
      )
      ..wrapper(
        string('cos(').trim(),
        char(')').trim(),
        (_, a, _) => (value) => math.cos(a(value)),
      )
      ..wrapper(
        string('tan(').trim(),
        char(')').trim(),
        (_, a, _) => (value) => math.tan(a(value)),
      )
      ..wrapper(
        string('log(').trim(),
        char(')').trim(),
        (_, a, _) => (value) => math.log(a(value)),
      )
      ..wrapper(
        string('acos(').trim(),
        char(')').trim(),
        (_, a, _) => (value) => math.acos(a(value)),
      )
      ..wrapper(
        string('asin(').trim(),
        char(')').trim(),
        (_, a, _) => (value) => math.asin(a(value)),
      )
      ..wrapper(
        string('atan(').trim(),
        char(')').trim(),
        (_, a, _) => (value) => math.atan(a(value)),
      )
      ..wrapper(
        string('csc(').trim(),
        char(')').trim(),
        (_, a, _) => (value) => 1 / math.sin(a(value)),
      )
      ..wrapper(
        string('sec(').trim(),
        char(')').trim(),
        (_, a, _) => (value) => 1 / math.cos(a(value)),
      );

    // Defining operations among operators.
    builder.group().prefix(char('-').trim(), (_, a) => (value) => -a(value));
    builder.group().right(
      char('^').trim(),
      (a, _, b) => (value) => math.pow(a(value), b(value)),
    );
    builder.group()
      ..left(char('*').trim(), (a, _, b) => (value) => a(value) * b(value))
      ..left(char('/').trim(), (a, _, b) => (value) => a(value) / b(value));
    builder.group()
      ..left(char('+').trim(), (a, _, b) => (value) => a(value) + b(value))
      ..left(char('-').trim(), (a, _, b) => (value) => a(value) - b(value));

    // Build the parser
    return builder.build().end();
  }();

  /// Builds a new expression parser that accepts strings with a single `x`
  /// variable. For example, valid expressions are:
  ///
  ///   - `2 + x`
  ///   - `3 * x - 6`
  ///   - `x^2 + cos(x / 2)`
  ///
  /// Note that `2*(1+3)` is **valid** while `2(1+3)` is **invalid**. You always
  /// have to specify the `*` symbol to multiply two values.
  const ExpressionParser();

  /// Evaluates the mathematical [expression] and returns the result. This
  /// method has to be used to evaluate those expression that do **not** contain
  /// the `x` variable. For example:
  ///
  ///   - `"6 + 10 * 3 / 7"` // Good
  ///   - `"6 + 10 * x / 7"` // Bad
  ///
  /// If you want to evaluate a function with the `x` variable, use [evaluateOn]
  /// instead.
  double evaluate(String expression) {
    if (expression.contains('x') || (!_parser.accept(expression))) {
      throw const ExpressionParserException(
        'The given expression cannot be parsed! Make sure that all operators '
        'are supported. Make also sure that the product of two values '
        "explicitly has the '*' symbol.\n\nThere cannot be the 'x' variable in "
        'the expression because this method only evaluates numbers.',
      );
    }

    return evaluateOn(expression, 0);
  }

  /// Evaluates the mathematical [expression] and replaces the `x` variable with
  /// the value of the given [evaluationPoint].
  ///
  /// If you want to evaluate a simple expression without the `x` variable,
  /// using [evaluate] instead.
  double evaluateOn(String expression, double evaluationPoint) {
    if (!_parser.accept(expression)) {
      throw const ExpressionParserException(
        'The given expression cannot be parsed! Make sure that all operators '
        'are supported. Make also sure that the product of two values '
        "explicitly has the '*' symbol.",
      );
    }

    // The evaluator returns 'num' so we multiply by 1.0 to convert the result
    // into a double.
    return _parser.parse(expression).value(evaluationPoint) * 1.0;
  }
}

/// Extension method for [ExpressionParser] on [String] types.
extension ExpressionParserX on String {
  /// Determines whether this string represents a valid real function `f(x)` or
  /// not. For example, this method returns `true` with the following inputs:
  ///
  ///   - `"x/2"`
  ///   - `"3*x-6"`
  ///   - `"x^2 + sin(x / 2)"`
  ///   - `"10 + 8"`
  ///
  /// The only possible variable is `"x"`. The product **always** needs the `*`
  /// operator.
  ///
  ///   - `"3x - 5"` // Bad
  ///   - `"3*x - 5"` // Good
  bool get isRealFunction =>
      length > 0 && ExpressionParser._parser.accept(this);

  /// Determines whether this string represents a valid numerical expression
  /// such as:
  ///
  ///   - `"3.8 / 2"`
  ///   - `"cos(pi) - 18 * 6"`
  ///
  /// The `x` variable is **not** valid because this getter only considers
  /// numerical values.
  bool get isNumericalExpression =>
      !contains('x') && ExpressionParser._parser.accept(this);
}
