import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_complex_decomposition.dart';
import 'package:test/test.dart';

import '../../../../double_approximation_matcher.dart';

import '../decomposition_checks.dart';

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

    test('Decomposition of a singular matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex(1, 1), Complex(2, 2)],
          [Complex(2, 2), Complex(4, 4)], // Linearly dependent column
        ],
      );

      final qr = QRDecompositionComplex(matrix: matrix).decompose();
      expectValidComplexQR(matrix, qr);

      // The rank deficiency shows up as a zero on the diagonal of R
      expect(qr[1](1, 1).abs(), lessThan(1e-12));
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

      final qr = QRDecompositionComplex(matrix: matrix).decompose();
      expectValidComplexQR(matrix, qr);
      expect(qr[0].isIdentity(), isTrue);
      expect(qr[1].isZero(), isTrue);
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

    test('Decomposition of matrices with genuinely complex values', () {
      final random = Random(11);

      for (final (rows, columns) in const [(3, 3), (6, 4), (4, 6), (1, 3)]) {
        final matrix = ComplexMatrix.fromFlattenedData(
          rows: rows,
          columns: columns,
          data: List<Complex>.generate(
            rows * columns,
            (_) => Complex(
              random.nextDouble() * 2 - 1,
              random.nextDouble() * 2 - 1,
            ),
          ),
        );

        expectValidComplexQR(
          matrix,
          QRDecompositionComplex(matrix: matrix).decompose(),
        );
      }
    });

    test('Decomposition of data with a very small magnitude', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex(1e-12, 2e-12), Complex(3e-12, 0)],
          [Complex(0, -4e-12), Complex(5e-12, 6e-12)],
        ],
      );

      final [q, r] = QRDecompositionComplex(matrix: matrix).decompose();
      expectComplexMatrixClose(
        conjugateTranspose(q) * q,
        ComplexMatrix(rows: 2, columns: 2, identity: true),
      );

      // The tolerance must be relative to the data, which is very small
      final product = q * r;
      for (var i = 0; i < 4; i++) {
        final difference = product.flattenData[i] - matrix.flattenData[i];
        expect(difference.real.abs(), lessThan(1e-25));
        expect(difference.imaginary.abs(), lessThan(1e-25));
      }
    });

    test('Decomposition with zeros on the diagonal', () {
      final matrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex.zero(), Complex(1, 1), Complex.fromReal(2)],
          [Complex(0, 2), Complex.zero(), Complex.fromReal(1)],
          [Complex.fromReal(1), Complex(3, -1), Complex.zero()],
        ],
      );

      expectValidComplexQR(
        matrix,
        QRDecompositionComplex(matrix: matrix).decompose(),
      );
    });
  });

  group('QRDecompositionComplex edge cases', () {
    ComplexMatrix randomMatrix(int rows, int columns, Random random) =>
        ComplexMatrix.fromFlattenedData(
          rows: rows,
          columns: columns,
          data: List<Complex>.generate(
            rows * columns,
            (_) => Complex(
              random.nextDouble() * 2 - 1,
              random.nextDouble() * 2 - 1,
            ),
          ),
        );

    test('Real-valued input gives the same result of the real QR', () {
      final random = Random(30);
      final real = RealMatrix.fromFlattenedData(
        rows: 5,
        columns: 3,
        data: List<double>.generate(15, (_) => random.nextDouble() * 2 - 1),
      );
      final complex = ComplexMatrix.fromFlattenedData(
        rows: 5,
        columns: 3,
        data: real.flattenData.map(Complex.fromReal).toList(),
      );

      final realQR = real.qrDecomposition();
      final complexQR = complex.qrDecomposition();

      for (var m = 0; m < 2; m++) {
        expectComplexMatrixClose(
          complexQR[m],
          ComplexMatrix.fromFlattenedData(
            rows: realQR[m].rowCount,
            columns: realQR[m].columnCount,
            data: realQR[m].flattenData.map(Complex.fromReal).toList(),
          ),
        );
      }
    });

    test('Vectors and single elements', () {
      final element = ComplexMatrix.fromFlattenedData(
        rows: 1,
        columns: 1,
        data: const [Complex(3, -4)],
      );
      final [q, r] = element.qrDecomposition();
      expect(q(0, 0).abs(), const MoreOrLessEquals(1));
      expect(r(0, 0).abs(), const MoreOrLessEquals(5));

      final random = Random(31);
      for (final (rows, columns) in const [(1, 5), (5, 1)]) {
        final matrix = randomMatrix(rows, columns, random);
        expectValidComplexQR(matrix, matrix.qrDecomposition());
      }
    });

    test('Unitary matrices give a diagonal R with unit magnitudes', () {
      final [unitary, _] = randomMatrix(4, 4, Random(32)).qrDecomposition();
      final [_, r] = unitary.qrDecomposition();

      for (var i = 0; i < 4; i++) {
        for (var j = 0; j < 4; j++) {
          expect(r(i, j).abs(), MoreOrLessEquals(i == j ? 1 : 0));
        }
      }
    });

    test('The diagonal of R gives the magnitude of the determinant', () {
      final random = Random(33);

      for (var n = 1; n <= 6; n++) {
        final matrix = randomMatrix(n, n, random);
        final [_, r] = matrix.qrDecomposition();

        var product = 1.0;
        for (var i = 0; i < n; i++) {
          product *= r(i, i).abs();
        }

        expect(
          product,
          MoreOrLessEquals(matrix.determinant().abs(), precision: 1e-10),
        );
      }
    });

    test('Large matrices', () {
      final random = Random(34);

      for (final (rows, columns) in const [(40, 25), (25, 40)]) {
        final matrix = randomMatrix(rows, columns, random);
        expectValidComplexQR(matrix, matrix.qrDecomposition());
      }
    });

    test('Least squares solution of an overdetermined system', () {
      final random = Random(35);
      final a = randomMatrix(8, 3, random);
      final b = randomMatrix(8, 1, random);

      // x = R^-1 Q^H b minimizes |A x - b|, so A^H (A x - b) = 0
      final [q, r] = a.qrDecomposition();
      final x = r.inverse() * conjugateTranspose(q) * b;

      expectComplexMatrixClose(
        conjugateTranspose(a) * (a * x - b),
        ComplexMatrix(rows: 3, columns: 1),
      );
    });

    test('NaN and infinite values are rejected', () {
      for (final value in const [
        Complex(double.nan, 0),
        Complex(0, double.infinity),
      ]) {
        final matrix = ComplexMatrix.fromFlattenedData(
          rows: 1,
          columns: 2,
          data: [const Complex.fromReal(1), value],
        );

        expect(matrix.qrDecomposition, throwsA(isA<MatrixException>()));
      }
    });
  });
}
