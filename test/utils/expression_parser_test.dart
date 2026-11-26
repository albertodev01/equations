import 'dart:math' as math;

import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group('ExpressionParser', () {
    test('Smoke test', () {
      const parser = ExpressionParser();

      expect(parser.evaluate('5*3-4'), equals(11));
      expect(parser.evaluate('3/8 + 2^3'), equals(8.375));
      expect(
        parser.evaluate('-11+3/4-5*1-3/7'),
        const MoreOrLessEquals(-15.678571428, precision: 1.0e-9),
      );

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
        const MoreOrLessEquals(0.8346268416740732, precision: 1.0e-15),
      );
      expect(
        parser.evaluate('sqrt2'),
        const MoreOrLessEquals(1.41421356237, precision: 1.0e-10),
      );
      expect(parser.evaluate('sqrt3'), equals(math.sqrt(3)));
    });

    test('Products and powers of integers do not overflow', () {
      const parser = ExpressionParser();

      expect(parser.evaluate('10^20'), equals(1.0e20));
      expect(parser.evaluate('3000000000*4000000000'), equals(1.2e19));
      expect(parser.evaluateOn('x*10^19', 2), equals(2.0e19));
    });

    test('Negation binds more tightly than the power', () {
      const parser = ExpressionParser();

      expect(parser.evaluate('-2^2'), equals(4));
      expect(parser.evaluate('-(2^2)'), equals(-4));
      expect(parser.evaluate('0 - 2^2'), equals(-4));
      expect(parser.evaluateOn('-x^2', 3), equals(9));
      expect(parser.evaluate('2^-1'), equals(0.5));
      expect(parser.evaluate('2^3^2'), equals(512));
    });

    test(
      'Exception thrown when evaluate has x variable in the string.',
      () {
        const parser = ExpressionParser();

        expect(
          () => parser.evaluate('5*x*3-4'),
          throwsA(isA<ExpressionParserException>()),
        );
        expect(
          () => parser.evaluate('x-3'),
          throwsA(isA<ExpressionParserException>()),
        );
      },
    );

    test('Smoke test - functions', () {
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
        parser.evaluate('sec(pi)'),
        const MoreOrLessEquals(-1, precision: 1.0e-1),
      );
      expect(
        parser.evaluate('csc(pi/2)'),
        const MoreOrLessEquals(1, precision: 1.0e-1),
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
      'Smoke test - x variable',
      () {
        const parser = ExpressionParser();

        expect(parser.evaluateOn('6*x + 4', 3), equals(22));
        expect(parser.evaluateOn('sqrt(x) - 3', 81), equals(6));
      },
    );

    test(
      'Smoke test - x variable even if not present',
      () {
        expect(const ExpressionParser().evaluateOn('6*3 + 4', 0), equals(22));
      },
    );

    test('String extension method works correctly.', () {
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
      expect(''.isNumericalExpression, isFalse);
      expect('sqrt(x'.isRealFunction, isFalse);
    });

    test('Validity checks agree with evaluation', () {
      const parser = ExpressionParser();
      for (var i = 0; i < 2; ++i) {
        expect('x^2 + abs(x)'.isRealFunction, isTrue);
        expect(parser.evaluateOn('x^2 + abs(x)', -3), equals(12));
        expect('2*x+'.isRealFunction, isFalse);
        expect(
          () => parser.evaluateOn('2*x+', 1),
          throwsA(isA<ExpressionParserException>()),
        );
      }
    });

    test('Evaluates correctly more expressions than the cache size', () {
      const parser = ExpressionParser();
      final expressions = List<String>.generate(200, (i) => 'x+$i');

      for (final (i, expression) in expressions.indexed) {
        expect(parser.evaluateOn(expression, 1), equals(i + 1));
      }

      // Evaluating the same expressions again, in reverse order, still works
      for (final (i, expression) in expressions.indexed.toList().reversed) {
        expect(parser.evaluateOn(expression, 2), equals(i + 2));
      }
    });

    test('Invalid expressions throw on every evaluation', () {
      const parser = ExpressionParser();

      for (var i = 0; i < 3; ++i) {
        expect(
          () => parser.evaluateOn('2x', 1),
          throwsA(isA<ExpressionParserException>()),
        );
        expect(
          () => parser.evaluate('x+1'),
          throwsA(isA<ExpressionParserException>()),
        );
      }
    });
  });
}
