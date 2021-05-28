import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing model classes of the 'NonlinearSolverBloc' bloc", () {
    test('NonlinearType', () {
      expect(NonlinearType.values.length, equals(2));
    });

    test('SinglePointMethods', () {
      expect(SinglePointMethods.values.length, equals(2));
    });

    test('BracketingMethods', () {
      expect(BracketingMethods.values.length, equals(3));
    });
  });
}
