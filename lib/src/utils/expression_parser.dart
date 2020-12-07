import 'dart:math' as math;

import 'package:petitparser/petitparser.dart';

/// Parses mathematical expressions with support for variables.
class ExpressionParser {
  /// Builds a new expression parser accepting strings with a single `x` variable.
  /// For example, valid expressions are:
  ///
  ///   - `2 + x`
  ///   - `3 * x - 6`
  ///   - `x^2 + cos(x / 2)`
  const ExpressionParser();

  /// Evaluates the parsed expression using the given [value].
  num evaluate(String expression, double value) {
    final builder = ExpressionBuilder();

    // Definition of operator groups. This defines how numbers are parsed and how
    // variables are recognized.
    builder.group()
      ..primitive(digit()
          .plus()
          .seq(char('.').seq(digit().plus()).optional())
          .flatten()
          .trim()
          .map(num.tryParse))
      ..primitive(char('x').map((value) => 2))
      ..primitive(char('e').map((value) => math.e))
      ..primitive(string('pi').map((value) => math.pi))
      ..wrapper(char('(').trim(), char(')').trim(), (_, num a, __) => a)
      ..wrapper(string('sqrt(').trim(), char(')').trim(),
          (_, num a, __) => math.sqrt(a))
      ..wrapper(string('sin(').trim(), char(')').trim(),
          (_, num a, __) => math.sin(a))
      ..wrapper(string('cos(').trim(), char(')').trim(),
          (_, num a, __) => math.cos(a))
      ..wrapper(string('exp(').trim(), char(')').trim(),
          (_, num a, __) => math.exp(a))
      ..wrapper(string('log(').trim(), char(')').trim(),
          (_, num a, __) => math.log(a))
      ..wrapper(string('acos(').trim(), char(')').trim(),
          (_, num a, __) => math.acos(a))
      ..wrapper(string('asin(').trim(), char(')').trim(),
          (_, num a, __) => math.asin(a))
      ..wrapper(string('atan(').trim(), char(')').trim(),
          (_, num a, __) => math.atan(a));

    // Defining operations among operators.
    builder.group()..prefix(char('-').trim(), (String op, num a) => -a);
    builder.group()
      ..right(char('^').trim(), (num a, String op, num b) => math.pow(a, b));

    // multiplication and addition are left-associative
    builder.group()
      ..left(char('*').trim(), (num a, String op, num b) => a * b)
      ..left(char('/').trim(), (num a, String op, num b) => a / b);
    builder.group()
      ..left(char('+').trim(), (num a, String op, num b) => a + b)
      ..left(char('-').trim(), (num a, String op, num b) => a - b);

    return builder.build().end().parse(expression).value as num;
  }
}
