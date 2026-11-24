import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/singular_value_decomposition/svd_real.dart';
import 'package:test/test.dart';

import '../../../../double_approximation_matcher.dart';
import '../decomposition_checks.dart';

RealMatrix _randomReal(
  int rows,
  int columns,
  Random random, [
  double scale = 1,
]) => RealMatrix.fromFlattenedData(
  rows: rows,
  columns: columns,
  data: List<double>.generate(
    rows * columns,
    (_) => (random.nextDouble() * 2 - 1) * scale,
  ),
);

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

    test('Empty matrices cannot be created', () {
      expect(
        () => SVDReal(
          matrix: RealMatrix.fromData(rows: 0, columns: 0, data: []),
        ).decompose(),
        throwsA(isA<MatrixException>()),
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

    test('Wide matrix (more columns than rows)', () {
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
      expect(svd[1].columnCount, equals(2));
      expect(svd[2].rowCount, equals(4));
      expect(svd[2].columnCount, equals(4));

      // A = U x E x V^T
      final reconstructed = svd[1] * svd[0] * svd[2].transpose();
      for (var i = 0; i < 2; i++) {
        for (var j = 0; j < 4; j++) {
          expect(
            reconstructed(i, j),
            MoreOrLessEquals(matrix(i, j)),
          );
        }
      }
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

  group('SVDReal regressions', () {
    test('Square, tall and wide matrices', () {
      final random = Random(3);

      for (final (rows, columns) in const [
        (5, 5),
        (8, 3),
        (3, 8),
        (2, 6),
        (1, 4),
        (4, 1),
      ]) {
        final matrix = _randomReal(rows, columns, random);
        expectValidRealSVD(matrix, SVDReal(matrix: matrix).decompose());
      }
    });

    test('Rank deficient wide matrix', () {
      final random = Random(4);
      final matrix = _randomReal(3, 2, random) * _randomReal(2, 5, random);

      final singularValues = expectValidRealSVD(
        matrix,
        SVDReal(matrix: matrix).decompose(),
      );
      expect(singularValues.last, const MoreOrLessEquals(0));
    });

    test('NaN and infinite values are rejected', () {
      for (final value in const [double.nan, double.infinity]) {
        final matrix = RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: [
            [value, 1],
            [2, 3],
          ],
        );

        expect(
          SVDReal(matrix: matrix).decompose,
          throwsA(isA<MatrixException>()),
        );
      }
    });

    test('Negligible last singular value of the bidiagonal form', () {
      // Already upper bidiagonal, with a zero in the last diagonal position
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 2, 0],
          [0, 3, 4],
          [0, 0, 0],
        ],
      );

      final singularValues = expectValidRealSVD(
        matrix,
        SVDReal(matrix: matrix).decompose(),
      );
      expect(singularValues.last, isZero);
    });
  });

  group('SVDReal edge cases', () {
    List<double> singularValues(RealMatrix matrix) =>
        expectValidRealSVD(matrix, SVDReal(matrix: matrix).decompose());

    test('Singular values of special matrices', () {
      // Orthogonal: all ones
      const angle = pi / 5;
      final rotation = RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: [cos(angle), -sin(angle), sin(angle), cos(angle)],
      );
      for (final value in singularValues(rotation)) {
        expect(value, const MoreOrLessEquals(1));
      }

      // Diagonal: the absolute values, sorted
      final diagonal = RealMatrix.fromFlattenedData(
        rows: 3,
        columns: 3,
        data: const [-1, 0, 0, 0, 3, 0, 0, 0, -2],
      );
      final diagonalValues = singularValues(diagonal);
      expect(diagonalValues.first, const MoreOrLessEquals(3));
      expect(diagonalValues[1], const MoreOrLessEquals(2));
      expect(diagonalValues[2], const MoreOrLessEquals(1));

      // Rank one (u x v^T): |u| |v| and zeros
      final u = RealMatrix.fromFlattenedData(
        rows: 3,
        columns: 1,
        data: const [1, 2, 2],
      );
      final v = RealMatrix.fromFlattenedData(
        rows: 1,
        columns: 4,
        data: const [3, 0, 4, 0],
      );
      final rankOneValues = singularValues(u * v);
      expect(rankOneValues.first, const MoreOrLessEquals(15));
      expect(rankOneValues[1], const MoreOrLessEquals(0));
      expect(rankOneValues[2], const MoreOrLessEquals(0));
    });

    test('Norm identities', () {
      final random = Random(40);
      final matrix = _randomReal(5, 3, random);
      final values = singularValues(matrix);

      // The squares of the singular values sum to the Frobenius norm
      final frobenius = matrix.flattenData.fold<double>(
        0,
        (sum, value) => sum + value * value,
      );
      expect(
        values.fold<double>(0, (sum, value) => sum + value * value),
        MoreOrLessEquals(frobenius),
      );

      // The largest singular value is the 2-norm: |A x| <= s1 |x|
      for (var i = 0; i < 20; i++) {
        final x = _randomReal(3, 1, random);
        final ax = matrix * x;
        double norm(RealMatrix vector) => sqrt(
          vector.flattenData.fold<double>(
            0,
            (sum, value) => sum + value * value,
          ),
        );
        expect(norm(ax), lessThanOrEqualTo(values.first * norm(x) + 1e-12));
      }

      // The transpose and multiples
      final transposedValues = singularValues(matrix.transpose());
      final scaledValues = singularValues(
        RealMatrix.fromFlattenedData(
          rows: 5,
          columns: 3,
          data: matrix.flattenData.map((value) => value * -2.5).toList(),
        ),
      );
      for (var i = 0; i < 3; i++) {
        expect(transposedValues[i], MoreOrLessEquals(values[i]));
        expect(scaledValues[i], MoreOrLessEquals(2.5 * values[i]));
      }
    });

    test(
      'Singular values are the square roots of the eigenvalues of A^T A',
      () {
        final random = Random(41);
        final matrix = _randomReal(6, 4, random);
        final values = singularValues(matrix);

        final eigenvalues = (matrix.transpose() * matrix).eigenvalues()
          ..sort((a, b) => b.real.compareTo(a.real));
        for (var i = 0; i < 4; i++) {
          expect(values[i], MoreOrLessEquals(sqrt(eigenvalues[i].real)));
        }
      },
    );

    test('Ill-conditioned, large and partially zero matrices', () {
      final hilbert = RealMatrix.fromFlattenedData(
        rows: 8,
        columns: 8,
        data: List<double>.generate(64, (k) => 1 / (k ~/ 8 + k % 8 + 1)),
      );
      final hilbertValues = singularValues(hilbert);
      expect(hilbertValues.last, greaterThan(0));
      expect(hilbertValues.last, lessThan(1e-9));

      final random = Random(42);
      singularValues(_randomReal(40, 25, random));
      singularValues(_randomReal(25, 40, random));

      // A zero row and a zero column
      singularValues(
        RealMatrix.fromFlattenedData(
          rows: 3,
          columns: 3,
          data: const [1, 0, 2, 0, 0, 0, 3, 0, 4],
        ),
      );
    });

    test('Singular values scale with the data', () {
      final random = Random(43);
      final unit = _randomReal(4, 3, random);
      final unitValues = singularValues(unit);

      for (final scale in const [1e-200, 1e200]) {
        final scaled = RealMatrix.fromFlattenedData(
          rows: 4,
          columns: 3,
          data: unit.flattenData.map((value) => value * scale).toList(),
        );
        final [e, _, _] = SVDReal(matrix: scaled).decompose();

        for (var i = 0; i < 3; i++) {
          expect(e(i, i) / scale, MoreOrLessEquals(unitValues[i]));
        }
      }
    });
  });
}
