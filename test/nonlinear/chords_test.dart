import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'Chords' class", () {
    test(
        "Making sure that the series converges when the root is in the interval.",
        () async {
      final chords =
          Chords(function: "cos(x) - x^2", a: 0.5, b: 1, maxSteps: 4);

      expect(chords.maxSteps, equals(4));
      expect(chords.tolerance, equals(1.0e-10));
      expect(chords.function, equals("cos(x) - x^2"));
      expect(chords.toString(), equals("f(x) = cos(x) - x^2"));
      expect(chords.a, equals(0.5));
      expect(chords.b, equals(1));

      // Solving the equation, making sure that the series converged
      /*final solutions = await chords.solve();
      expect(solutions.guesses.length <= 4, isTrue);
      expect(solutions.guesses.length, isNonZero);
      expect(solutions.convergence, 1);
      expect(solutions.efficiency, 1);

      // There must be some values starting with 1.5xxx which is the root we're
      // looking for in this test
      expect(solutions.guesses.last, MoreOrLessEquals(0.824, precision: 1.0e-3));*/
    });

    /*test("Making sure that a malformed equation string throws.", () async {
      expect(() => Chords(
        function: "cosx - x^2",
          a: 0.5,
          b: 1,
        ),
        throwsA(isA<FormatException>())
      );
    });*/

    test("Making sure that object comparison properly works", () {
      final chords = Chords(
        function: "x^2-2",
        a: 1,
        b: 2,
      );

      expect(Chords(function: "x^2-2", a: 1, b: 2), equals(chords));
      expect(Chords(function: "x^2-2", a: 0, b: 2) == chords, isTrue);
      expect(Chords(function: "x^2-2", a: 0, b: 2).hashCode,
          equals(chords.hashCode));
    });

    /*test(
        "Making sure that the chords method still works when the root is "
        "not in the interval but the actual solution is not found", () async {
      final chords = Chords(function: "x^2-2", a: 10, b: 20);
      final solutions = await chords.solve();

      // There must not be some values starting with 1.5xxx, which is the root
      // we're looking for in this test, because the root is far from the range.
      //
      // The range is far from the root: the method still works but it won't find
      // the root.
      expect(solutions.guesses.last, MoreOrLessEquals(0.824, precision: 1.0e-3));
    });*/
  });
}
