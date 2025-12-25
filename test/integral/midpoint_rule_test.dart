import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  late final MidpointRule midpoint;

  setUpAll(() {
    midpoint = const MidpointRule(
      function: 'sin(x)-3',
      lowerBound: 2,
      upperBound: -3,
    );
  });

  group('MidpointRule.', () {
    test('Smoke test', () {
      expect(midpoint.lowerBound, equals(2));
      expect(midpoint.upperBound, equals(-3));
      expect(midpoint.intervals, equals(30));

      // Actual approximation
      final results = midpoint.integrate();

      expect(results.result, const MoreOrLessEquals(15.5, precision: 1.0e-1));
      expect(results.guesses.length, equals(midpoint.intervals));
    });

    test('toString()', () {
      const strResult = 'sin(x)-3 on [2.00, -3.00]\nUsing 30 intervals';
      expect(midpoint.toString(), equals(strResult));
    });

    test('Making sure that MidpointRule can be properly compared.', () {
      const midpoint2 = MidpointRule(
        function: 'sin(x)-3',
        lowerBound: 2,
        upperBound: -3,
      );

      expect(midpoint == midpoint2, isTrue);
      expect(midpoint2 == midpoint, isTrue);
      expect(midpoint, equals(midpoint2));
      expect(midpoint2, equals(midpoint));
      expect(midpoint.hashCode, equals(midpoint2.hashCode));

      expect(
        midpoint ==
            const MidpointRule(
              function: 'sin(x)-3',
              lowerBound: 2,
              upperBound: -3,
            ),
        isTrue,
      );

      expect(
        const MidpointRule(
              function: 'sin(x)-3',
              lowerBound: 2,
              upperBound: -3,
            ) ==
            midpoint,
        isTrue,
      );

      expect(
        midpoint ==
            const MidpointRule(
              function: 'sin(x)-3',
              lowerBound: 0,
              upperBound: -3,
            ),
        isFalse,
      );

      expect(
        midpoint ==
            const MidpointRule(
              function: 'sin(x)-3',
              lowerBound: 2,
              upperBound: 0,
            ),
        isFalse,
      );

      expect(
        midpoint ==
            const MidpointRule(
              function: 'sin(x)-3',
              lowerBound: 2,
              upperBound: -3,
              intervals: 0,
            ),
        isFalse,
      );
    });

    group('Solutions tests', () {
      void verifyMidpointRule(
        String function,
        double lowerBound,
        double upperBound,
        double expectedResult,
      ) {
        final result = MidpointRule(
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
        verifyMidpointRule('cos(x)-x^2', 2, 3, -7.101);
      });

      test('Test 2', () {
        verifyMidpointRule('e^(x-1)/(x^2+3*x-8)', 4, 5.25, 1.769);
      });

      test('Test 3', () {
        verifyMidpointRule('sin(x+2)*(x-1)+sqrt(x)', 3, 4, 0.235);
      });

      test('Test 4', () {
        verifyMidpointRule('abs(x-2)*e^x', -2, 0, 2.323);
      });

      test('Test 5', () {
        verifyMidpointRule('log(x+sqrt(x))', 1, 1.25, 0.195);
      });

      test('Test 6', () {
        verifyMidpointRule('x', 1, 2, 1.5);
      });

      test('Test 7', () {
        verifyMidpointRule('0', -1, 1, 0);
      });
    });
  });
}
