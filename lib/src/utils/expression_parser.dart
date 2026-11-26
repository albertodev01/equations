import 'dart:math' as math;

import 'package:equations/equations.dart';
import 'package:petitparser/petitparser.dart';

/// A parsed expression: a function that evaluates the expression when the `x`
/// variable is equal to [value].
typedef _Evaluator = double Function(double value);

/// {@template expression_parser}
/// Parses mathematical expressions with real numbers and the `x` variable (if
/// any). The only allowed variable name is `x`: any other type of value isn't
/// recognized. Some example expressions are:
///
///   - `"3*x - 6"`
///   - `"5 + 3 * (4^2)"`
///   - `"sqrt(x - 3) - log(10)"`
///
/// Note that the multiplication requires the star (*) symbol. Here's a list of
/// all the operators supported by the parser:
///
///   - + (sum)
///   - - (difference and negation)
///   - * (product)
///   - / (division)
///   - ^ (power)
///   - sqrt(x) (square root of `x`)
///   - abs(x) (absolute value of `x`)
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
/// Operators are applied in this order, from the highest to the lowest
/// precedence:
///
///   1. parentheses and functions (`sqrt(...)`, `sin(...)`, ...)
///   2. negation (`-`)
///   3. power (`^`), which is right-associative: `2^3^2` is `2^(3^2)`
///   4. product (`*`) and division (`/`), from left to right
///   5. sum (`+`) and difference (`-`), from left to right
///
/// Note that negation binds more tightly than the power, so `-x^2` is
/// evaluated as `(-x)^2` and `-2^2` is `4`. Use `-(x^2)` or `0 - x^2` to
/// negate a power. The exponent can be negative, as in `2^-1`.
///
/// An exception of type [ExpressionParserException] is thrown if the expression
/// is malformed. This parser is also able to recognize some constants:
///
///  - pi (pi, the ratio of the circumference to the diameter)
///  - e (Euler's number)
///  - sqrt2 (the square root of 2)
///  - sqrt3 (the square root of 3)
///  - G (Gauss's constant, 1 / agm(1, sqrt(2)))
/// {@endtemplate}
final class ExpressionParser {
  /// {@macro expression_parser}
  const new();

  /// Gauss's constant.
  static const _g = 0.8346268416740732;

  /// Square root of 3.
  static const _sqrt3 = 1.7320508075688772;

  /// The maximum number of parsed expressions kept in [_cache].
  static const _cacheSize = 64;

  /// The most recently parsed expressions, mapped to their evaluators. This
  /// avoids parsing the same expression again when it's evaluated at many
  /// points (for example, by numerical integration algorithms). Entries are
  /// kept in least-recently-used order, and the oldest one is removed when
  /// the cache is full.
  static final _cache = <String, _Evaluator>{};

  /// Returns the evaluator of [expression], or `null` if [expression] cannot
  /// be parsed. Valid expressions are added to [_cache].
  static _Evaluator? _tryEvaluatorOf(String expression) {
    final cached = _cache.remove(expression);

    if (cached != null) {
      // Re-inserting the entry marks it as the most recently used one.
      _cache[expression] = cached;
      return cached;
    }

    final result = _parser.parse(expression);
    if (result is! Success<_Evaluator>) {
      return null;
    }

    if (_cache.length >= _cacheSize) {
      _cache.remove(_cache.keys.first);
    }

    return _cache[expression] = result.value;
  }

  /// Returns the evaluator of [expression], or throws an
  /// [ExpressionParserException] with the given [message] if [expression]
  /// cannot be parsed.
  static _Evaluator _evaluatorOf(String expression, String message) =>
      _tryEvaluatorOf(expression) ?? (throw ExpressionParserException(message));

