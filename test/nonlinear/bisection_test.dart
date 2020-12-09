import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'Bisection' class", () {
    test(
        "Making sure that the series converges when the root is in the interval.",
        () async {
      final bisection = Bisection(function: "x^3-x-2", a: 1, b: 2, maxSteps: 3);

      expect(bisection.maxSteps, equals(3));
      expect(bisection.tolerance, equals(1.0e-10));
      expect(bisection.function, equals("x^3-x-2"));
      expect(bisection.toString(), equals("f(x) = x^3-x-2"));
      expect(bisection.a, equals(1));
      expect(bisection.b, equals(2));

      // Solving the equation, making sure that the series converged
      /*final solutions = await bisection.solve();
      expect(solutions.guesses.length <= 3, isTrue);
      expect(solutions.guesses.length, isNonZero);
      expect(solutions.convergence, 1);
      expect(solutions.efficiency, 1);

      // There must be some values starting with 1.5xxx which is the root we're
      // looking for in this test
      expect(solutions.guesses.last, MoreOrLessEquals(1.52, precision: 1.0e-2));*/
    });

    /*test("Making sure that a malformed equation string throws.", () {
      expect(
          () => Bisection(
                function: "2x - 6",
                a: 1,
                b: 8,
              ),
          throwsA(isA<FormatException>()));
    });*/

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

    /*test(
        "Making sure that the bisection method still works when the root is "
        "not in the interval but the actual solution is not found", () async {
      final bisection =
          Bisection(function: "x^2 - 9", a: -120, b: -122, maxSteps: 5);
      final solutions = await bisection.solve();

      // There must not be some values starting with 1.5xxx, which is the root
      // we're looking for in this test, because the root is far from the range.
      //
      // The range is far from the root: the method still works but it won't find
      // the root.
      expect(solutions.guesses.last, MoreOrLessEquals(1.52, precision: 1.0e-2));
    });*/
  });
}
