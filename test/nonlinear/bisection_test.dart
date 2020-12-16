import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'Bisection' class", () {
    test(
        "Making sure that the series converges when the root is in the interval.",
        () async {
      const bisection = Bisection(function: "x^3-x-2", a: 1, b: 2, maxSteps: 5);

      expect(bisection.maxSteps, equals(5));
      expect(bisection.tolerance, equals(1.0e-10));
      expect(bisection.function, equals("x^3-x-2"));
      expect(bisection.toString(), equals("f(x) = x^3-x-2"));
      expect(bisection.a, equals(1));
      expect(bisection.b, equals(2));

      // Solving the equation, making sure that the series converged
      final solutions = await bisection.solve();
      expect(solutions.guesses.length <= 5, isTrue);
      expect(solutions.guesses.length, isNonZero);
      expect(solutions.convergence, MoreOrLessEquals(1, precision: 1));
      expect(solutions.efficiency, MoreOrLessEquals(1, precision: 1));

      expect(solutions.guesses.last, MoreOrLessEquals(1.5, precision: 1.0e-1));
    });

    test("Making sure that a malformed equation string throws.", () {
      expect(() async {
        await Bisection(function: "2x - 6", a: 1, b: 8).solve();
      }, throwsA(isA<ExpressionParserException>()));
    });

    test("Making sure that object comparison properly works", () {
      final bisection = Bisection(
        function: "x-2",
        a: 1,
        b: 2,
      );

      expect(Bisection(function: "x-2", a: 1, b: 2), equals(bisection));
      expect(Bisection(function: "x-2", a: 0, b: 2) == bisection, isTrue);
      expect(Bisection(function: "x-2", a: 0, b: 2).hashCode,
          equals(bisection.hashCode));
    });

    test(
        "Making sure that the bisection method still works when the root is "
        "not in the interval but the actual solution is not found", () async {
      const bisection =
          Bisection(function: "x^2 - 9", a: -120, b: -122, maxSteps: 5);
      final solutions = await bisection.solve();

      expect(solutions.guesses.length, isNonZero);
      expect(solutions.guesses.length <= 5, isTrue);
    });
  });
}
