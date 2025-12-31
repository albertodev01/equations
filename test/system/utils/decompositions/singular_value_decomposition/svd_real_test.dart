import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/singular_value_decomposition/svd_real.dart';
import 'package:test/test.dart';

import '../../../../double_approximation_matcher.dart';

void main() {
  group('SVDReal class', () {
    test('Equality tests', () {
      final svd1 = SVDReal(
        matrix: RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: [
            [1],
          ],
        ),
      );

      final svd2 = SVDReal(
        matrix: RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: [
            [1],
          ],
        ),
      );

      expect(svd1, equals(svd2));
      expect(svd1.hashCode, equals(svd2.hashCode));
    });

    test('Empty matrix throws ArgumentError', () {
      expect(
        () => SVDReal(
          matrix: RealMatrix.fromData(rows: 0, columns: 0, data: []),
        ).decompose(),
        throwsArgumentError,
      );
    });

    test('1x1 matrix decomposition', () {
      final matrix = RealMatrix.fromData(
        rows: 1,
        columns: 1,
        data: const [
          [5],
        ],
      );

      final svd = SVDReal(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // E matrix
      expect(svd[0](0, 0), equals(5));
      expect(svd[0].rowCount, equals(1));
      expect(svd[0].columnCount, equals(1));

      // U matrix
      expect(svd[1](0, 0), equals(1));
      expect(svd[1].rowCount, equals(1));
      expect(svd[1].columnCount, equals(1));

      // V matrix
      expect(svd[2](0, 0), equals(1));
      expect(svd[2].rowCount, equals(1));
      expect(svd[2].columnCount, equals(1));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      expect(reconstructed(0, 0), equals(5));
    });

    test('2x2 matrix decomposition with negative values', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [-1, 2],
          [3, -4],
        ],
      );

      final svd = SVDReal(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      expect(
        reconstructed(0, 0),
        const MoreOrLessEquals(-1, precision: 1.0e-5),
      );
      expect(reconstructed(0, 1), const MoreOrLessEquals(2, precision: 1.0e-5));
      expect(reconstructed(1, 0), const MoreOrLessEquals(3, precision: 1.0e-5));
      expect(
        reconstructed(1, 1),
        const MoreOrLessEquals(-4, precision: 1.0e-5),
      );
    });

    test('3x2 matrix decomposition', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 2,
        data: const [
          [1, 2],
          [3, 4],
          [5, 6],
        ],
      );

      final svd = SVDReal(matrix: matrix).decompose();
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
            reconstructed(i, j),
            MoreOrLessEquals(matrix(i, j), precision: 1.0e-5),
          );
        }
      }
    });

    test('Matrix with zero values', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [0, 0],
          [0, 0],
        ],
      );

      final svd = SVDReal(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      expect(reconstructed(0, 0), equals(0));
      expect(reconstructed(0, 1), equals(0));
      expect(reconstructed(1, 0), equals(0));
      expect(reconstructed(1, 1), equals(0));
    });

    test('Matrix with very small values', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [1e-10, 1e-12],
          [1e-14, 1e-16],
        ],
      );

      final svd = SVDReal(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      expect(
        reconstructed(0, 0),
        const MoreOrLessEquals(1e-10, precision: 1.0e-5),
      );
      expect(
        reconstructed(0, 1),
        const MoreOrLessEquals(1e-12, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 0),
        const MoreOrLessEquals(1e-14, precision: 1.0e-5),
      );
      expect(
        reconstructed(1, 1),
        const MoreOrLessEquals(1e-16, precision: 1.0e-5),
      );
    });

    test('Matrix with large values', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [1e10, 1e12],
          [1e14, 1e16],
        ],
      );

      final svd = SVDReal(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      expect(
        reconstructed.toString(),
        equals('''
[9999999999.994453, 999999999999.4453]
[100000000000000.0, 10000000000000000.0]'''),
      );
    });

    test('Symmetric matrix decomposition', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 2, 3],
          [2, 4, 5],
          [3, 5, 6],
        ],
      );

      final svd = SVDReal(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
          expect(
            reconstructed(i, j),
            MoreOrLessEquals(matrix(i, j), precision: 1.0e-5),
          );
        }
      }
    });

    test('Matrix with repeated values', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 1, 1],
          [1, 1, 1],
          [1, 1, 1],
        ],
      );

      final svd = SVDReal(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
          expect(
            reconstructed(i, j),
            const MoreOrLessEquals(1, precision: 1.0e-5),
          );
        }
      }
    });

    test('Wide matrix (more columns than rows) to trigger rowCount < p', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 4,
        data: const [
          [1, 2, 3, 4],
          [5, 6, 7, 8],
        ],
      );

      final svd = SVDReal(matrix: matrix).decompose();
      expect(svd.length, equals(3));
      expect(svd[0].rowCount, equals(2));
      expect(svd[0].columnCount, equals(4));
      expect(svd[1].rowCount, equals(2));
      expect(svd[1].columnCount, equals(4));
      expect(svd[2].rowCount, equals(4));
      expect(svd[2].columnCount, equals(4));
    });

    test('Tall matrix (more rows than columns) to trigger edge cases', () {
      final matrix = RealMatrix.fromData(
        rows: 4,
        columns: 2,
        data: const [
          [1, 2],
          [3, 4],
          [5, 6],
          [7, 8],
        ],
      );

      final svd = SVDReal(matrix: matrix).decompose();
      expect(svd.length, equals(3));
      expect(svd[0].rowCount, equals(4));
      expect(svd[0].columnCount, equals(2));
      expect(svd[1].rowCount, equals(4));
      expect(svd[1].columnCount, equals(4));
      expect(svd[2].rowCount, equals(2));
      expect(svd[2].columnCount, equals(2));
    });

    test('Large square matrix to trigger various SVD edge cases', () {
      final matrix = RealMatrix.fromData(
        rows: 5,
        columns: 5,
        data: const [
          [1, 2, 3, 4, 5],
          [6, 7, 8, 9, 10],
          [11, 12, 13, 14, 15],
          [16, 17, 18, 19, 20],
          [21, 22, 23, 24, 25],
        ],
      );

      final svd = SVDReal(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      for (var i = 0; i < 5; i++) {
        for (var j = 0; j < 5; j++) {
          expect(
            reconstructed(i, j),
            MoreOrLessEquals(matrix(i, j), precision: 1.0e-4),
          );
        }
      }
    });

    test('Matrix to trigger case 2 convergence branch and sorting', () {
      final matrix = RealMatrix.fromData(
        rows: 4,
        columns: 4,
        data: const [
          [1, 2, 3, 4],
          [5, 6, 7, 8],
          [9, 10, 11, 12],
          [13, 14, 15, 16],
        ],
      );

      final svd = SVDReal(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      for (var i = 0; i < 4; i++) {
        for (var j = 0; j < 4; j++) {
          expect(
            reconstructed(i, j),
            MoreOrLessEquals(matrix(i, j), precision: 1.0e-4),
          );
        }
      }
    });

    test('Matrix to trigger negative shift branch', () {
      final matrix = RealMatrix.fromData(
        rows: 5,
        columns: 5,
        data: const [
          [10, 1, 0, 0, 0],
          [1, 10, 1, 0, 0],
          [0, 1, 10, 1, 0],
          [0, 0, 1, 10, 1],
          [0, 0, 0, 1, 10],
        ],
      );

      final svd = SVDReal(matrix: matrix).decompose();
      expect(svd.length, equals(3));

      // Verify U * E * V^T = original matrix
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      for (var i = 0; i < 5; i++) {
        for (var j = 0; j < 5; j++) {
          expect(
            reconstructed(i, j),
            MoreOrLessEquals(matrix(i, j), precision: 1.0e-4),
          );
        }
      }
    });
  });
}
