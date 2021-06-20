import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing events for the 'PolynomialBloc' bloc", () {
    test('Making sure that a comparison logic is implemented', () {
      const polynomialSolve = PolynomialSolve(coefficients: ['1', '2']);

      expect(
        polynomialSolve,
        equals(const PolynomialSolve(coefficients: ['1', '2'])),
      );

      expect(
        polynomialSolve,
        isNot(const PolynomialSolve(coefficients: ['1'])),
      );

      expect(
        const PolynomialClean(),
        equals(const PolynomialClean()),
      );

      expect(polynomialSolve.props.length, equals(1));
      expect(const PolynomialClean().props.length, equals(1));
    });
  });
}
