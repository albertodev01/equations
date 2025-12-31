import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/eigenvalue_decomposition/eigendecomposition_complex.dart';
import 'package:test/test.dart';

void main() {
  group('EigendecompositionComplex', () {
    test('Equality tests', () {
      final complex = EigendecompositionComplex(
        matrix: ComplexMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [Complex.i()],
          ],
        ),
      );

      expect(
        EigendecompositionComplex(
          matrix: ComplexMatrix.fromData(
            rows: 1,
            columns: 1,
            data: const [
              [Complex.i()],
            ],
          ),
        ),
        equals(complex),
      );

      expect(
        complex,
        equals(
          EigendecompositionComplex(
            matrix: ComplexMatrix.fromData(
              rows: 1,
              columns: 1,
              data: const [
                [Complex.i()],
              ],
            ),
          ),
        ),
      );

      expect(
        EigendecompositionComplex(
          matrix: ComplexMatrix.fromData(
            rows: 1,
            columns: 1,
            data: const [
              [Complex.i()],
            ],
          ),
        ).hashCode,
        equals(complex.hashCode),
      );
    });

    test('Decomposition of 1x1 matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 1,
        columns: 1,
        data: const [
          [Complex(2, 3)],
        ],
      );

      final decomposition = EigendecompositionComplex(matrix: matrix);
      final result = decomposition.decompose();

      expect(result.length, equals(3));
      expect(result[0].rowCount, equals(1));
      expect(result[0].columnCount, equals(1));
      expect(result[1].rowCount, equals(1));
      expect(result[1].columnCount, equals(1));
      expect(result[2].rowCount, equals(1));
      expect(result[2].columnCount, equals(1));
    });

    test('Decomposition of 2x2 symmetric matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex(1, 0), Complex(2, 0)],
          [Complex(2, 0), Complex(1, 0)],
        ],
      );

      final decomposition = EigendecompositionComplex(matrix: matrix);
      final result = decomposition.decompose();

      expect(result.length, equals(3));
      expect(result[0].rowCount, equals(2));
      expect(result[0].columnCount, equals(2));
      expect(result[1].rowCount, equals(2));
      expect(result[1].columnCount, equals(2));
      expect(result[2].rowCount, equals(2));
      expect(result[2].columnCount, equals(2));
    });

    test('Decomposition of 2x2 non-symmetric matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex(1, 1), Complex(2, 1)],
          [Complex(3, 1), Complex(4, 1)],
        ],
      );

      final decomposition = EigendecompositionComplex(matrix: matrix);
      final result = decomposition.decompose();

      expect(result.length, equals(3));
      expect(result[0].rowCount, equals(2));
      expect(result[0].columnCount, equals(2));
      expect(result[1].rowCount, equals(2));
      expect(result[1].columnCount, equals(2));
      expect(result[2].rowCount, equals(2));
      expect(result[2].columnCount, equals(2));
    });

    test('Decomposition of 3x3 symmetric matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex(1, 0), Complex(2, 0), Complex(3, 0)],
          [Complex(2, 0), Complex(4, 0), Complex(5, 0)],
          [Complex(3, 0), Complex(5, 0), Complex(6, 0)],
        ],
      );

      final decomposition = EigendecompositionComplex(matrix: matrix);
      final result = decomposition.decompose();

      expect(result.length, equals(3));
      expect(result[0].rowCount, equals(3));
      expect(result[0].columnCount, equals(3));
      expect(result[1].rowCount, equals(3));
      expect(result[1].columnCount, equals(3));
      expect(result[2].rowCount, equals(3));
      expect(result[2].columnCount, equals(3));
    });

    test('Decomposition of 3x3 non-symmetric matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex(1, 1), Complex(2, 1), Complex(3, 1)],
          [Complex(4, 1), Complex(5, 1), Complex(6, 1)],
          [Complex(7, 1), Complex(8, 1), Complex(9, 1)],
        ],
      );

      final decomposition = EigendecompositionComplex(matrix: matrix);
      final result = decomposition.decompose();

      expect(result.length, equals(3));
      expect(result[0].rowCount, equals(3));
      expect(result[0].columnCount, equals(3));
      expect(result[1].rowCount, equals(3));
      expect(result[1].columnCount, equals(3));
      expect(result[2].rowCount, equals(3));
      expect(result[2].columnCount, equals(3));
    });

    test('Decomposition of matrix with zero elements', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.zero(), Complex.zero()],
          [Complex.zero(), Complex.zero()],
        ],
      );

      final decomposition = EigendecompositionComplex(matrix: matrix);
      final result = decomposition.decompose();

      expect(result.length, equals(3));
      expect(result[0].rowCount, equals(2));
      expect(result[0].columnCount, equals(2));
      expect(result[1].rowCount, equals(2));
      expect(result[1].columnCount, equals(2));
      expect(result[2].rowCount, equals(2));
      expect(result[2].columnCount, equals(2));
    });

    test('Decomposition of matrix with complex conjugate eigenvalues', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex(0, 1), Complex(1, 0)],
          [Complex(-1, 0), Complex(0, -1)],
        ],
      );

      final decomposition = EigendecompositionComplex(matrix: matrix);
      final result = decomposition.decompose();

      expect(result.length, equals(3));
      expect(result[0].rowCount, equals(2));
      expect(result[0].columnCount, equals(2));
      expect(result[1].rowCount, equals(2));
      expect(result[1].columnCount, equals(2));
      expect(result[2].rowCount, equals(2));
      expect(result[2].columnCount, equals(2));
    });

    test('Decomposition of matrix with repeated eigenvalues', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex(2, 0), Complex(0, 0)],
          [Complex(0, 0), Complex(2, 0)],
        ],
      );

      final decomposition = EigendecompositionComplex(matrix: matrix);
      final result = decomposition.decompose();

      expect(result.length, equals(3));
      expect(result[0].rowCount, equals(2));
      expect(result[0].columnCount, equals(2));
      expect(result[1].rowCount, equals(2));
      expect(result[1].columnCount, equals(2));
      expect(result[2].rowCount, equals(2));
      expect(result[2].columnCount, equals(2));
    });

    test('Decomposition of matrix with ill-conditioned eigenvalues', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex(1e-10, 0), Complex(1, 0)],
          [Complex(1, 0), Complex(10000000000, 0)],
        ],
      );

      final decomposition = EigendecompositionComplex(matrix: matrix);
      final result = decomposition.decompose();

      expect(result.length, equals(3));
      expect(result[0].rowCount, equals(2));
      expect(result[0].columnCount, equals(2));
      expect(result[1].rowCount, equals(2));
      expect(result[1].columnCount, equals(2));
      expect(result[2].rowCount, equals(2));
      expect(result[2].columnCount, equals(2));
    });
  });
}
