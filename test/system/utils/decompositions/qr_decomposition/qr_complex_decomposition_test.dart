import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_complex_decomposition.dart';
import 'package:test/test.dart';

void main() {
  group('QRDecompositionComplex', () {
    test('Equality tests', () {
      final complex = QRDecompositionComplex(
        matrix: ComplexMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [Complex.i()],
          ],
        ),
      );

      expect(
        complex,
        equals(
          QRDecompositionComplex(
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
        QRDecompositionComplex(
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
          [Complex(2, 1)],
        ],
      );

      final qr = QRDecompositionComplex(matrix: matrix);
      final result = qr.decompose();

      expect(result.length, equals(2));
      expect(result[0].rowCount, equals(1));
      expect(result[0].columnCount, equals(1));
      expect(result[1].rowCount, equals(1));
      expect(result[1].columnCount, equals(1));

      // Verify Q*R = A
      final product = result[0] * result[1];
      expect(product(0, 0).real, closeTo(matrix(0, 0).real, 1e-10));
      expect(product(0, 0).imaginary, closeTo(matrix(0, 0).imaginary, 1e-10));
    });

    test('Decomposition of 2x2 matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex(1, 1), Complex(2, -1)],
          [Complex(3, 2), Complex(4, 0)],
        ],
      );

      final qr = QRDecompositionComplex(matrix: matrix);
      final result = qr.decompose();

      expect(result.length, equals(2));
      expect(result[0].rowCount, equals(2));
      expect(result[0].columnCount, equals(2));
      expect(result[1].rowCount, equals(2));
      expect(result[1].columnCount, equals(2));

      // Verify Q*R = A
      final product = result[0] * result[1];
      for (var i = 0; i < 2; i++) {
        for (var j = 0; j < 2; j++) {
          expect(
            product(i, j).real.round(),
            closeTo(matrix(i, j).real.round(), 1e-10),
          );
          expect(
            product(i, j).imaginary.round(),
            closeTo(matrix(i, j).imaginary.round(), 1e-10),
          );
        }
      }
    });

    test(
      'Decomposition of 3x2 matrix',
      () {
        final matrix = ComplexMatrix.fromData(
          rows: 3,
          columns: 2,
          data: const [
            [Complex(1, 1), Complex(2, -1)],
            [Complex(3, 2), Complex(4, 0)],
            [Complex(5, -1), Complex(6, 2)],
          ],
        );

        final qr = QRDecompositionComplex(matrix: matrix);
        final result = qr.decompose();

        expect(result.length, equals(2));
        expect(result[0].rowCount, equals(3));
        expect(result[0].columnCount, equals(2));
        expect(result[1].rowCount, equals(2));
        expect(result[1].columnCount, equals(2));

        // Verify Q*R = A
        final product = result[0] * result[1];
        for (var i = 0; i < 3; i++) {
          for (var j = 0; j < 2; j++) {
            expect(
              product(i, j).real.round(),
              closeTo(matrix(i, j).real.round(), 1e-10),
            );
            expect(
              product(i, j).imaginary.round(),
              closeTo(matrix(i, j).imaginary.round(), 1e-10),
            );
          }
        }
      },
      skip: true,
    );

    test('Throws on singular matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex(1, 1), Complex(2, 2)],
          [Complex(2, 2), Complex(4, 4)], // Linearly dependent column
        ],
      );

      final qr = QRDecompositionComplex(matrix: matrix);
      expect(qr.decompose, throwsA(isA<MatrixException>()));
    });

    test('Decomposition with zero matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.zero(), Complex.zero()],
          [Complex.zero(), Complex.zero()],
        ],
      );

      final qr = QRDecompositionComplex(matrix: matrix);
      expect(qr.decompose, throwsA(isA<MatrixException>()));
    });

    test('Decomposition with pure imaginary numbers', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.i(), Complex(0, 2)],
          [Complex(0, 3), Complex(0, 4)],
        ],
      );

      final qr = QRDecompositionComplex(matrix: matrix);
      final result = qr.decompose();

      expect(result.length, equals(2));
      expect(result[0].rowCount, equals(2));
      expect(result[0].columnCount, equals(2));
      expect(result[1].rowCount, equals(2));
      expect(result[1].columnCount, equals(2));

      // Verify Q*R = A
      final product = result[0] * result[1];
      for (var i = 0; i < 2; i++) {
        for (var j = 0; j < 2; j++) {
          expect(product(i, j).real, closeTo(matrix(i, j).real, 1e-10));
          expect(
            product(i, j).imaginary,
            closeTo(matrix(i, j).imaginary, 1e-10),
          );
        }
      }
    });

    test(
      'Decomposition with large real values to trigger aAbs > bAbs branch',
      () {
        final matrix = ComplexMatrix.fromData(
          rows: 4,
          columns: 2,
          data: const [
            [Complex(1000, 0), Complex(200, 0)],
            [Complex(1, 0), Complex(400, 0)],
            [Complex(1, 0), Complex(600, 0)],
            [Complex(1, 0), Complex(800, 0)],
          ],
        );

        final qr = QRDecompositionComplex(matrix: matrix);
        final result = qr.decompose();

        expect(result.length, equals(2));
        expect(result[0].rowCount, equals(4));
        expect(result[0].columnCount, equals(2));
        expect(result[1].rowCount, equals(2));
        expect(result[1].columnCount, equals(2));

        // Verify Q*R = A
        final product = result[0] * result[1];
        for (var i = 0; i < 4; i++) {
          for (var j = 0; j < 2; j++) {
            expect(
              product(i, j).real,
              closeTo(matrix(i, j).real, 1e-8),
            );
            expect(
              product(i, j).imaginary,
              closeTo(matrix(i, j).imaginary, 1e-8),
            );
          }
        }
      },
    );
  });
}
