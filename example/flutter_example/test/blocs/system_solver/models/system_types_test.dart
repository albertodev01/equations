import 'package:equations_solver/blocs/system_solver/models/system_types.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing model classes of the 'SystemBloc' bloc", () {
    test('SystemType', () {
      expect(SystemType.values.length, equals(3));
    });

    test('RowReductionMethods', () {
      expect(RowReductionMethods.values.length, equals(1));
    });

    test('FactorizationMethods', () {
      expect(FactorizationMethods.values.length, equals(2));
    });

    test('IterativeMethods', () {
      expect(IterativeMethods.values.length, equals(3));
    });
  });
}
