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

  group('Testing the behaviors of the MidpointRule class.', () {
    test("Making sure that a 'MidpointRule' works properly.", () {
      expect(midpoint.lowerBound, equals(2));
      expect(midpoint.upperBound, equals(-3));
      expect(midpoint.intervals, equals(30));

      // Actual approximation
      final results = midpoint.integrate();

      expect(results.result, const MoreOrLessEquals(15.5, precision: 1.0e-1));
      expect(results.guesses.length, equals(midpoint.intervals));
    });

    test("Making sure that MidpointRule's toString() method works.", () {
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
        final result = MidpointRule(
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
