import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  late final SimpsonRule simpson;

  setUpAll(() {
    simpson = const SimpsonRule(
      function: 'sin(x)*e^x',
      lowerBound: 2,
      upperBound: 4,
    );
  });

  group('SimpsonRule', () {
    test('Smoke test', () {
      expect(simpson.lowerBound, equals(2));
      expect(simpson.upperBound, equals(4));
      expect(simpson.intervals, equals(32));

      // Actual approximation
      final results = simpson.integrate();

      expect(results.result, const MoreOrLessEquals(-7.713, precision: 1.0e-4));
      expect(results.guesses.length, equals(simpson.intervals));
    });

    test('toString()', () {
      const strResult = 'sin(x)*e^x on [2.00, 4.00]\nUsing 32 intervals';
      expect(simpson.toString(), equals(strResult));
    });

    test('Object comparison.', () {
      const simpson2 = SimpsonRule(
        function: 'sin(x)*e^x',
        lowerBound: 2,
        upperBound: 4,
      );

      expect(simpson == simpson2, isTrue);
      expect(simpson2 == simpson, isTrue);
      expect(simpson, equals(simpson2));
      expect(simpson2, equals(simpson));
      expect(simpson.hashCode, equals(simpson2.hashCode));

      expect(
        simpson ==
            const SimpsonRule(
              function: 'sin(x)*e^x',
              lowerBound: 2,
              upperBound: 4,
            ),
        isTrue,
      );

      expect(
        simpson ==
            const SimpsonRule(
              function: 'sin(x)*e^x',
              lowerBound: 0,
              upperBound: 4,
            ),
        isFalse,
      );

      expect(
        simpson ==
            const SimpsonRule(
              function: 'sin(x)*e^x',
              lowerBound: 2,
              upperBound: 0,
            ),
        isFalse,
      );

      expect(
        simpson ==
            const SimpsonRule(
              function: 'sin(x)*e^x',
              lowerBound: 2,
              upperBound: 4,
              intervals: 0,
            ),
        isFalse,
      );
    });

    group('Solutions tests', () {
      void verifySimpsonRule(
        String function,
        double lowerBound,
        double upperBound,
        double expectedResult,
      ) {
        final result = SimpsonRule(
          function: function,
          lowerBound: lowerBound,
          upperBound: upperBound,
          intervals: 60,
        ).integrate();

        expect(
          result.result,
          MoreOrLessEquals(expectedResult, precision: 1.0e-3),
        );
      }

      test('Test 1', () {
        verifySimpsonRule('cos(x)-x^2', 2, 3, -7.101);
      });

      test('Test 2', () {
        verifySimpsonRule('e^(x-1)/(x^2+3*x-8)', 4, 5.25, 1.769);
      });

      test('Test 3', () {
        verifySimpsonRule('sin(x+2)*(x-1)+sqrt(x)', 3, 4, 0.235);
      });

      test('Test 4', () {
        verifySimpsonRule('abs(x-2)*e^x', -2, 0, 2.323);
      });

      test('Test 5', () {
        verifySimpsonRule('log(x+sqrt(x))', 1, 1.25, 0.195);
      });

      test('Test 6', () {
        verifySimpsonRule('x', 1, 2, 1.5);
      });

      test('Test 7', () {
        verifySimpsonRule('0', -1, 1, 0);
      });
    });
  });
}
