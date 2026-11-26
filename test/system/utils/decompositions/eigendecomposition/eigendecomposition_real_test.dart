import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/eigenvalue_decomposition/eigendecomposition_real.dart';
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
  group('EigenDecomposition', () {
    test('Equality tests', () {
      final real = EigendecompositionReal(
        matrix: RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: [
            [1],
          ],
        ),
      );

      expect(
        EigendecompositionReal(
          matrix: RealMatrix.fromData(
            rows: 1,
            columns: 1,
            data: [
              [1],
            ],
          ),
        ),
        equals(real),
      );
      expect(
        real,
        equals(
          EigendecompositionReal(
            matrix: RealMatrix.fromData(
              rows: 1,
              columns: 1,
              data: [
                [1],
              ],
            ),
          ),
        ),
      );

      expect(
        EigendecompositionReal(
          matrix: RealMatrix.fromData(
            rows: 1,
            columns: 1,
            data: [
              [1],
            ],
          ),
        ).hashCode,
        equals(real.hashCode),
      );
    });

    test('decompose() with symmetric matrix', () {
      // Test case 1: Simple 2x2 symmetric matrix
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [4, 1],
          [1, 3],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 2);
      expect(result[0].columnCount, 2);
      expect(result[1].rowCount, 2);
      expect(result[1].columnCount, 2);
      expect(result[2].rowCount, 2);
      expect(result[2].columnCount, 2);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      for (var i = 0; i < 2; i++) {
        for (var j = 0; j < 2; j++) {
          expect(
            reconstructed(i, j),
            MoreOrLessEquals(matrix(i, j)),
          );
        }
      }
    });

    test('decompose() with non-symmetric matrix', () {
      // Test case 2: 2x2 non-symmetric matrix
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [1, 2],
          [3, 4],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 2);
      expect(result[0].columnCount, 2);
      expect(result[1].rowCount, 2);
      expect(result[1].columnCount, 2);
      expect(result[2].rowCount, 2);
      expect(result[2].columnCount, 2);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      final rounded = RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: reconstructed.flattenData.map((e) => e.round() * 1.0).toList(),
      );
      expect(matrix, equals(rounded));
    });

    test('decompose() with 3x3 symmetric matrix', () {
      // Test case 3: 3x3 symmetric matrix
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: [
          [2, -1, 0],
          [-1, 2, -1],
          [0, -1, 2],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 3);
      expect(result[0].columnCount, 3);
      expect(result[1].rowCount, 3);
      expect(result[1].columnCount, 3);
      expect(result[2].rowCount, 3);
      expect(result[2].columnCount, 3);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      final rounded = RealMatrix.fromFlattenedData(
        rows: 3,
        columns: 3,
        data: reconstructed.flattenData.map((e) => e.roundToDouble()).toList(),
      );
      expect(matrix, equals(rounded));
    });

    test('decompose() with 3x3 non-symmetric matrix', () {
      // Test case 4: 3x3 non-symmetric matrix
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 3);
      expect(result[0].columnCount, 3);
      expect(result[1].rowCount, 3);
      expect(result[1].columnCount, 3);
      expect(result[2].rowCount, 3);
      expect(result[2].columnCount, 3);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      final rounded = RealMatrix.fromFlattenedData(
        rows: 3,
        columns: 3,
        data: reconstructed.flattenData.map((e) => e.roundToDouble()).toList(),
      );
      expect(matrix, equals(rounded));
    });

    test('decompose() with matrix having complex eigenvalues', () {
      // Test case 5: Matrix with complex eigenvalues
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [0, -1],
          [1, 0],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 2);
      expect(result[0].columnCount, 2);
      expect(result[1].rowCount, 2);
      expect(result[1].columnCount, 2);
      expect(result[2].rowCount, 2);
      expect(result[2].columnCount, 2);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      expect(reconstructed, equals(matrix));
    });

    test('decompose() with matrix having repeated eigenvalues', () {
      // Test case 6: Matrix with repeated eigenvalues
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [2, 0],
          [0, 2],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 2);
      expect(result[0].columnCount, 2);
      expect(result[1].rowCount, 2);
      expect(result[1].columnCount, 2);
      expect(result[2].rowCount, 2);
      expect(result[2].columnCount, 2);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      expect(reconstructed, equals(matrix));
    });

    test('decompose() with matrix having zero eigenvalues', () {
      // Test case 7: Matrix with zero eigenvalues
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [0, 0],
          [0, 0],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 2);
      expect(result[0].columnCount, 2);
      expect(result[1].rowCount, 2);
      expect(result[1].columnCount, 2);
      expect(result[2].rowCount, 2);
      expect(result[2].columnCount, 2);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      expect(reconstructed, equals(matrix));
    });

    test('decompose() with matrix having negative eigenvalues', () {
      // Test case 8: Matrix with negative eigenvalues
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [-1, 0],
          [0, -2],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 2);
      expect(result[0].columnCount, 2);
      expect(result[1].rowCount, 2);
      expect(result[1].columnCount, 2);
      expect(result[2].rowCount, 2);
      expect(result[2].columnCount, 2);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      expect(reconstructed, equals(matrix));
    });

    test('decompose() with matrix having mixed eigenvalues', () {
      // Test case 9: Matrix with mixed eigenvalues (positive, negative, zero)
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: [
          [1, 0, 0],
          [0, -1, 0],
          [0, 0, 0],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 3);
      expect(result[0].columnCount, 3);
      expect(result[1].rowCount, 3);
      expect(result[1].columnCount, 3);
      expect(result[2].rowCount, 3);
      expect(result[2].columnCount, 3);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      expect(reconstructed, equals(matrix));
    });

    test('decompose() with matrix having complex conjugate eigenvalues', () {
      // Test case 10: Matrix with complex conjugate eigenvalues
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [1, -2],
          [2, 1],
        ],
      );

      final decomposition = EigendecompositionReal(matrix: matrix);
      final result = decomposition.decompose();

      // Verify result contains 3 matrices: V, D, V^-1
      expect(result.length, 3);
      expect(result[0].rowCount, 2);
      expect(result[0].columnCount, 2);
      expect(result[1].rowCount, 2);
      expect(result[1].columnCount, 2);
      expect(result[2].rowCount, 2);
      expect(result[2].columnCount, 2);

      // Verify A = VDV^-1
      final reconstructed = result[0] * result[1] * result[2];
      expect(reconstructed, equals(matrix));
    });
  });

  group('EigendecompositionReal regressions', () {
    test('Non-square matrices are rejected', () {
      expect(
        EigendecompositionReal(matrix: RealMatrix(rows: 2, columns: 3))
            .decompose,
        throwsA(isA<MatrixException>()),
      );
    });

    test('NaN and infinite values are rejected', () {
      for (final value in const [double.nan, double.infinity]) {
        final symmetric = RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: [
            [value, 1],
            [1, 3],
          ],
        );

        expect(
          EigendecompositionReal(matrix: symmetric).decompose,
          throwsA(isA<MatrixException>()),
        );
      }
    });

    test('Complex eigenvalues are stored as 2x2 blocks', () {
      // A rotation by 90 degrees: the eigenvalues are +i and -i
      final rotation = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [0, -1],
          [1, 0],
        ],
      );

      final [v, d, _] = EigendecompositionReal(matrix: rotation).decompose();
      expectRealMatrixClose(rotation * v, v * d);
      expect(d(0, 0), isZero);
      expect(d(1, 1), isZero);
      expect(d(0, 1), equals(-d(1, 0)));
      expect(d(0, 1).abs(), const MoreOrLessEquals(1));
    });

    test('Random symmetric and non-symmetric matrices', () {
      final random = Random(5);

      for (var n = 3; n <= 8; n++) {
        final general = _randomReal(n, n, random);
        final symmetric = general + general.transpose();

        for (final matrix in [general, symmetric]) {
          final [v, d, inverseV] = EigendecompositionReal(
            matrix: matrix,
          ).decompose();
          expectRealMatrixClose(matrix * v, v * d);
          expectRealMatrixClose(v * d * inverseV, matrix);
        }
      }
    });
  });

  group('EigendecompositionReal edge cases', () {
    List<Complex> sortedEigenvalues(RealMatrix matrix) =>
        matrix.eigenvalues()..sort((a, b) {
          final byReal = a.real.compareTo(b.real);
          return byReal != 0 ? byReal : a.imaginary.compareTo(b.imaginary);
        });

    test('Symmetric matrices: sorted eigenvalues and orthogonal V', () {
      final random = Random(60);

      for (var n = 1; n <= 7; n++) {
        final b = _randomReal(n, n, random);
        final symmetric = b + b.transpose();
        final [v, d, inverseV] = EigendecompositionReal(
          matrix: symmetric,
        ).decompose();

        expect(d.isDiagonal(), isTrue);
        for (var i = 1; i < n; i++) {
          expect(d(i, i), greaterThanOrEqualTo(d(i - 1, i - 1)));
        }
        expectRealMatrixClose(
          v.transpose() * v,
          RealMatrix(rows: n, columns: n, identity: true),
        );
        expectRealMatrixClose(inverseV, v.transpose());
      }
    });

    test('Eigenvalues of triangular and companion matrices', () {
      final triangular = RealMatrix.fromFlattenedData(
        rows: 4,
        columns: 4,
        data: const [4, 1, -2, 3, 0, -1, 5, 2, 0, 0, 2, 7, 0, 0, 0, 0.5],
      );
      expectSameEigenvalues(
        triangular.eigenvalues(),
        const [
          Complex.fromReal(4),
          Complex.fromReal(-1),
          Complex.fromReal(2),
          Complex.fromReal(0.5),
        ],
      );

      // Companion matrix of (x - 1)(x - 2)(x - 3)(x - 4)
      final companion = RealMatrix.fromFlattenedData(
        rows: 4,
        columns: 4,
        data: const [10, -35, 50, -24, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0],
      );
      expectSameEigenvalues(
        companion.eigenvalues(),
        const [
          Complex.fromReal(1),
          Complex.fromReal(2),
          Complex.fromReal(3),
          Complex.fromReal(4),
        ],
      );
    });

    test('Several pairs of complex conjugate eigenvalues', () {
      // Block diagonal with eigenvalues +/-2i, 1 +/- 3i and 5, hidden by a
      // similarity transformation
      final blocks = RealMatrix.fromFlattenedData(
        rows: 5,
        columns: 5,
        data: const [
          0, -2, 0, 0, 0, //
          2, 0, 0, 0, 0, //
          0, 0, 1, -3, 0, //
          0, 0, 3, 1, 0, //
          0, 0, 0, 0, 5, //
        ],
      );
      final p =
          _randomReal(5, 5, Random(61)) +
          RealMatrix.diagonal(rows: 5, columns: 5, diagonalValue: 3);
      final matrix = p * blocks * p.inverse();

      final [v, d, inverseV] = EigendecompositionReal(
        matrix: matrix,
      ).decompose();
      expectRealMatrixClose(matrix * v, v * d);
      expectRealMatrixClose(v * d * inverseV, matrix);

      expectSameEigenvalues(
        matrix.eigenvalues(),
        const [
          Complex(0, 2),
          Complex(0, -2),
          Complex(1, 3),
          Complex(1, -3),
          Complex.fromReal(5),
        ],
      );
    });

    test('Similar and scaled matrices', () {
      final random = Random(62);
      final matrix = _randomReal(5, 5, random);
      final p =
          _randomReal(5, 5, random) +
          RealMatrix.diagonal(rows: 5, columns: 5, diagonalValue: 5);
      final eigenvalues = matrix.eigenvalues();

      expectSameEigenvalues(
        (p * matrix * p.inverse()).eigenvalues(),
        eigenvalues,
      );
      expectSameEigenvalues(
        RealMatrix.fromFlattenedData(
          rows: 5,
          columns: 5,
          data: matrix.flattenData.map((value) => value * -3).toList(),
        ).eigenvalues(),
        eigenvalues.map((value) => value * const Complex.fromReal(-3)).toList(),
      );
    });

    test('Repeated eigenvalues of diagonalizable matrices', () {
      // The eigenvalue 2 is repeated, but it has two independent eigenvectors
      final matrix = RealMatrix.fromFlattenedData(
        rows: 3,
        columns: 3,
        data: const [2, 0, 1, 0, 2, 1, 0, 0, 3],
      );
      final [v, d, inverseV] = EigendecompositionReal(
        matrix: matrix,
      ).decompose();

      expectRealMatrixClose(v * d * inverseV, matrix);
      expectSameEigenvalues(
        sortedEigenvalues(matrix),
        const [Complex.fromReal(2), Complex.fromReal(2), Complex.fromReal(3)],
      );
    });

    test('Ill-conditioned and large matrices', () {
      final hilbert = RealMatrix.fromFlattenedData(
        rows: 8,
        columns: 8,
        data: List<double>.generate(64, (k) => 1 / (k ~/ 8 + k % 8 + 1)),
      );
      final [_, d, _] = EigendecompositionReal(matrix: hilbert).decompose();

      // The Hilbert matrix is positive-definite: all the eigenvalues are
      // positive, even the tiny ones
      for (var i = 0; i < 8; i++) {
        expect(d(i, i), greaterThan(0));
      }

      final random = Random(63);
      final large = _randomReal(20, 20, random);
      final [v, largeD, _] = EigendecompositionReal(matrix: large).decompose();
      expectRealMatrixClose(large * v, v * largeD);
    });

    test('Defective matrices are rejected', () {
      final jordanBlocks = [
        RealMatrix.fromFlattenedData(
          rows: 2,
          columns: 2,
          data: const [1, 1, 0, 1],
        ),
        RealMatrix.fromFlattenedData(
          rows: 3,
          columns: 3,
          data: const [2, 1, 0, 0, 2, 1, 0, 0, 2],
        ),
      ];

      for (final matrix in jordanBlocks) {
        expect(
          EigendecompositionReal(matrix: matrix).decompose,
          throwsA(isA<MatrixException>()),
        );
      }
    });
  });
}
