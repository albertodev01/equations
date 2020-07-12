import 'package:equations/src/nonlinear/steffensen.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'Steffensen method'", () {
    test("Testing a valid equation", () async {
      final steffensen = Steffensen("2*x+cos(x)", -1, maxSteps: 5);

      expect(steffensen.maxSteps, 5);
      expect(steffensen.tolerance, 1.0e-10);
      expect(steffensen.function, "2*x+cos(x)");
      expect(steffensen.x0, -1);

      final solutions = await steffensen.solve();
      expect(solutions.guesses.length > 0, true);

      // Newton is known to have a quadratic convergence so the value should
      // always be close to 2
      expect(solutions.convergence.round(), 2);
      expect(solutions.efficiency.round(), 1);

      expect(solutions.guesses.last.toStringAsFixed(2).contains("-0.45"), true);
    });

    test("Testing an invalid equation", () async {
      expect(() => Steffensen("2x+cos(x)", 1), throwsA(isA<FormatException>()));
    });

    test("Testing an equation with a root too far from the guess", () async {
      final steffensen = Steffensen("2*x+cos(x)", 130);
      final solutions = await steffensen.solve();

      // There must not be some values starting with 1.5xxx, which is the root
      // we're looking for in this test, because the root is far from the range.
      //
      // The range is far from the root: the method still works but it won't find
      // the root.
      expect(solutions.guesses.last.toStringAsFixed(1).contains("1.5"), false);
    });
  });
}
