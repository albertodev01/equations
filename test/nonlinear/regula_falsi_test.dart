import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'RegulaFalsi' class", () {
    test(
        "Making sure that the series converges when the root is in the interval.",
        () {
      const regula = RegulaFalsi(
        function: "x^3-x-2",
        a: 1,
        b: 2,
        maxSteps: 5,
        tolerance: 1.0e-15,
      );

      expect(regula.maxSteps, equals(5));
      expect(regula.tolerance, equals(1.0e-15));
      expect(regula.function, equals("x^3-x-2"));
      expect(regula.toString(), equals("f(x) = x^3-x-2"));
      expect(regula.a, equals(1));
      expect(regula.b, equals(2));

      // Solving the equation, making sure that the series converged
      final solutions = regula.solve();
      expect(solutions.guesses.length <= 5, isTrue);
      expect(solutions.guesses.length, isNonZero);
      expect(solutions.convergence, MoreOrLessEquals(1, precision: 1));
      expect(solutions.efficiency, MoreOrLessEquals(1, precision: 1));

      expect(solutions.guesses.last, MoreOrLessEquals(1.5, precision: 1.0e-1));
    });

    test("Making sure that a malformed equation string throws.", () {
      expect(() {
        RegulaFalsi(function: "3x^2 + 5x - 1", a: 1, b: 8).solve();
      }, throwsA(isA<ExpressionParserException>()));
    });

    test("Making sure that object comparison properly works", () {
      final regula = RegulaFalsi(
        function: "x-2",
        a: 1,
        b: 2,
      );

      expect(RegulaFalsi(function: "x-2", a: 1, b: 2), equals(regula));
      expect(RegulaFalsi(function: "x-2", a: 0, b: 2) == regula, isFalse);
      expect(RegulaFalsi(function: "x-2", a: 1, b: 2).hashCode,
          equals(regula.hashCode));
    });

    test("Making sure that the method throws if the root is not bracketed", () {
      const regula = RegulaFalsi(function: "x - 2", a: 50, b: 70);
      expect(regula.solve, throwsA(isA<NonlinearException>()));
    });
  });
}
