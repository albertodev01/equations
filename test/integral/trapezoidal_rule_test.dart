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

  group('Testing the behaviors of the TrapezoidalRule class.', () {
    test("Making sure that a 'TrapezoidalRule' works properly.", () {
      expect(trapezoid.lowerBound, equals(1));
      expect(trapezoid.upperBound, equals(3));
      expect(trapezoid.intervals, equals(20));

      // Actual approximation
      final results = trapezoid.integrate();

      expect(results.result, const MoreOrLessEquals(28, precision: 1.0e-0));
      expect(results.guesses.length, equals(trapezoid.intervals));
    });

    test("Making sure that TrapezoidalRule's toString() method works.", () {
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
        final result = TrapezoidalRule(
          function: equations[i],
          lowerBound: solution[i].first,
          upperBound: solution[i][1],
          intervals: 500,
        ).integrate();

        expect(
          result.result,
          MoreOrLessEquals(solution[i][2], precision: 1.0e-1),
        );
      }
    });
  });
}
