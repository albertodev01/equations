import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  late final TrapezoidalRule trapezoid;

  setUpAll(() {
    trapezoid = TrapezoidalRule(
      lowerBound: 1,
      upperBound: 3,
      function: "x^3+2*x",
    );
  });

  group("Testing the behaviors of the TrapezoidalRule class.", () {
    test(("Making sure that a 'TrapezoidalRule' works properly."), () {
      expect(trapezoid.lowerBound, equals(1));
      expect(trapezoid.upperBound, equals(3));
      expect(trapezoid.function, equals("x^3+2*x"));
      expect(trapezoid.intervals, equals(20));

      // Actual approximation
      final results = trapezoid.integrate();

      expect(results.result, MoreOrLessEquals(28, precision: 1.0e-0));
      expect(results.guesses.length, equals(trapezoid.intervals));
    });

    test("Making sure that TrapezoidalRule's toString() method works.", () {
      final strResult = "[1.00, 3.00] ∫ x^3+2*x dx";
      expect(trapezoid.toString(), equals(strResult));
    });

    test("Making sure that TrapezoidalRule can be properly compared.", () {
      const trapezoid2 = TrapezoidalRule(
        lowerBound: 1,
        upperBound: 3,
        function: "x^3+2*x",
      );

      expect(trapezoid == trapezoid2, isTrue);
      expect(trapezoid.hashCode, equals(trapezoid2.hashCode));

      expect(
          trapezoid ==
              TrapezoidalRule(
                lowerBound: 1,
                upperBound: 3,
                function: "x^3+2*x",
              ),
          isTrue);
    });
  });
}
