import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_real_decomposition.dart';
import 'package:test/test.dart';

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
}
