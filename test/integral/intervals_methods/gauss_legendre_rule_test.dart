import 'dart:math' as math;

import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  late final GaussLegendreRule gauss;

  setUpAll(() {
    gauss = const GaussLegendreRule(
      function: 'sin(x)*e^x',
      lowerBound: 2,
      upperBound: 4,
    );
  });

  group('GaussLegendreRule', () {
    test('Smoke test', () {
      expect(gauss.lowerBound, equals(2));
      expect(gauss.upperBound, equals(4));
      expect(gauss.intervals, equals(10));
      expect(gauss.points, equals(3));

      // Actual approximation
      final results = gauss.integrate();

      expect(results.result, const MoreOrLessEquals(-7.713, precision: 1.0e-4));
      expect(
        results.guesses.length,
        equals(gauss.intervals * gauss.points),
      );
    });

    test('Guesses values', () {
      const integral = GaussLegendreRule(
        function: 'x',
        lowerBound: 0,
        upperBound: 4,
        intervals: 2,
      );

      // The Gauss points of [0, 2] and [2, 4], in increasing order
      const t = 0.7745966692414834;
      const expected = <double>[1 - t, 1, 1 + t, 3 - t, 3, 3 + t];
      final guesses = integral.integrate().guesses;

      expect(guesses.length, equals(expected.length));
      for (final (i, value) in guesses.indexed) {
        expect(value, MoreOrLessEquals(expected[i]));
      }
    });

    test('Exact up to degree 2k - 1', () {
      // The integral of x^d from -1 to 3 is (3^(d+1) - (-1)^(d+1)) / (d + 1)
      double exact(int d) =>
          (math.pow(3, d + 1) - math.pow(-1, d + 1)) / (d + 1);

      for (var k = 1; k <= 5; ++k) {
        final degree = 2 * k - 1;
        final result = GaussLegendreRule(
          function: 'x^$degree',
          lowerBound: -1,
          upperBound: 3,
          intervals: 1,
          points: k,
        ).integrate().result;

        expect(
          result,
          MoreOrLessEquals(exact(degree), precision: 1.0e-12 * exact(degree)),
        );
      }
    });

    test('One point equals MidpointRule', () {
      final gaussResult = const GaussLegendreRule(
        function: 'sin(x)*e^x',
        lowerBound: 2,
        upperBound: 4,
        intervals: 30,
        points: 1,
      ).integrate().result;
      final midpointResult = const MidpointRule(
        function: 'sin(x)*e^x',
        lowerBound: 2,
        upperBound: 4,
      ).integrate().result;

      expect(gaussResult, MoreOrLessEquals(midpointResult));
    });

    test('Bounds are never evaluated', () {
      // 1/sqrt(x) is infinite at 0, but the integral from 0 to 1 is 2
      final result = const GaussLegendreRule(
        function: '1/sqrt(x)',
        lowerBound: 0,
        upperBound: 1,
        intervals: 1000,
      ).integrate().result;

      expect(result, const MoreOrLessEquals(2, precision: 1.0e-2));
    });

    test('Reversed bounds', () {
      final results = const GaussLegendreRule(
        function: 'e^x',
        lowerBound: 2,
        upperBound: 0,
      ).integrate();

      expect(
        results.result,
        MoreOrLessEquals(1 - math.exp(2), precision: 1.0e-8),
      );
    });

    test('toString()', () {
      const strResult =
          'sin(x)*e^x on [2.00, 4.00]\nUsing 10 intervals with 3 points each';
      expect(gauss.toString(), equals(strResult));
    });

    test('Object comparison', () {
      const gauss2 = GaussLegendreRule(
        function: 'sin(x)*e^x',
        lowerBound: 2,
        upperBound: 4,
      );

      expect(gauss == gauss2, isTrue);
      expect(gauss2 == gauss, isTrue);
      expect(gauss, equals(gauss2));
      expect(gauss.hashCode, equals(gauss2.hashCode));

      expect(
        gauss ==
            const GaussLegendreRule(
              function: 'sin(x)*e^x',
              lowerBound: 2,
              upperBound: 4,
              points: 4,
            ),
        isFalse,
      );

      expect(
        gauss ==
            const GaussLegendreRule(
              function: 'sin(x)*e^x',
              lowerBound: 2,
              upperBound: 4,
              intervals: 4,
            ),
        isFalse,
      );

      expect(
        gauss ==
            const GaussLegendreRule(
              function: 'sin(x)*e^x',
              lowerBound: 0,
              upperBound: 4,
            ),
        isFalse,
      );

      expect(
        gauss ==
            const MidpointRule(
              function: 'sin(x)*e^x',
              lowerBound: 2,
              upperBound: 4,
              intervals: 10,
            ),
        isFalse,
      );
    });

    group('Solutions tests', () {
      void verifyGaussLegendreRule(
        String function,
        double lowerBound,
        double upperBound,
        double expectedResult,
      ) {
        final result = GaussLegendreRule(
          function: function,
          lowerBound: lowerBound,
          upperBound: upperBound,
        ).integrate();

        expect(
          result.result,
          MoreOrLessEquals(expectedResult, precision: 1.0e-3),
        );
      }

      test('Test 1', () {
        verifyGaussLegendreRule('cos(x)-x^2', 2, 3, -7.101);
      });

      test('Test 2', () {
        verifyGaussLegendreRule('e^(x-1)/(x^2+3*x-8)', 4, 5.25, 1.769);
      });

      test('Test 3', () {
        verifyGaussLegendreRule('sin(x+2)*(x-1)+sqrt(x)', 3, 4, 0.235);
      });

      test('Test 4', () {
        verifyGaussLegendreRule('abs(x-2)*e^x', -2, 0, 2.323);
      });

      test('Test 5', () {
        verifyGaussLegendreRule('log(x+sqrt(x))', 1, 1.25, 0.195);
      });

      test('Test 6', () {
        verifyGaussLegendreRule('x', 1, 2, 1.5);
      });

      test('Test 7', () {
        verifyGaussLegendreRule('0', -1, 1, 0);
      });
    });

    test('Throws on invalid intervals or points', () {
      expect(
        () => const GaussLegendreRule(
          function: 'x',
          lowerBound: 0,
          upperBound: 1,
          intervals: 0,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
      expect(
        () => const GaussLegendreRule(
          function: 'x',
          lowerBound: 0,
          upperBound: 1,
          intervals: -4,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
      expect(
        () => const GaussLegendreRule(
          function: 'x',
          lowerBound: 0,
          upperBound: 1,
          points: 0,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
      expect(
        () => const GaussLegendreRule(
          function: 'x',
          lowerBound: 0,
          upperBound: 1,
          points: -1,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
      expect(
        () => const GaussLegendreRule(
          function: 'x',
          lowerBound: 0,
          upperBound: 1,
          points: 6,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
    });

    test('Throws on non-finite bounds', () {
      expect(
        () => const GaussLegendreRule(
          function: 'x',
          lowerBound: 0,
          upperBound: double.infinity,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
      expect(
        () => const GaussLegendreRule(
          function: 'x',
          lowerBound: double.negativeInfinity,
          upperBound: 1,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
      expect(
        () => const GaussLegendreRule(
          function: 'x',
          lowerBound: double.nan,
          upperBound: 1,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
    });
  });
}
