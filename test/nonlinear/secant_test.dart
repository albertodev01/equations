import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'Secant' class", () {
    test(
        "Making sure that the series converges when the root is in the interval.",
        () {
      const secant = Secant(
          function: "x^3-x-2", firstGuess: 1, secondGuess: 2, maxSteps: 10);

      expect(secant.maxSteps, equals(10));
      expect(secant.tolerance, equals(1.0e-10));
      expect(secant.function, equals("x^3-x-2"));
      expect(secant.toString(), equals("f(x) = x^3-x-2"));
      expect(secant.firstGuess, equals(1));
      expect(secant.secondGuess, equals(2));

      // Solving the equation, making sure that the series converged
      final solutions = secant.solve();
      expect(solutions.guesses.length <= 10, isTrue);
      expect(solutions.guesses.length, isNonZero);
      expect(solutions.convergence, MoreOrLessEquals(1.61, precision: 1.0e-2));
      expect(solutions.efficiency, MoreOrLessEquals(1.04, precision: 1.0e-2));

      expect(solutions.guesses.last, MoreOrLessEquals(1.5, precision: 1.0e-1));
    });

    test("Making sure that a malformed equation string throws.", () {
      expect(() {
        Secant(function: "xsin(x)", firstGuess: 0, secondGuess: 2).solve();
      }, throwsA(isA<ExpressionParserException>()));
    });

    test("Making sure that object comparison properly works", () {
      const secant = Secant(
        function: "x-2",
        firstGuess: -1,
        secondGuess: 2,
      );

      expect(Secant(function: "x-2", firstGuess: 1, secondGuess: 2),
          equals(secant));
      expect(Secant(function: "x-2", firstGuess: 0, secondGuess: 2) == secant,
          isTrue);
      expect(Secant(function: "x-2", firstGuess: 0, secondGuess: 2).hashCode,
          equals(secant.hashCode));
    });

    test("Making sure that derivatives evaluated on 0 return NaN.", () {
      const secant = Secant(function: "x", firstGuess: 0, secondGuess: 0);

      // The derivative on 0 is 'NaN'
      expect(secant.evaluateDerivativeOn(0).isNaN, isTrue);

      // Making sure that the method actually throws
      expect(() async => secant.solve(), throwsA(isA<Exception>()));

      // Checking the error message
      try {
        secant.solve();
      } on NonlinearException catch (e) {
        expect(e.message, contains("Invalid denominator encountered."));
      }
    });

    test(
        "Making sure that the secant method still works when the root is "
        "not in the interval but the actual solution is not found", () {
      const secant = Secant(
          function: "x^2-8", firstGuess: -180, secondGuess: -190, maxSteps: 4);
      final solutions = secant.solve();

      expect(solutions.guesses.length, isNonZero);
      expect(solutions.guesses.length <= 4, isTrue);
    });
  });
}