  /// A "cached" instance of a parser that is used to evaluate expressions.
  static final Parser<_Evaluator> _parser = () {
    final builder = ExpressionBuilder<_Evaluator>()
      // This primitive is fundamental as it recognizes real numbers from
      // the input. The number is converted once, when the expression is
      // parsed, rather than every time the expression is evaluated. Numbers
      // are always parsed as 'double' so that products and powers of
      // integers don't overflow.
      ..primitive(
        digit()
            .plus()
            .seq(char('.').seq(digit().plus()).optional())
            .flatten()
            .trim()
            .map((value) {
              final number = double.parse(value);
              return (_) => number;
            }),
      )
      // Recognize the 'x' variable
      ..primitive(
        char('x').trim().map(
          (_) =>
              (value) => value,
        ),
      )
      // Constants
      ..primitive(
        char('e').trim().map(
          (_) =>
              (value) => math.e,
        ),
      )
      ..primitive(
        string('pi').trim().map(
          (_) =>
              (value) => math.pi,
        ),
      )
      ..primitive(
        string('sqrt2').trim().map(
          (_) =>
              (value) => math.sqrt2,
        ),
      )
      ..primitive(
        string('sqrt3').trim().map(
          (_) =>
              (value) => _sqrt3,
        ),
      )
      ..primitive(
        string('G').trim().map(
          (_) =>
              (value) => _g,
        ),
      );

    // Enable the parentheses
    builder.group()
      ..wrapper(char('(').trim(), char(')').trim(), (_, a, _) => a)
      // Adding various mathematical operators
      ..wrapper(
        string('sqrt(').trim(),
        char(')').trim(),
        (_, a, _) =>
            (value) => math.sqrt(a(value)),
      )
      ..wrapper(
        string('abs(').trim(),
        char(')').trim(),
        (_, a, _) =>
            (value) => a(value).abs(),
      )
      ..wrapper(
        string('sin(').trim(),
        char(')').trim(),
        (_, a, _) =>
            (value) => math.sin(a(value)),
      )
      ..wrapper(
        string('cos(').trim(),
        char(')').trim(),
        (_, a, _) =>
            (value) => math.cos(a(value)),
      )
      ..wrapper(
        string('tan(').trim(),
        char(')').trim(),
        (_, a, _) =>
            (value) => math.tan(a(value)),
      )
      ..wrapper(
        string('log(').trim(),
        char(')').trim(),
        (_, a, _) =>
            (value) => math.log(a(value)),
      )
      ..wrapper(
        string('acos(').trim(),
        char(')').trim(),
        (_, a, _) =>
            (value) => math.acos(a(value)),
      )
      ..wrapper(
        string('asin(').trim(),
        char(')').trim(),
        (_, a, _) =>
            (value) => math.asin(a(value)),
      )
      ..wrapper(
        string('atan(').trim(),
        char(')').trim(),
        (_, a, _) =>
            (value) => math.atan(a(value)),
      )
      ..wrapper(
        string('csc(').trim(),
        char(')').trim(),
        (_, a, _) =>
            (value) => 1 / math.sin(a(value)),
      )
      ..wrapper(
        string('sec(').trim(),
        char(')').trim(),
        (_, a, _) =>
            (value) => 1 / math.cos(a(value)),
      );

    // Defining operations among operators.
    builder.group().prefix(
      char('-').trim(),
      (_, a) =>
          (value) => -a(value),
    );
    builder.group().right(
      char('^').trim(),
      (a, _, b) =>
          (value) => math.pow(a(value), b(value)).toDouble(),
    );
    builder.group()
      ..left(
        char('*').trim(),
        (a, _, b) =>
            (value) => a(value) * b(value),
      )
      ..left(
        char('/').trim(),
        (a, _, b) =>
            (value) => a(value) / b(value),
      );
    builder.group()
      ..left(
        char('+').trim(),
        (a, _, b) =>
            (value) => a(value) + b(value),
      )
      ..left(
        char('-').trim(),
        (a, _, b) =>
            (value) => a(value) - b(value),
      );

    // Build the parser
    return builder.build().end();
  }();

  /// Evaluates the mathematical [expression] and returns the result. This
  /// method has to be used to evaluate those expressions that do **not**
  /// contain the `x` variable. For example:
  ///
  ///   - `"6 + 10 * 3 / 7"` // Good
  ///   - `"6 + 10 * x / 7"` // Bad
  ///
  /// If you want to evaluate a function with the `x` variable, use [evaluateOn]
  /// instead.
  ///
  /// Throws an [ExpressionParserException] if [expression] is malformed or if
  /// it contains the `x` variable.
  double evaluate(String expression) {
    const message =
        'The given expression cannot be parsed! Make sure that all operators '
        'are supported. Make also sure that the product of two values '
        "explicitly has the '*' symbol.\n\nThere cannot be the 'x' variable in "
        'the expression because this method only evaluates numbers.';

    if (expression.contains('x')) {
      throw const ExpressionParserException(message);
    }

    return _evaluatorOf(expression, message)(0);
  }

  /// Evaluates the mathematical [expression] and replaces the `x` variable with
  /// the value of the given [evaluationPoint].
  ///
  /// If you want to evaluate a simple expression without the `x` variable,
  /// use [evaluate] instead.
  ///
  /// Throws an [ExpressionParserException] if [expression] is malformed.
  double evaluateOn(String expression, double evaluationPoint) {
    const message =
        'The given expression cannot be parsed! Make sure that all operators '
        'are supported. Make also sure that the product of two values '
        "explicitly has the '*' symbol.";

    return _evaluatorOf(expression, message)(evaluationPoint);
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
  ///
  /// A valid expression is cached, so evaluating it later with
  /// [ExpressionParser] doesn't parse it again.
  bool get isRealFunction => ExpressionParser._tryEvaluatorOf(this) != null;

  /// Determines whether this string represents a valid numerical expression
  /// such as:
  ///
  ///   - `"3.8 / 2"`
  ///   - `"cos(pi) - 18 * 6"`
  ///
  /// The `x` variable is **not** valid because this getter only considers
  /// numerical values.
  ///
  /// A valid expression is cached, so evaluating it later with
  /// [ExpressionParser] doesn't parse it again.
  bool get isNumericalExpression =>
      !contains('x') && ExpressionParser._tryEvaluatorOf(this) != null;
}
