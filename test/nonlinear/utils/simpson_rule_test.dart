import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  late final SimpsonRule simpson;

  setUpAll(() {
    simpson = const SimpsonRule(
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
      final results = simpson.integrate('sin(x)*e^x');

      expect(results.result, const MoreOrLessEquals(-7.713, precision: 1.0e-4));
      expect(results.guesses.length, equals(simpson.intervals));
    });

    test("Making sure that SimpsonRule's toString() method works.", () {
      const strResult = '[2.00, 4.00] with 32 intervals';
      expect(simpson.toString(), equals(strResult));
    });

    test('Making sure that SimpsonRule can be properly compared.', () {
      const simpson2 = SimpsonRule(
        lowerBound: 2,
        upperBound: 4,
      );

      expect(simpson == simpson2, isTrue);
      expect(simpson.hashCode, equals(simpson2.hashCode));

      expect(
        simpson ==
            const SimpsonRule(
              lowerBound: 2,
              upperBound: 4,
            ),
        isTrue,
      );
    });

    test(
        'Making sure that the SimpsonRule can properly be used along '
        "with a 'Nonlinear' instance", () {
      // The type doesn't actually matter, 'Bisection' has been chosen randomly
      // because any 'Nonlinear' instance shares the SAME implementation of the
      // 'integrateOn' method.
      const bisection = Bisection(function: 'x^3+2*x-1.2', a: 0, b: 3);

      // Evaluation
      final integral = bisection.integrateOn(const SimpsonRule(
        lowerBound: 0,
        upperBound: 3,
        intervals: 40,
      ));

      expect(integral.result.truncate(), equals(25));
    });
  });
}
