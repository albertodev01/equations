import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing model classes of the 'PolynomialBloc' bloc", () {
    test('NonlinearType', () {
      expect(PolynomialType.values.length, equals(4));
    });
  });
}
