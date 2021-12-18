import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing states for the 'IntegralType' enum", () {
    test('Making sure that it has the correct number of values', () {
      expect(IntegralType.values.length, equals(3));
    });
  });
}
