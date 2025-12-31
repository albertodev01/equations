import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  late final TrapezoidalRule trapezoid;

  setUpAll(() {
    trapezoid = const TrapezoidalRule(
      function: 'x^3+2*x',
      lowerBound: 1,
      upperBound: 3,
    );
  });

  group('TrapezoidalRule.', () {
    test('Smoke test', () {
      expect(trapezoid.lowerBound, equals(1));
      expect(trapezoid.upperBound, equals(3));
      expect(trapezoid.intervals, equals(20));

      // Actual approximation
      final results = trapezoid.integrate();

      expect(results.result, const MoreOrLessEquals(28, precision: 1));
      expect(results.guesses.length, equals(trapezoid.intervals));
    });

    test('toString()', () {
      const strResult = 'x^3+2*x on [1.00, 3.00]\nUsing 20 intervals';
      expect(trapezoid.toString(), equals(strResult));
    });

    test('Making sure that TrapezoidalRule can be properly compared.', () {
      const trapezoid2 = TrapezoidalRule(
        function: 'x^3+2*x',
        lowerBound: 1,
        upperBound: 3,
      );

      expect(trapezoid == trapezoid2, isTrue);
      expect(trapezoid2 == trapezoid, isTrue);
      expect(trapezoid, equals(trapezoid2));
      expect(trapezoid2, equals(trapezoid));
      expect(trapezoid.hashCode, equals(trapezoid2.hashCode));

      expect(
        trapezoid ==
            const TrapezoidalRule(
              function: 'x^3+2*x',
              lowerBound: 1,
              upperBound: 3,
            ),
        isTrue,
      );

      expect(
        trapezoid ==
            const TrapezoidalRule(
              function: 'x^3+2*x',
              lowerBound: 0,
              upperBound: 3,
            ),
        isFalse,
      );

      expect(
        trapezoid ==
            const TrapezoidalRule(
              function: 'x^3+2*x',
              lowerBound: 1,
              upperBound: 0,
            ),
        isFalse,
      );

      expect(
        trapezoid ==
            const TrapezoidalRule(
              function: 'x^3+2*x',
              lowerBound: 1,
              upperBound: 3,
              intervals: 0,
            ),
        isFalse,
      );
    });

    group('Solutions tests', () {
      void verifyTrapezoidalRule(
        String function,
        double lowerBound,
        double upperBound,
        double expectedResult,
      ) {
        final result = TrapezoidalRule(
          function: function,
          lowerBound: lowerBound,
          upperBound: upperBound,
          intervals: 500,
        ).integrate();

        expect(
          result.result,
          MoreOrLessEquals(expectedResult, precision: 1.0e-1),
        );
      }

      test('Test 1', () {
        verifyTrapezoidalRule('cos(x)-x^2', 2, 3, -7.101);
      });

      test('Test 2', () {
        verifyTrapezoidalRule('e^(x-1)/(x^2+3*x-8)', 4, 5.25, 1.769);
      });

      test('Test 3', () {
        verifyTrapezoidalRule('sin(x+2)*(x-1)+sqrt(x)', 3, 4, 0.235);
      });

      test('Test 4', () {
        verifyTrapezoidalRule('abs(x-2)*e^x', -2, 0, 2.323);
      });

      test('Test 5', () {
        verifyTrapezoidalRule('log(x+sqrt(x))', 1, 1.25, 0.195);
      });

      test('Test 6', () {
        verifyTrapezoidalRule('x', 1, 2, 1.5);
      });

      test('Test 7', () {
        verifyTrapezoidalRule('0', -1, 1, 0);
      });
    });
  });
}
