import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../../double_approximation_matcher.dart';

void main() {
  late final TrapezoidalRule trapezoid;

  setUpAll(() {
    trapezoid = const TrapezoidalRule(
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
      final results = trapezoid.integrate('x^3+2*x');

      expect(results.result, const MoreOrLessEquals(28, precision: 1.0e-0));
      expect(results.guesses.length, equals(trapezoid.intervals));
    });

    test("Making sure that TrapezoidalRule's toString() method works.", () {
      const strResult = '[1.00, 3.00] with 20 intervals';
      expect(trapezoid.toString(), equals(strResult));
    });

    test('Making sure that TrapezoidalRule can be properly compared.', () {
      const trapezoid2 = TrapezoidalRule(
        lowerBound: 1,
        upperBound: 3,
      );

      expect(trapezoid == trapezoid2, isTrue);
      expect(trapezoid.hashCode, equals(trapezoid2.hashCode));

      expect(
          trapezoid ==
              const TrapezoidalRule(
                lowerBound: 1,
                upperBound: 3,
              ),
          isTrue);
    });

    test(
        'Making sure that the TrapezoidalRule can properly be used along '
        "with a 'Nonlinear' instance", () {
      // The type doesn't actually matter, 'Bisection' has been chosen randomly
      // because any 'Nonlinear' instance shares the SAME implementation of the
      // 'integrateOn' method.
      const bisection = Bisection(function: 'x^3+2*x-1.2', a: 0, b: 3);

      // Evaluation
      final integral = bisection.integrateOn(const TrapezoidalRule(
        lowerBound: 0,
        upperBound: 3,
        intervals: 40,
      ));

      expect(integral.result.truncate(), equals(25));
    });
  });
}
