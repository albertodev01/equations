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

  });
}