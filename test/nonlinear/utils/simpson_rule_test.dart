import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  late final SimpsonRule simpson;

  setUpAll(() {
    simpson = SimpsonRule(
      lowerBound: 2,
      upperBound: 4,
      function: "sin(x)*e^x",
    );
  });

  group("Testing the behaviors of the SimpsonRule class.", () {
    test(("Making sure that a 'SimpsonRule' works properly."), () {
      expect(simpson.lowerBound, equals(2));
      expect(simpson.upperBound, equals(4));
      expect(simpson.function, equals("sin(x)*e^x"));
      expect(simpson.intervals, equals(32));

      // Actual approximation
      final results = simpson.integrate();

      expect(results.result, MoreOrLessEquals(-7.713, precision: 1.0e-4));
      expect(results.guesses.length, equals(simpson.intervals));
    });

    test("Making sure that SimpsonRule's toString() method works.", () {
      final strResult = "[2.00, 4.00] ∫ sin(x)*e^x dx";
      expect(simpson.toString(), equals(strResult));
    });

    test("Making sure that SimpsonRule can be properly compared.", () {
      const simpson2 = SimpsonRule(
        lowerBound: 2,
        upperBound: 4,
        function: "sin(x)*e^x",
      );

      expect(simpson == simpson2, isTrue);
      expect(simpson.hashCode, equals(simpson2.hashCode));

      expect(
          simpson ==
              SimpsonRule(
                lowerBound: 2,
                upperBound: 4,
                function: "sin(x)*e^x",
              ),
          isTrue);
    });
  });
}
