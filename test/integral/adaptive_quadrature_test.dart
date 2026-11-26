import 'dart:math' as math;

import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  late final AdaptiveQuadrature quadrature;

  setUpAll(() {
    quadrature = const AdaptiveQuadrature(
      function: 'sin(x)-3',
      lowerBound: 2,
      upperBound: -3,
    );
  });

  group('AdaptiveQuadrature', () {
    test('Smoke test', () {
      expect(quadrature.lowerBound, equals(2));
      expect(quadrature.upperBound, equals(-3));
      expect(quadrature.function, equals('sin(x)-3'));

      // Actual approximation
      final results = quadrature.integrate();

      expect(results.result, const MoreOrLessEquals(15.5, precision: 1.0e-1));
      expect(results.guesses.length, greaterThan(0));
    });

    test('toString()', () {
      const strResult = 'sin(x)-3 on [2.00, -3.00]';
      expect(quadrature.toString(), equals(strResult));
    });

    test('Object comparison', () {
      const quadrature2 = AdaptiveQuadrature(
        function: 'sin(x)-3',
        lowerBound: 2,
        upperBound: -3,
      );

      expect(quadrature == quadrature2, isTrue);
      expect(quadrature2 == quadrature, isTrue);
      expect(quadrature, equals(quadrature2));
      expect(quadrature2, equals(quadrature));
      expect(quadrature.hashCode, equals(quadrature2.hashCode));

      expect(
        quadrature ==
            const AdaptiveQuadrature(
              function: 'sin(x)-3',
              lowerBound: 2,
              upperBound: -3,
            ),
        isTrue,
      );

      expect(
        const AdaptiveQuadrature(
              function: 'sin(x)-3',
              lowerBound: 2,
              upperBound: -3,
            ) ==
            quadrature,
        isTrue,
      );

      expect(
        quadrature ==
            const AdaptiveQuadrature(
              function: 'sin(x)-3',
              lowerBound: 0,
              upperBound: -3,
            ),
        isFalse,
      );

      expect(
        quadrature ==
            const AdaptiveQuadrature(
              function: 'sin(x)-3',
              lowerBound: 2,
              upperBound: 0,
            ),
        isFalse,
      );

      expect(
        quadrature ==
            const AdaptiveQuadrature(
              function: 'sin(x)-3.1',
              lowerBound: 2,
              upperBound: -3,
            ),
        isFalse,
      );
    });

    group('Solutions tests', () {
      void verifyAdaptiveQuadrature(
        String function,
        double lowerBound,
        double upperBound,
        double expectedResult,
      ) {
        final result = AdaptiveQuadrature(
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
        verifyAdaptiveQuadrature('cos(x)-x^2', 2, 3, -7.101);
      });

      test('Test 2', () {
        verifyAdaptiveQuadrature('e^(x-1)/(x^2+3*x-8)', 4, 5.25, 1.769);
      });

      test('Test 3', () {
        verifyAdaptiveQuadrature('sin(x+2)*(x-1)+sqrt(x)', 3, 4, 0.235);
      });

      test('Test 4', () {
        verifyAdaptiveQuadrature('abs(x-2)*e^x', -2, 0, 2.323);
      });

      test('Test 5', () {
        verifyAdaptiveQuadrature('log(x+sqrt(x))', 1, 1.25, 0.195);
      });

      test('Test 6', () {
        verifyAdaptiveQuadrature('x', 1, 2, 1.5);
      });

      test('Test 7', () {
        verifyAdaptiveQuadrature('0', -1, 1, 0);
      });
    });

    test('Throws on non-finite function', () {
      // 1/sqrt(x) is infinite at the lower bound
      expect(
        () => const AdaptiveQuadrature(
          function: '1/sqrt(x)',
          lowerBound: 0,
          upperBound: 1,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );

      // sqrt(x) is NaN on the whole interval
      expect(
        () => const AdaptiveQuadrature(
          function: 'sqrt(x)',
          lowerBound: -2,
          upperBound: -1,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
    });

    test('Throws when the function is not finite inside a subinterval', () {
      // The function is finite at the initial partition points, but NaN on
      // (0.035, 0.055), which contains the midpoint of the first subinterval
      expect(
        () => const AdaptiveQuadrature(
          function: 'sqrt((x-0.045)^2-0.0001)',
          lowerBound: 0,
          upperBound: 1,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );

      // Every value is finite, but the Simpson sums overflow
      expect(
        () => const AdaptiveQuadrature(
          function: '10^308',
          lowerBound: 0,
          upperBound: 1,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
    });

    test('Throws on non-convergence', () {
      // 1/x is never evaluated at 0, but it isn't integrable around it
      expect(
        () => const AdaptiveQuadrature(
          function: '1/x',
          lowerBound: -1,
          upperBound: 2,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
    });

    test('Guesses add up to the result', () {
      final results = const AdaptiveQuadrature(
        function: 'sin(x)*e^x',
        lowerBound: 2,
        upperBound: 4,
      ).integrate();

      expect(
        results.guesses.fold<double>(0, (sum, value) => sum + value),
        MoreOrLessEquals(results.result),
      );
    });

    test('Throws on non-finite bounds', () {
      expect(
        () => const AdaptiveQuadrature(
          function: 'x',
          lowerBound: 0,
          upperBound: double.infinity,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
      expect(
        () => const AdaptiveQuadrature(
          function: 'x',
          lowerBound: double.negativeInfinity,
          upperBound: 1,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
      expect(
        () => const AdaptiveQuadrature(
          function: 'x',
          lowerBound: double.nan,
          upperBound: 1,
        ).integrate(),
        throwsA(isA<NumericalIntegrationException>()),
      );
    });

    test('Zero-width interval', () {
      final results = const AdaptiveQuadrature(
        function: '1/x',
        lowerBound: 0,
        upperBound: 0,
      ).integrate();

      expect(results.result, isZero);
      expect(results.guesses, isEmpty);
    });

    group('Regression tests', () {
      void verifyRelative(String function, double a, double b, double exact) {
        final result = AdaptiveQuadrature(
          function: function,
          lowerBound: a,
          upperBound: b,
        ).integrate().result;

        expect(result, closeTo(exact, exact.abs() * 1.0e-10));
      }

      test('Zero at evenly spaced points', () {
        // sin(x)^2 is zero at 0, pi, 2*pi, 3*pi and 4*pi
        verifyRelative('sin(x)^2', 0, 4 * math.pi, 2 * math.pi);

        // The polynomial is zero at 0, 1, 2, 3 and 4
        verifyRelative(
          '(x*(x-1)*(x-2)*(x-3)*(x-4))^2',
          0,
          4,
          10240 / 693,
        );
      });

      test('Large values', () {
        verifyRelative('x^12', 0, 20, math.pow(20.0, 13) / 13);
        verifyRelative('x^16', 0, 20, math.pow(20.0, 17) / 17);
        verifyRelative('x^20', 0, 20, math.pow(20.0, 21) / 21);
      });

      test('Small values', () {
        verifyRelative(
          '0.000000000001*sin(x)',
          0,
          3,
          1.0e-12 * (1 - math.cos(3)),
        );
      });

      test('Jump discontinuity', () {
        verifyRelative('abs(x)/x', -1, 2, 1);
      });

      test('Reversed bounds', () {
        verifyRelative('x^4', 1, -1, -0.4);
      });
    });
  });
}
