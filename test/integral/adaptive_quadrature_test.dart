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

  group('AdaptiveQuadrature.', () {
    test('Integration of sin(x)-3 on [2, -3].', () {
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

    test('Object comparison.', () {
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
  });
}
