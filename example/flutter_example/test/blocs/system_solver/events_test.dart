import 'package:equations_solver/blocs/system_solver/system_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing events for the 'SystemBloc' bloc", () {
    test('Making sure that a comparison logic is implemented', () {
      const rowReduction = RowReductionMethod(
        matrix: ['1', '2', '3', '4'],
        knownValues: ['1', '2'],
        size: 2,
      );

      const factorization = FactorizationMethod(
        matrix: ['1', '2', '3', '4', '5', '6'],
        knownValues: ['1', '2', '3'],
        size: 3,
      );

      const iterative = IterativeMethod(
        matrix: ['1', '2', '3', '4', '5', '6'],
        knownValues: ['1', '2', '3'],
        size: 2,
      );

      expect(rowReduction.props.length, equals(3));
      expect(factorization.props.length, equals(4));
      expect(iterative.props.length, equals(8));

      expect(
        const RowReductionMethod(
          matrix: ['1', '2', '3', '4'],
          knownValues: ['1', '2'],
          size: 2,
        ),
        equals(rowReduction),
      );

      expect(
        const FactorizationMethod(
          matrix: ['1', '2', '3', '4', '5', '6'],
          knownValues: ['1', '2', '3'],
          size: 3,
        ),
        equals(factorization),
      );

      expect(
        const IterativeMethod(
          matrix: ['1', '2', '3', '4', '5', '6'],
          knownValues: ['1', '2', '3'],
          size: 2,
        ),
        equals(iterative),
      );

      expect(
        const SystemClean(),
        equals(const SystemClean()),
      );

      expect(
        const SystemClean().props.length,
        equals(3),
      );
    });

    test(
        "Making sure that 'RowReductionMethod.resolve' actually resolves to "
        'the correct values', () {
      expect(
        RowReductionMethod.resolve('gauss'),
        equals(RowReductionMethods.gauss),
      );
      expect(
        RowReductionMethod.resolve('GAuSs'),
        equals(RowReductionMethods.gauss),
      );

      expect(
        () => RowReductionMethod.resolve('gausss'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test(
        "Making sure that 'IterativeMethod. resolve' actually resolves to "
        'the correct values', () {
      expect(
        IterativeMethod.resolve('jacobi'),
        equals(IterativeMethods.jacobi),
      );
      expect(
        IterativeMethod.resolve('sor'),
        equals(IterativeMethods.sor),
      );

      expect(
        () => IterativeMethod.resolve(''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test(
        "Making sure that 'FactorizationMethod. resolve' actually resolves to "
        'the correct values', () {
      expect(
        FactorizationMethod.resolve('lu'),
        equals(FactorizationMethods.lu),
      );
      expect(
        FactorizationMethod.resolve('cholesky'),
        equals(FactorizationMethods.cholesky),
      );

      expect(
        () => FactorizationMethod.resolve(''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
