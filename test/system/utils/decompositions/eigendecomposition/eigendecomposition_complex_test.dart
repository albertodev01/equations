import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/eigenvalue_decomposition/eigendecomposition_complex.dart';
import 'package:test/test.dart';

import '../../../../double_approximation_matcher.dart';
import '../decomposition_checks.dart';

ComplexMatrix _randomComplex(int rows, int columns, Random random) =>
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

  group('EigendecompositionComplex properties', () {
    test('Random general and Hermitian matrices', () {
      final random = Random(6);

      for (var n = 1; n <= 8; n++) {
        final general = _randomComplex(n, n, random);
        final hermitian = general + conjugateTranspose(general);

        expectValidComplexEigendecomposition(
          general,
          EigendecompositionComplex(matrix: general).decompose(),
        );

        final eigenvalues = expectValidComplexEigendecomposition(
          hermitian,
          EigendecompositionComplex(matrix: hermitian).decompose(),
        );

        // Hermitian matrices have real eigenvalues, in ascending order
        for (var i = 0; i < n; i++) {
          expect(eigenvalues[i].imaginary, isZero);
          if (i > 0) {
            expect(
              eigenvalues[i].real,
              greaterThanOrEqualTo(eigenvalues[i - 1].real),
            );
          }
        }
      }
    });

    test('Hermitian matrices have a unitary eigenvector matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex.fromReal(2), Complex(1, -1), Complex(0, 2)],
          [Complex(1, 1), Complex.fromReal(3), Complex(1, 0)],
          [Complex(0, -2), Complex(1, 0), Complex.fromReal(-1)],
        ],
      );

      final [v, _, inverseV] = EigendecompositionComplex(
        matrix: matrix,
      ).decompose();
      expectComplexMatrixClose(inverseV, conjugateTranspose(v));
    });

    test('Real matrices with complex eigenvalues', () {
      // A rotation by 90 degrees: the eigenvalues are +i and -i
      final rotation = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.zero(), Complex.fromReal(-1)],
          [Complex.fromReal(1), Complex.zero()],
        ],
      );

      final eigenvalues = expectValidComplexEigendecomposition(
        rotation,
        EigendecompositionComplex(matrix: rotation).decompose(),
      )..sort((a, b) => a.imaginary.compareTo(b.imaginary));

      expect(eigenvalues.first.real, const MoreOrLessEquals(0));
      expect(eigenvalues.first.imaginary, const MoreOrLessEquals(-1));
      expect(eigenvalues.last.real, const MoreOrLessEquals(0));
      expect(eigenvalues.last.imaginary, const MoreOrLessEquals(1));
    });

    test('Cyclic permutation (eigenvalues are the roots of unity)', () {
      final matrix = ComplexMatrix.fromFlattenedData(
        rows: 6,
        columns: 6,
        data: List<Complex>.generate(36, (k) {
          final i = k ~/ 6;
          final j = k % 6;

          return (i == j + 1 || (i == 0 && j == 5))
              ? const Complex.fromReal(1)
              : const Complex.zero();
        }),
      );

      final eigenvalues = expectValidComplexEigendecomposition(
        matrix,
        EigendecompositionComplex(matrix: matrix).decompose(),
      );
      for (final eigenvalue in eigenvalues) {
        expect(eigenvalue.abs(), const MoreOrLessEquals(1));
      }
    });

    test('Zero and diagonal matrices', () {
      final zero = ComplexMatrix(rows: 3, columns: 3);
      final eigenvalues = expectValidComplexEigendecomposition(
        zero,
        EigendecompositionComplex(matrix: zero).decompose(),
      );
      expect(eigenvalues, everyElement(equals(const Complex.zero())));

      final diagonal = ComplexMatrix.diagonal(
        rows: 3,
        columns: 3,
        diagonalValue: const Complex(2, 1),
      );
      expectValidComplexEigendecomposition(
        diagonal,
        EigendecompositionComplex(matrix: diagonal).decompose(),
      );
    });

    test('Data with very large and very small magnitudes', () {
      final random = Random(8);

      for (final scale in const [1e-150, 1e150]) {
        final unit = _randomComplex(4, 4, random);
        final scaled = ComplexMatrix.fromFlattenedData(
          rows: 4,
          columns: 4,
          data: unit.flattenData
              .map(
                (value) => Complex(value.real * scale, value.imaginary * scale),
              )
              .toList(),
        );

        final unitEigenvalues = unit.eigenvalues()
          ..sort((a, b) => a.real.compareTo(b.real));
        final scaledEigenvalues = scaled.eigenvalues()
          ..sort((a, b) => a.real.compareTo(b.real));

        for (var i = 0; i < 4; i++) {
          expect(
            scaledEigenvalues[i].real / scale,
            MoreOrLessEquals(unitEigenvalues[i].real, precision: 1e-10),
          );
          expect(
            scaledEigenvalues[i].imaginary / scale,
            MoreOrLessEquals(unitEigenvalues[i].imaginary, precision: 1e-10),
          );
        }
      }
    });

    test('Defective matrices are rejected', () {
      final jordanBlock = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.fromReal(1), Complex.fromReal(1)],
          [Complex.zero(), Complex.fromReal(1)],
        ],
      );

      expect(
        EigendecompositionComplex(matrix: jordanBlock).decompose,
        throwsA(isA<MatrixException>()),
      );
    });

    test('Non-square matrices and NaN values are rejected', () {
      expect(
        EigendecompositionComplex(
          matrix: ComplexMatrix(rows: 2, columns: 3),
        ).decompose,
        throwsA(isA<MatrixException>()),
      );
      expect(
        EigendecompositionComplex(
          matrix: ComplexMatrix.fromData(
            rows: 1,
            columns: 1,
            data: const [
              [Complex(double.nan, 0)],
            ],
          ),
        ).decompose,
        throwsA(isA<MatrixException>()),
      );
    });

    test('Hessenberg reduction with a zero subdiagonal element', () {
      final matrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex.fromReal(1), Complex(2, 1), Complex.fromReal(3)],
          [Complex.zero(), Complex.fromReal(4), Complex(0, 1)],
          [Complex(1, -1), Complex.fromReal(5), Complex.fromReal(6)],
        ],
      );

      expectValidComplexEigendecomposition(
        matrix,
        EigendecompositionComplex(matrix: matrix).decompose(),
      );
    });

    test('Large defective matrices are rejected without overflows', () {
      // A 10x10 Jordan block: the back substitution for the eigenvectors of
      // the repeated eigenvalue grows quickly and must be rescaled
      final jordanBlock = ComplexMatrix.fromFlattenedData(
        rows: 10,
        columns: 10,
        data: List<Complex>.generate(100, (k) {
          final i = k ~/ 10;
          final j = k % 10;

          return (i == j || j == i + 1)
              ? const Complex(2, 1)
              : const Complex.zero();
        }),
      );

      expect(
        EigendecompositionComplex(matrix: jordanBlock).decompose,
        throwsA(isA<MatrixException>()),
      );
    });
  });

  group('EigendecompositionComplex edge cases', () {
    List<Complex> decompose(ComplexMatrix matrix) =>
        expectValidComplexEigendecomposition(
          matrix,
          EigendecompositionComplex(matrix: matrix).decompose(),
        );

    test('Eigenvalues of triangular matrices', () {
      final triangular = ComplexMatrix.fromFlattenedData(
        rows: 3,
        columns: 3,
        data: const [
          Complex(1, 2),
          Complex.fromReal(5),
          Complex(0, -1),
          Complex.zero(),
          Complex(-3, 0.5),
          Complex(2, 2),
          Complex.zero(),
          Complex.zero(),
          Complex(0, 4),
        ],
      );

      expectSameEigenvalues(decompose(triangular), const [
        Complex(1, 2),
        Complex(-3, 0.5),
        Complex(0, 4),
      ]);
    });

    test('Similar and scaled matrices', () {
      final random = Random(70);
      final matrix = _randomComplex(5, 5, random);
      final p =
          _randomComplex(5, 5, random) +
          ComplexMatrix.diagonal(
            rows: 5,
            columns: 5,
            diagonalValue: const Complex.fromReal(5),
          );
      final eigenvalues = decompose(matrix);

      expectSameEigenvalues(decompose(p * matrix * p.inverse()), eigenvalues);

      const factor = Complex(2, -1);
      expectSameEigenvalues(
        decompose(
          ComplexMatrix.fromFlattenedData(
            rows: 5,
            columns: 5,
            data: matrix.flattenData.map((value) => value * factor).toList(),
          ),
        ),
        eigenvalues.map((value) => value * factor).toList(),
      );
    });

    test('Skew-Hermitian and unitary matrices', () {
      final random = Random(71);
      final b = _randomComplex(4, 4, random);

      // A = B - B^H: the eigenvalues are purely imaginary
      for (final eigenvalue in decompose(b - conjugateTranspose(b))) {
        expect(eigenvalue.real, const MoreOrLessEquals(0, precision: 1e-10));
      }

      // The eigenvalues of a unitary matrix are on the unit circle
      final [unitary, _] = b.qrDecomposition();
      for (final eigenvalue in decompose(unitary)) {
        expect(eigenvalue.abs(), const MoreOrLessEquals(1, precision: 1e-10));
      }
    });

    test('Real-valued input gives the same eigenvalues of the real class', () {
      final random = Random(72);
      final real = RealMatrix.fromFlattenedData(
        rows: 5,
        columns: 5,
        data: List<double>.generate(25, (_) => random.nextDouble() * 2 - 1),
      );
      final complex = ComplexMatrix.fromFlattenedData(
        rows: 5,
        columns: 5,
        data: real.flattenData.map(Complex.fromReal).toList(),
      );

      expectSameEigenvalues(decompose(complex), real.eigenvalues());
    });

    test('Repeated eigenvalues of diagonalizable matrices', () {
      // The eigenvalue 2 + i is repeated, but it has two independent
      // eigenvectors
      final matrix = ComplexMatrix.fromFlattenedData(
        rows: 3,
        columns: 3,
        data: const [
          Complex(2, 1),
          Complex.zero(),
          Complex.fromReal(1),
          Complex.zero(),
          Complex(2, 1),
          Complex.i(),
          Complex.zero(),
          Complex.zero(),
          Complex.fromReal(3),
        ],
      );

      expectSameEigenvalues(decompose(matrix), const [
        Complex(2, 1),
        Complex(2, 1),
        Complex.fromReal(3),
      ]);
    });

    test('Large general and Hermitian matrices', () {
      final random = Random(73);
      final general = _randomComplex(25, 25, random);

      decompose(general);
      decompose(general + conjugateTranspose(general));
    });

    test('Defective matrices are rejected', () {
      final jordanBlock = ComplexMatrix.fromFlattenedData(
        rows: 3,
        columns: 3,
        data: const [
          Complex(1, 1),
          Complex.fromReal(1),
          Complex.zero(),
          Complex.zero(),
          Complex(1, 1),
          Complex.fromReal(1),
          Complex.zero(),
          Complex.zero(),
          Complex(1, 1),
        ],
      );

      expect(
        EigendecompositionComplex(matrix: jordanBlock).decompose,
        throwsA(isA<MatrixException>()),
      );
    });
  });
}
