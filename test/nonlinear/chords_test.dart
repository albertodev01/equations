import 'package:equations/src/nonlinear/chords.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'Chords method'", () {
    test("Testing a valid equation", () async {
      final chords = Chords("x^3-x-2", 1, 2, maxSteps: 5);

      expect(chords.maxSteps, 5);
      expect(chords.tolerance, 1.0e-10);
      expect(chords.function, "x^3-x-2");
      expect(chords.a, 1);
      expect(chords.b, 2);

      final solutions = await chords.solve();
      expect(solutions.guesses.length > 0, true);

      expect(solutions.convergence.round(), 1);
      expect(solutions.efficiency.round(), 1);

      // There must be some values starting with 1.5xxx which is the root we're
      // looking for in this test
      expect(solutions.guesses.last.toStringAsFixed(1).contains("1.5"), true);
    });

    test("Testing an invalid equation", () async {
      expect(() => Chords("2x2", 1, 3), throwsA(isA<FormatException>()));
    });

    test("Testing an equation with no roots in the given interval", () async {
      final chords = Chords("x^3-x-2", -120, -122, maxSteps: 5);
      final solutions = await chords.solve();

      // There must not be some values starting with 1.5xxx, which is the root
      // we're looking for in this test, because the root is far from the range.
      //
      // The range is far from the root: the method still works but it won't find
      // the root.
      expect(solutions.guesses.last.toStringAsFixed(1).contains("1.5"), false);
    });
  });
}
