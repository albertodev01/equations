import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_real_decomposition.dart';
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
  group('QRDecompositionReal', () {
    test('Equality tests', () {
      final real = QRDecompositionReal(
        matrix: RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: [
            [1],
          ],
        ),
      );

      expect(
        QRDecompositionReal(
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
          QRDecompositionReal(
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
        QRDecompositionReal(
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

    test('1x1 matrix decomposition', () {
      final matrix = RealMatrix.fromData(
        rows: 1,
        columns: 1,
        data: [
          [2],
        ],
      );

      final qr = QRDecompositionReal(matrix: matrix);
      final result = qr.decompose();

      expect(result.length, equals(2));
      expect(result[0].rowCount, equals(1));
      expect(result[0].columnCount, equals(1));
      expect(result[1].rowCount, equals(1));
      expect(result[1].columnCount, equals(1));

      // Q should be orthogonal (Q^T * Q = I)
      final qTq = result[0].transpose() * result[0];
      expect(qTq(0, 0), closeTo(1, 1e-10));
    });

    test('2x2 matrix decomposition', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [1, 2],
          [3, 4],
        ],
      );

      final qr = QRDecompositionReal(matrix: matrix);
      final result = qr.decompose();

      expect(result.length, equals(2));
      expect(result[0].rowCount, equals(2));
      expect(result[0].columnCount, equals(2));
      expect(result[1].rowCount, equals(2));
      expect(result[1].columnCount, equals(2));

      // Q should be orthogonal (Q^T * Q = I)
      final qTq = result[0].transpose() * result[0];
      expect(qTq(0, 0), closeTo(1, 1e-10));
      expect(qTq(0, 1), closeTo(0, 1e-10));
      expect(qTq(1, 0), closeTo(0, 1e-10));
      expect(qTq(1, 1), closeTo(1, 1e-10));

      // R should be upper triangular
      expect(result[1](1, 0), closeTo(0, 1e-10));

      // Verify A = QR
      final reconstructed = result[0] * result[1];
      expect(reconstructed(0, 0), closeTo(matrix(0, 0), 1e-10));
      expect(reconstructed(0, 1), closeTo(matrix(0, 1), 1e-10));
      expect(reconstructed(1, 0), closeTo(matrix(1, 0), 1e-10));
      expect(reconstructed(1, 1), closeTo(matrix(1, 1), 1e-10));
    });

    test('3x3 matrix decomposition', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ],
      );

      final qr = QRDecompositionReal(matrix: matrix);
      final result = qr.decompose();

      expect(result.length, equals(2));
      expect(result[0].rowCount, equals(3));
      expect(result[0].columnCount, equals(3));
      expect(result[1].rowCount, equals(3));
      expect(result[1].columnCount, equals(3));

      // Q should be orthogonal (Q^T * Q = I)
      final qTq = result[0].transpose() * result[0];
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
          expect(qTq(i, j), closeTo(i == j ? 1 : 0, 1e-10));
        }
      }

      // R should be upper triangular
      for (var i = 1; i < 3; i++) {
        for (var j = 0; j < i; j++) {
          expect(result[1](i, j), closeTo(0, 1e-10));
        }
      }

      // Verify A = QR
      final reconstructed = result[0] * result[1];
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
          expect(reconstructed(i, j), closeTo(matrix(i, j), 1e-10));
        }
      }
    });

    test('Matrix with zero column', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [0, 1],
          [0, 2],
        ],
      );

      final qr = QRDecompositionReal(matrix: matrix);
      final result = qr.decompose();

      // Verify A = QR
      final reconstructed = result[0] * result[1];
      expect(reconstructed(0, 0), closeTo(matrix(0, 0), 1e-10));
      expect(reconstructed(0, 1), closeTo(matrix(0, 1), 1e-10));
      expect(reconstructed(1, 0), closeTo(matrix(1, 0), 1e-10));
      expect(reconstructed(1, 1), closeTo(matrix(1, 1), 1e-10));
    });

    test('Matrix with negative values', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [-1, -2],
          [-3, -4],
        ],
      );

      final qr = QRDecompositionReal(matrix: matrix);
      final result = qr.decompose();

      // Verify A = QR
      final reconstructed = result[0] * result[1];
      expect(reconstructed(0, 0), closeTo(matrix(0, 0), 1e-10));
      expect(reconstructed(0, 1), closeTo(matrix(0, 1), 1e-10));
      expect(reconstructed(1, 0), closeTo(matrix(1, 0), 1e-10));
      expect(reconstructed(1, 1), closeTo(matrix(1, 1), 1e-10));
    });
  });

  group('QRDecompositionReal regressions', () {
    test('Square, tall and wide matrices', () {
      final random = Random(1);

      for (final (rows, columns) in const [(4, 4), (7, 3), (3, 7), (1, 4)]) {
        final matrix = _randomReal(rows, columns, random);
        expectValidRealQR(
          matrix,
          QRDecompositionReal(matrix: matrix).decompose(),
        );
      }
    });

    test('Rank deficient and zero matrices', () {
      final singular = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 2, 3],
          [2, 4, 6],
          [1, 1, 1],
        ],
      );
      expectValidRealQR(singular, singular.qrDecomposition());

      final zero = RealMatrix(rows: 3, columns: 2);
      final qr = zero.qrDecomposition();
      expectValidRealQR(zero, qr);
      expect(qr[1].isZero(), isTrue);
    });

    test('The result does not depend on the scale of the data', () {
      final unit = _randomReal(3, 3, Random(2));
      final scaled = RealMatrix.fromFlattenedData(
        rows: 3,
        columns: 3,
        data: unit.flattenData.map((value) => value * 1e-12).toList(),
      );

      final [q, r] = QRDecompositionReal(matrix: scaled).decompose();
      final [unitQ, unitR] = QRDecompositionReal(matrix: unit).decompose();

      expectRealMatrixClose(q, unitQ);
      expectRealMatrixClose(
        RealMatrix.fromFlattenedData(
          rows: 3,
          columns: 3,
          data: r.flattenData.map((value) => value * 1e12).toList(),
        ),
        unitR,
      );
    });
  });

  group('QRDecompositionReal edge cases', () {
    test('Equality depends on the matrix and on the decomposition', () {
      final matrix = RealMatrix(rows: 2, columns: 2, identity: true);

      expect(
        QRDecompositionReal(matrix: matrix),
        isNot(
          equals(QRDecompositionReal(matrix: RealMatrix(rows: 2, columns: 2))),
        ),
      );
      expect(
        QRDecompositionReal(matrix: matrix),
        isNot(equals(SVDReal(matrix: matrix))),
      );
    });

    test('Vectors and single elements', () {
      final element = RealMatrix.fromFlattenedData(
        rows: 1,
        columns: 1,
        data: const [-3],
      );
      final [q1, r1] = element.qrDecomposition();
      expect(q1(0, 0).abs(), equals(1));
      expect(r1(0, 0).abs(), equals(3));
      expectValidRealQR(element, [q1, r1]);

      final row = RealMatrix.fromFlattenedData(
        rows: 1,
        columns: 4,
        data: const [1, -2, 3, -4],
      );
      expectValidRealQR(row, row.qrDecomposition());

      // The single element of R is the norm of the column (up to the sign)
      final column = row.transpose();
      final [_, r] = column.qrDecomposition();
      expect(r(0, 0).abs(), MoreOrLessEquals(sqrt(30)));
      expectValidRealQR(column, column.qrDecomposition());
    });

    test('Already triangular and orthogonal matrices', () {
      final triangular = RealMatrix.fromFlattenedData(
        rows: 3,
        columns: 3,
        data: const [2, -1, 3, 0, 4, 5, 0, 0, -6],
      );
      final [q, r] = triangular.qrDecomposition();

      // Q is diagonal with +/-1 elements and |R| = |A|
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
          expect(q(i, j).abs(), MoreOrLessEquals(i == j ? 1 : 0));
          expect(r(i, j).abs(), MoreOrLessEquals(triangular(i, j).abs()));
        }
      }

      // A rotation is orthogonal: R is diagonal with +/-1 elements
      const angle = pi / 7;
      final rotation = RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: [cos(angle), -sin(angle), sin(angle), cos(angle)],
      );
      final [_, rotationR] = rotation.qrDecomposition();
      expect(rotationR(0, 0).abs(), const MoreOrLessEquals(1));
      expect(rotationR(0, 1), const MoreOrLessEquals(0));
      expect(rotationR(1, 1).abs(), const MoreOrLessEquals(1));
    });

    test('The diagonal of R gives the absolute value of the determinant', () {
      final random = Random(20);

      for (var n = 1; n <= 6; n++) {
        final matrix = _randomReal(n, n, random);
        final [_, r] = matrix.qrDecomposition();

        var product = 1.0;
        for (var i = 0; i < n; i++) {
          product *= r(i, i);
        }

        expect(
          product.abs(),
          MoreOrLessEquals(matrix.determinant().abs(), precision: 1e-10),
        );
      }
    });

    test('Ill-conditioned, large and partially zero matrices', () {
      final hilbert = RealMatrix.fromFlattenedData(
        rows: 8,
        columns: 8,
        data: List<double>.generate(64, (k) => 1 / (k ~/ 8 + k % 8 + 1)),
      );
      expectValidRealQR(hilbert, hilbert.qrDecomposition());

      final random = Random(21);
      final tall = _randomReal(60, 35, random);
      final wide = _randomReal(35, 60, random);
      expectValidRealQR(tall, tall.qrDecomposition());
      expectValidRealQR(wide, wide.qrDecomposition());

      // The middle column is zero
      final zeroColumn = RealMatrix.fromFlattenedData(
        rows: 3,
        columns: 3,
        data: const [1, 0, 2, 3, 0, 4, 5, 0, 7],
      );
      final qr = zeroColumn.qrDecomposition();
      expectValidRealQR(zeroColumn, qr);
      expect(qr[1](1, 1), isZero);
    });

    test('Least squares solution of an overdetermined system', () {
      final random = Random(22);
      final a = _randomReal(8, 3, random);
      final b = _randomReal(8, 1, random);

      // x = R^-1 Q^T b minimizes |A x - b|, so the residual is orthogonal to
      // the columns of A
      final [q, r] = a.qrDecomposition();
      final x = r.inverse() * q.transpose() * b;

      expectRealMatrixClose(
        a.transpose() * (a * x - b),
        RealMatrix(rows: 3, columns: 1),
      );
    });

    test('NaN and infinite values are rejected', () {
      for (final value in const [double.nan, double.infinity]) {
        final matrix = RealMatrix.fromFlattenedData(
          rows: 2,
          columns: 2,
          data: [1, value, 3, 4],
        );

        expect(matrix.qrDecomposition, throwsA(isA<MatrixException>()));
      }
    });
  });
}
