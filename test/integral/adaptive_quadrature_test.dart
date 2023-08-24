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

  group('Testing the behaviors of the AdaptiveQuadrature class.', () {
    test("Making sure that a 'AdaptiveQuadrature' works properly.", () {
      expect(quadrature.lowerBound, equals(2));
      expect(quadrature.upperBound, equals(-3));
      expect(quadrature.function, equals('sin(x)-3'));

      // Actual approximation
      final results = quadrature.integrate();

      expect(results.result, const MoreOrLessEquals(15.5, precision: 1.0e-1));
      expect(results.guesses.length, greaterThan(0));
    });

    test("Making sure that AdaptiveQuadrature's toString() method works.", () {
      const strResult = 'sin(x)-3 on [2.00, -3.00]';
      expect(quadrature.toString(), equals(strResult));
    });

    test('Making sure that MidpointRule can be properly compared.', () {
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

    test('Batch tests', () {
      final equations = [
        'cos(x)-x^2',
        'e^(x-1)/(x^2+3*x-8)',
        'sin(x+2)*(x-1)+sqrt(x)',
        'abs(x-2)*e^x',
        'log(x+sqrt(x))',
      ];

      final solution = <List<double>>[
        [2, 3, -7.101],
        [4, 5.25, 1.769],
        [3, 4, 0.235],
        [-2, 0, 2.323],
        [1, 1.25, 0.195],
      ];

      for (var i = 0; i < equations.length; ++i) {
        final result = AdaptiveQuadrature(
          function: equations[i],
          lowerBound: solution[i].first,
          upperBound: solution[i][1],
        ).integrate();

        expect(
          result.result,
          MoreOrLessEquals(solution[i][2], precision: 1.0e-3),
        );
      }
    });
  });
}
