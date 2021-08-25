import 'dart:math' as math;

import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group('Testing the correctness of exception objects', () {
    test("Making sure that 'ExpressionParser' works with real numbers.", () {
      const parser = ExpressionParser();

      expect(parser.evaluate('5*3-4'), equals(11));
      expect(parser.evaluate('3/8 + 2^3'), equals(8.375));

      expect(
        parser.evaluate('pi'),
        const MoreOrLessEquals(3.1415926535, precision: 1.0e-10),
      );
      expect(
        parser.evaluate('e'),
        const MoreOrLessEquals(2.7182818284, precision: 1.0e-10),
      );
      expect(
        parser.evaluate('G'),
        const MoreOrLessEquals(0.8346268416, precision: 1.0e-10),
      );
    });

    test(
        "Making sure that 'ExpressionParser' throws when 'evaluate' has the "
        "'x' variable in the string.", () {
      const parser = ExpressionParser();

      expect(
        () => parser.evaluate('5*x*3-4'),
        throwsA(isA<ExpressionParserException>()),
      );
      expect(
        () => parser.evaluate('x-3'),
        throwsA(isA<ExpressionParserException>()),
      );
    });

    test("Making sure that 'ExpressionParser' works with functions.", () {
      const parser = ExpressionParser();

      expect(
        parser.evaluate('sqrt(49)'),
        equals(7),
      );
      expect(
        parser.evaluate('abs(-8)'),
        equals(8),
      );
      expect(
        parser.evaluate('abs(8)'),
        equals(8),
      );
      expect(
        parser.evaluate('sin(pi)'),
        const MoreOrLessEquals(0, precision: 1.0e-1),
      );
      expect(
        parser.evaluate('cos(pi)'),
        const MoreOrLessEquals(-1, precision: 1.0e-1),
      );
      expect(
        parser.evaluate('tan(pi/4)'),
        const MoreOrLessEquals(1, precision: 1.0e-1),
      );
      expect(
        parser.evaluate('asin(1)'),
        const MoreOrLessEquals(math.pi / 2, precision: 1.0e-1),
      );
      expect(
        parser.evaluate('acos(1)'),
        const MoreOrLessEquals(0, precision: 1.0e-1),
      );
      expect(
        parser.evaluate('atan(pi)'),
        const MoreOrLessEquals(1.2626, precision: 1.0e-4),
      );
    });

    test(
        "Making sure that 'ExpressionParser' correctly recognizes with the 'x'"
        ' variable.', () {
      const parser = ExpressionParser();

      expect(parser.evaluateOn('6*x + 4', 3), equals(22));
      expect(parser.evaluateOn('sqrt(x) - 3', 81), equals(6));
    });

    test(
        "Making sure that 'ExpressionParser' works with the 'x' variable "
        "even if 'x' is not present.", () {
      expect(const ExpressionParser().evaluateOn('6*3 + 4', 0), equals(22));
    });

    test("Making sure that the 'String' extension method works correctly.", () {
      expect('6*3 + 4'.isRealFunction, isTrue);
      expect('6*3 + 4'.isNumericalExpression, isTrue);
      expect('e*x - pi'.isRealFunction, isTrue);
      expect('e - pi'.isNumericalExpression, isTrue);
      expect('3*e*x/2'.isRealFunction, isTrue);
      expect('1+2+3'.isRealFunction, isTrue);
      expect('cos(pi) - 18 * 6'.isNumericalExpression, isTrue);
      expect('0'.isNumericalExpression, isTrue);
      expect('e^(2 + pi)'.isNumericalExpression, isTrue);

      expect('2x+6'.isRealFunction, isFalse);
      expect(''.isRealFunction, isFalse);
      expect('x'.isNumericalExpression, isFalse);
      expect('2+x'.isNumericalExpression, isFalse);
    });
  });
}
