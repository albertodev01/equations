import 'package:equations/src/algebraic/types/laguerre.dart';
import 'package:test/test.dart';

void main() {
  group("Testing 'Laguerre' algebraic equations", () {
    test("Making sure that a 'Laguerre' object is properly constructed", () {
      final equation = Laguerre.realEquation(coefficients: [-5, 3, 1]);

      // Checking solutions
      final solutions = equation.solutions();
      for (var solution in solutions) print(solution);

      expect(solutions.length, 2);
    });
  });
}
