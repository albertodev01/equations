import 'package:equations/equations.dart';
import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing states for the 'PolynomialBloc' bloc", () {
    test('Making sure that a comparison logic is implemented', () {
      final algebraic = Algebraic.fromReal([-1, 2, 3]);

      expect(
        PolynomialRoots(
          algebraic: algebraic,
          discriminant: const Complex.i(),
          roots: const [
            Complex.fromReal(-1),
            Complex.fromReal(3),
          ],
        ),
        equals(
          PolynomialRoots(
            algebraic: algebraic,
            discriminant: const Complex.i(),
            roots: const [
              Complex.fromReal(-1),
              Complex.fromReal(3),
            ],
          ),
        ),
      );

      expect(
        const PolynomialError(),
        equals(const PolynomialError()),
      );

      expect(
        const PolynomialNone(),
        equals(const PolynomialNone()),
      );
    });
  });
}
