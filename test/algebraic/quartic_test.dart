import 'package:equations/src/algebraic/cubic.dart';
import 'package:equations/src/algebraic/quartic.dart';
import 'package:equations/src/complex.dart';
import 'package:test/test.dart';

void main() {
  group("Testing quartic equations", () {
    test("Real equation -> 3x^4 + 6x^3 + 2x - 1 = 0", () {
      final equation = Quartic(
        a: Complex.fromReal(3),
        b: Complex.fromReal(6),
        d: Complex.fromReal(2),
        e: Complex.fromReal(-1)
      );

      expect(equation.degree, 4);
      expect(equation.derivative(), Cubic(
        a: Complex.fromReal(12),
        b: Complex.fromReal(18),
        d: Complex.fromReal(2)
      ));
      expect(equation.isRealEquation, true);
      //expect(equation.discriminant(), Complex.fromReal(-70848));
      expect("$equation", "f(x) = 3x^4 + 6x^3 + 2x + -1");
      expect("${equation.toStringWithFractions()}",
          "f(x) = 3x^4 + 6x^3 + 2x + -1");

      final solutions = equation.solutions();
      expect(solutions[0].real.toStringAsFixed(12), "-2.173571613806");
      expect(solutions[0].imaginary.round(), 0);
      expect(solutions[1].real.toStringAsFixed(12), "0.349518864775");
      expect(solutions[1].imaginary.round(), 0);
      expect(solutions[2].real.toStringAsFixed(12), "-0.087973625484");
      expect(solutions[2].imaginary.toStringAsFixed(12), "-0.656527118532");
      expect(solutions[2].real.toStringAsFixed(12), "-0.087973625484");
      expect(solutions[2].imaginary.toStringAsFixed(12), "0.656527118532");

      final eval = equation.realEvaluateOn(2);
      expect(eval, Complex.fromReal(99));
    });
  });
}