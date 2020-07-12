import 'package:equations/src/common/exceptions.dart';
import 'package:equations/src/nonlinear/newton.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'Newton method'", () {
    test("Testing a valid equation", () async {
      final newton = Newton("2*x+cos(x)", -1, maxSteps: 5);

      expect(newton.maxSteps, 5);
      expect(newton.tolerance, 1.0e-10);
      expect(newton.function, "2*x+cos(x)");
      expect(newton.x0, -1);

      final solutions = await newton.solve();
      expect(solutions.guesses.length > 0, true);

      // Newton is known to have a quadratic convergence so the value should
      // always be close to 2
      expect(solutions.convergence.round(), 2);
      expect(solutions.efficiency.round(), 1);

      expect(solutions.guesses.last.toStringAsFixed(2).contains("-0.45"), true);
    });

    test("Testing an invalid equation", () async {
      expect(() => Newton("2x+cos(x)", 1), throwsA(isA<FormatException>()));
    });

    test("Testing an equation with a root too far from the guess", () async {
      final newton = Newton("2*x+cos(x)", 130);
      final solutions = await newton.solve();

      // There must not be some values starting with 1.5xxx, which is the root
      // we're looking for in this test, because the root is far from the range.
      //
      // The range is far from the root: the method still works but it won't find
      // the root.
      expect(solutions.guesses.last.toStringAsFixed(1).contains("1.5"), false);
    });
  });
}
