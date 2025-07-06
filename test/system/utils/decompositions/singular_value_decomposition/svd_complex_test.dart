import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/singular_value_decomposition/svd_complex.dart';
import 'package:test/test.dart';

import '../../../../double_approximation_matcher.dart';

void main() {
  group('SVDComplex class', () {
    test('Equality tests', () {
      final svd1 = SVDComplex(
        matrix: ComplexMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [Complex.fromReal(1)],
          ],
        ),
      );

      final svd2 = SVDComplex(
        matrix: ComplexMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [Complex.fromReal(1)],
          ],
        ),
      );

      expect(svd1, equals(svd2));
      expect(svd1.hashCode, equals(svd2.hashCode));
    });

    test('Empty matrix throws ArgumentError', () {
      expect(
        () =>
            SVDComplex(
              matrix: ComplexMatrix.fromData(
                rows: 0,
                columns: 0,
                data: const [],
              ),
            ).decompose(),
        throwsArgumentError,
      );
    });

    test('1x1 matrix decomposition', () {
      final matrix = ComplexMatrix.fromData(
        rows: 1,
        columns: 1,
        data: const [
          [Complex.fromReal(5)],
        ],
      );

      final svd = SVDComplex(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // E matrix
      expect(svd[0](0, 0).real, equals(5));
      expect(svd[0](0, 0).imaginary, equals(0));
      expect(svd[0].rowCount, equals(1));
      expect(svd[0].columnCount, equals(1));

      // U matrix
      expect(svd[1](0, 0).real, equals(1));
      expect(svd[1](0, 0).imaginary, equals(0));
      expect(svd[1].rowCount, equals(1));
      expect(svd[1].columnCount, equals(1));

      // V matrix
      expect(svd[2](0, 0).real, equals(1));
      expect(svd[2](0, 0).imaginary, equals(0));
      expect(svd[2].rowCount, equals(1));
      expect(svd[2].columnCount, equals(1));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      expect(reconstructed(0, 0).real, equals(5));
      expect(reconstructed(0, 0).imaginary, equals(0));
    });

    test('2x2 matrix with complex values', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.i(), Complex.fromReal(2)],
          [Complex(7, 1), Complex.fromReal(6)],
        ],
      );

      final svd = SVDComplex(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      expect(
        reconstructed(0, 0).real,
        const MoreOrLessEquals(0, precision: 1.0e-5),
      );
      expect(
        reconstructed(0, 0).imaginary,
        const MoreOrLessEquals(1, precision: 1.0e-5),
      );
      expect(
        reconstructed(0, 1).real,
        const MoreOrLessEquals(2, precision: 1.0e-5),
      );
      expect(
        reconstructed(0, 1).imaginary,
        const MoreOrLessEquals(0, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 0).real,
        const MoreOrLessEquals(7, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 0).imaginary,
        const MoreOrLessEquals(1, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 1).real,
        const MoreOrLessEquals(6, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 1).imaginary,
        const MoreOrLessEquals(0, precision: 1.0e-5),
      );
    });

    test('3x2 matrix with complex values', () {
      final matrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 2,
        data: const [
          [Complex(1, 1), Complex(2, -1)],
          [Complex(3, 2), Complex(4, -2)],
          [Complex(5, 3), Complex(6, -3)],
        ],
      );

      final svd = SVDComplex(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // Verify dimensions
      expect(svd[0].rowCount, equals(3));
      expect(svd[0].columnCount, equals(2));
      expect(svd[1].rowCount, equals(3));
      expect(svd[1].columnCount, equals(3));
      expect(svd[2].rowCount, equals(2));
      expect(svd[2].columnCount, equals(2));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 2; j++) {
          expect(
            reconstructed(i, j).real,
            MoreOrLessEquals(matrix(i, j).real, precision: 1.0e-5),
          );
          expect(
            reconstructed(i, j).imaginary,
            MoreOrLessEquals(matrix(i, j).imaginary, precision: 1.0e-5),
          );
        }
      }
    });

    test('Matrix with zero values', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.zero(), Complex.zero()],
          [Complex.zero(), Complex.zero()],
        ],
      );

      expect(matrix.singleValueDecomposition, throwsA(isA<Exception>()));
    });

    test('Matrix with very small values', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex(1e-10, 1e-12), Complex(1e-14, 1e-16)],
          [Complex(1e-18, 1e-20), Complex(1e-22, 1e-24)],
        ],
      );

      final svd = SVDComplex(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      expect(
        reconstructed(0, 0).real,
        const MoreOrLessEquals(1e-10, precision: 1.0e-5),
      );
      expect(
        reconstructed(0, 0).imaginary,
        const MoreOrLessEquals(1e-12, precision: 1.0e-5),
      );
      expect(
        reconstructed(0, 1).real,
        const MoreOrLessEquals(1e-14, precision: 1.0e-5),
      );
      expect(
        reconstructed(0, 1).imaginary,
        const MoreOrLessEquals(1e-16, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 0).real,
        const MoreOrLessEquals(1e-18, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 0).imaginary,
        const MoreOrLessEquals(1e-20, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 1).real,
        const MoreOrLessEquals(1e-22, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 1).imaginary,
        const MoreOrLessEquals(1e-24, precision: 1.0e-5),
      );
    });

    test('Symmetric complex matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex(1, 1), Complex(2, -1), Complex(3, 2)],
          [Complex(2, -1), Complex(4, 2), Complex(5, -2)],
          [Complex(3, 2), Complex(5, -2), Complex(6, 3)],
        ],
      );

      final svd = SVDComplex(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
          expect(
            reconstructed(i, j).real,
            MoreOrLessEquals(matrix(i, j).real, precision: 1.0e-5),
          );
          expect(
            reconstructed(i, j).imaginary,
            MoreOrLessEquals(matrix(i, j).imaginary, precision: 1.0e-5),
          );
        }
      }
    });

    test('Matrix with repeated complex values', () {
      final matrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex(1, 1), Complex(1, 1), Complex(1, 1)],
          [Complex(1, 1), Complex(1, 1), Complex(1, 1)],
          [Complex(1, 1), Complex(1, 1), Complex(1, 1)],
        ],
      );

      expect(matrix.singleValueDecomposition, throwsA(isA<Exception>()));
    });

    test('Matrix with pure imaginary values', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.i(), Complex(0, 2)],
          [Complex(0, 3), Complex(0, 4)],
        ],
      );

      final svd = SVDComplex(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      expect(
        reconstructed(0, 0).real,
        const MoreOrLessEquals(0, precision: 1.0e-5),
      );
      expect(
        reconstructed(0, 0).imaginary,
        const MoreOrLessEquals(1, precision: 1.0e-5),
      );
      expect(
        reconstructed(0, 1).real,
        const MoreOrLessEquals(0, precision: 1.0e-5),
      );
      expect(
        reconstructed(0, 1).imaginary,
        const MoreOrLessEquals(2, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 0).real,
        const MoreOrLessEquals(0, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 0).imaginary,
        const MoreOrLessEquals(3, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 1).real,
        const MoreOrLessEquals(0, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 1).imaginary,
        const MoreOrLessEquals(4, precision: 1.0e-5),
      );
    });

    test('Matrix with mixed real and imaginary values', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex(1, 2), Complex(3, 4)],
          [Complex(5, 6), Complex(7, 8)],
        ],
      );

      final svd = SVDComplex(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      expect(
        reconstructed(0, 0).real,
        const MoreOrLessEquals(1, precision: 1.0e-5),
      );
      expect(
        reconstructed(0, 0).imaginary,
        const MoreOrLessEquals(2, precision: 1.0e-5),
      );
      expect(
        reconstructed(0, 1).real,
        const MoreOrLessEquals(3, precision: 1.0e-5),
      );
      expect(
        reconstructed(0, 1).imaginary,
        const MoreOrLessEquals(4, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 0).real,
        const MoreOrLessEquals(5, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 0).imaginary,
        const MoreOrLessEquals(6, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 1).real,
        const MoreOrLessEquals(7, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 1).imaginary,
        const MoreOrLessEquals(8, precision: 1.0e-5),
      );
    });
  });
}
