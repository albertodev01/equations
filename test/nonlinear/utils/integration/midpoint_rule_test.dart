import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../../double_approximation_matcher.dart';

void main() {
  late final MidpointRule midpoint;

  setUpAll(() {
    midpoint = const MidpointRule(
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
      final results = midpoint.integrate('sin(x)-3');

      expect(results.result, const MoreOrLessEquals(15.5, precision: 1.0e-1));
      expect(results.guesses.length, equals(midpoint.intervals));
    });

    test("Making sure that MidpointRule's toString() method works.", () {
      const strResult = '[2.00, -3.00] with 30 intervals';
      expect(midpoint.toString(), equals(strResult));
    });

    test('Making sure that MidpointRule can be properly compared.', () {
      const midpoint2 = MidpointRule(
        lowerBound: 2,
        upperBound: -3,
      );

      expect(midpoint == midpoint2, isTrue);
      expect(midpoint.hashCode, equals(midpoint2.hashCode));

      expect(
        midpoint ==
            const MidpointRule(
              lowerBound: 2,
              upperBound: -3,
            ),
        isTrue,
      );

      expect(
        midpoint ==
            const MidpointRule(
              lowerBound: 0,
              upperBound: -3,
            ),
        isFalse,
      );

      expect(
        midpoint ==
            const MidpointRule(
              lowerBound: 2,
              upperBound: 0,
            ),
        isFalse,
      );

      expect(
        midpoint ==
            const MidpointRule(lowerBound: 2, upperBound: -3, intervals: 0),
        isFalse,
      );
    });

    test(
        'Making sure that the MidpointRule can properly be used along '
        "with a 'Nonlinear' instance", () {
      // The type doesn't actually matter, 'Bisection' has been chosen randomly
      // because any 'Nonlinear' instance shares the SAME implementation of the
      // 'integrateOn' method.
      const bisection = Bisection(function: 'sin(2*x)-1/2', a: -1.7, b: -0.5);

      // Evaluation
      final integral = bisection.integrateOn(
        const MidpointRule(
          lowerBound: 0.5,
          upperBound: 1,
          intervals: 40,
        ),
      );

      expect(integral.result, const MoreOrLessEquals(0.22, precision: 1.0e-2));
    });
  });
}
