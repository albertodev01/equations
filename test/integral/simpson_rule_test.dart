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

  group('Testing the behaviors of the SimpsonRule class.', () {
    test("Making sure that a 'SimpsonRule' works properly.", () {
      expect(simpson.lowerBound, equals(2));
      expect(simpson.upperBound, equals(4));
      expect(simpson.intervals, equals(32));

      // Actual approximation
      final results = simpson.integrate();

      expect(results.result, const MoreOrLessEquals(-7.713, precision: 1.0e-4));
      expect(results.guesses.length, equals(simpson.intervals));
    });

    test("Making sure that SimpsonRule's toString() method works.", () {
      const strResult = 'sin(x)*e^x on [2.00, 4.00]\nUsing 32 intervals';
      expect(simpson.toString(), equals(strResult));
    });

    test('Making sure that SimpsonRule can be properly compared.', () {
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
        final result = SimpsonRule(
          function: equations[i],
          lowerBound: solution[i].first,
          upperBound: solution[i][1],
          intervals: 60,
        ).integrate();

        expect(
          result.result,
          MoreOrLessEquals(solution[i][2], precision: 1.0e-3),
        );
      }
    });
  });
}
