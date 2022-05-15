import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_complex_decomposition.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_real_decomposition.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group('QRDecomposition class', () {
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

    group('Real values', () {
      test('Making sure that QRDecompositionReal works properly - Test 1', () {
        final sourceMatrix = RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: [
            [1, 2],
            [3, 4],
          ],
        );

        final realQR = QRDecompositionReal(
          matrix: sourceMatrix,
        );

        final results = realQR.decompose();
        final matrixQ = results.first;
        final matrixR = results[1];

        // Matrices must be square
        expect(matrixQ.isSquareMatrix, isTrue);
        expect(matrixR.isSquareMatrix, isTrue);

        // Testing Q
        expect(
          matrixQ(0, 0),
          const MoreOrLessEquals(-0.3162, precision: 1.0e-4),
        );
        expect(
          matrixQ(0, 1),
          const MoreOrLessEquals(0.9486, precision: 1.0e-4),
        );
        expect(
          matrixQ(1, 0),
          const MoreOrLessEquals(-0.9486, precision: 1.0e-4),
        );
        expect(
          matrixQ(1, 1),
          const MoreOrLessEquals(-0.3162, precision: 1.0e-4),
        );

        // Testing R
        expect(
          matrixR(0, 0),
          const MoreOrLessEquals(-3.1622, precision: 1.0e-4),
        );
        expect(
          matrixR(0, 1),
          const MoreOrLessEquals(-4.4271, precision: 1.0e-4),
        );
        expect(
          matrixR(1, 0),
          const MoreOrLessEquals(0, precision: 1.0e-4),
        );
        expect(
          matrixR(1, 1),
          const MoreOrLessEquals(0.6324, precision: 1.0e-4),
        );

        // Making sure that Q * R = A
        final matrixA = matrixQ * matrixR;
        expect(matrixA(0, 0), const MoreOrLessEquals(1, precision: 1.0e-1));
        expect(matrixA(0, 1), const MoreOrLessEquals(2, precision: 1.0e-1));
        expect(matrixA(1, 0), const MoreOrLessEquals(3, precision: 1.0e-1));
        expect(matrixA(1, 1), const MoreOrLessEquals(4, precision: 1.0e-1));

        // Smoke on the RealMatrix method
        expect(sourceMatrix.qrDecomposition(), orderedEquals(results));
        expect(sourceMatrix.toString(), equals(realQR.toString()));
      });

      test('Making sure that QRDecompositionReal works properly - Test 2', () {
        final realQR = QRDecompositionReal(
          matrix: RealMatrix.fromData(
            rows: 4,
            columns: 3,
            data: [
              [1, -1, 4],
              [1, 4, -2],
              [1, 4, 2],
              [1, -1, 0],
            ],
          ),
        );

        final results = realQR.decompose();
        final matrixQ = results.first;
        final matrixR = results[1];

        // Matrices must be square
        expect(matrixQ.rowCount, equals(4));
        expect(matrixQ.columnCount, equals(3));
        expect(matrixR.rowCount, equals(3));
        expect(matrixR.columnCount, equals(3));

        // Testing Q
        expect(matrixQ(0, 0), const MoreOrLessEquals(-0.5, precision: 0.1));
        expect(matrixQ(0, 1), const MoreOrLessEquals(0.5, precision: 0.1));
        expect(matrixQ(0, 2), const MoreOrLessEquals(-0.5, precision: 0.1));
        expect(matrixQ(1, 0), const MoreOrLessEquals(-0.5, precision: 0.1));
        expect(matrixQ(1, 1), const MoreOrLessEquals(-0.5, precision: 0.1));
        expect(matrixQ(1, 2), const MoreOrLessEquals(0.5, precision: 0.1));
        expect(matrixQ(2, 0), const MoreOrLessEquals(-0.5, precision: 0.1));
        expect(matrixQ(2, 1), const MoreOrLessEquals(-0.5, precision: 0.1));
        expect(matrixQ(2, 2), const MoreOrLessEquals(-0.5, precision: 0.1));
        expect(matrixQ(3, 0), const MoreOrLessEquals(-0.5, precision: 0.1));
        expect(matrixQ(3, 1), const MoreOrLessEquals(0.5, precision: 0.1));
        expect(matrixQ(3, 2), const MoreOrLessEquals(0.5, precision: 0.1));

        // Testing R
        expect(matrixR(0, 0), const MoreOrLessEquals(-2, precision: 0.1));
        expect(matrixR(0, 1), const MoreOrLessEquals(-3, precision: 0.1));
        expect(matrixR(0, 2), const MoreOrLessEquals(-2, precision: 0.1));
        expect(matrixR(1, 0), const MoreOrLessEquals(0, precision: 0.1));
        expect(matrixR(1, 1), const MoreOrLessEquals(-5, precision: 0.1));
        expect(matrixR(1, 2), const MoreOrLessEquals(2, precision: 0.1));
        expect(matrixR(2, 0), const MoreOrLessEquals(0, precision: 0.1));
        expect(matrixR(2, 1), const MoreOrLessEquals(0, precision: 0.1));
        expect(matrixR(2, 2), const MoreOrLessEquals(-4, precision: 0.1));

        final realMatrix = RealMatrix.fromData(
          rows: 4,
          columns: 3,
          data: [
            [1, -1, 4],
            [1, 4, -2],
            [1, 4, 2],
            [1, -1, 0],
          ],
        );

        expect(realMatrix.qrDecomposition(), orderedEquals(results));
      });
    });

    group('Complex values', () {
      test('Making sure that QRDecompositionComplex works properly', () {
        final sourceMatrix = ComplexMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [Complex.fromReal(1), Complex.i()],
            [Complex.fromReal(3), Complex.fromReal(4)],
          ],
        );

        final complexQR = QRDecompositionComplex(
          matrix: sourceMatrix,
        );

        final results = complexQR.decompose();
        final matrixQ = results.first;
        final matrixR = results[1];

        // Matrices must be square
        expect(matrixQ.isSquareMatrix, isTrue);
        expect(matrixR.isSquareMatrix, isTrue);

        // Testing Q
        expect(
          matrixQ(0, 0).real,
          const MoreOrLessEquals(-0.3162, precision: 1.0e-4),
        );
        expect(
          matrixQ(0, 1).real,
          const MoreOrLessEquals(0.9486, precision: 1.0e-4),
        );
        expect(
          matrixQ(1, 0).real,
          const MoreOrLessEquals(-0.9486, precision: 1.0e-4),
        );
        expect(
          matrixQ(1, 1).real,
          const MoreOrLessEquals(-0.3162, precision: 1.0e-4),
        );
        expect(
          matrixQ(0, 0).imaginary,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );
        expect(
          matrixQ(0, 1).imaginary,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );
        expect(
          matrixQ(1, 0).imaginary,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );
        expect(
          matrixQ(1, 1).imaginary,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );

        // Testing R
        expect(
          matrixR(0, 0).real,
          const MoreOrLessEquals(-3.1622, precision: 1.0e-4),
        );
        expect(
          matrixR(0, 1).real,
          const MoreOrLessEquals(-3.7947, precision: 1.0e-4),
        );
        expect(
          matrixR(1, 0).real,
          const MoreOrLessEquals(0, precision: 1.0e-4),
        );
        expect(
          matrixR(1, 1).real,
          const MoreOrLessEquals(-1.2649, precision: 1.0e-4),
        );
        expect(
          matrixR(0, 0).imaginary,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );
        expect(
          matrixR(0, 1).imaginary,
          const MoreOrLessEquals(-0.3162, precision: 1.0e-4),
        );
        expect(
          matrixR(1, 0).imaginary,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );
        expect(
          matrixR(1, 1).imaginary,
          const MoreOrLessEquals(0.9486, precision: 1.0e-4),
        );

        // Making sure that Q * R = A
        final matrixA = matrixQ * matrixR;
        expect(
          matrixA(0, 0).real,
          const MoreOrLessEquals(1, precision: 1.0e-1),
        );
        expect(
          matrixA(0, 1).real,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );
        expect(
          matrixA(1, 0).real,
          const MoreOrLessEquals(3, precision: 1.0e-1),
        );
        expect(
          matrixA(1, 1).real,
          const MoreOrLessEquals(4, precision: 1.0e-1),
        );
        expect(
          matrixA(0, 0).imaginary,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );
        expect(
          matrixA(0, 1).imaginary,
          const MoreOrLessEquals(1, precision: 1.0e-1),
        );
        expect(
          matrixA(1, 0).imaginary,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );
        expect(
          matrixA(1, 1).imaginary,
          const MoreOrLessEquals(0, precision: 1.0e-1),
        );

        final complexMatrix = ComplexMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [Complex.fromReal(1), Complex.i()],
            [Complex.fromReal(3), Complex.fromReal(4)],
          ],
        );

        expect(complexMatrix.qrDecomposition(), orderedEquals(results));
        expect(sourceMatrix.toString(), equals(complexQR.toString()));
      });
    });
  });
}
