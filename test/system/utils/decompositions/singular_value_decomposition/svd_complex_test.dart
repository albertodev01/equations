import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/singular_value_decomposition/svd_complex.dart';
import 'package:test/test.dart';

import '../../../../double_approximation_matcher.dart';
import '../decomposition_checks.dart';

/// Builds a [ComplexMatrix] whose elements are given row by row.
ComplexMatrix _matrix(List<List<Complex>> rows) => ComplexMatrix.fromData(
  rows: rows.length,
  columns: rows.first.length,
  data: rows,
);

/// Builds a [ComplexMatrix] with random elements in the unit square.
ComplexMatrix _random(int rows, int columns, Random random) =>
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
  group('SVDComplex class', () {
    test('Equality tests', () {
      final svd1 = SVDComplex(
        matrix: _matrix(const [
          [Complex.fromReal(1)],
        ]),
      );
      final svd2 = SVDComplex(
        matrix: _matrix(const [
          [Complex.fromReal(1)],
        ]),
      );

      expect(svd1, equals(svd2));
      expect(svd1.hashCode, equals(svd2.hashCode));
    });

    test('Empty matrices cannot be created', () {
      expect(
        () => SVDComplex(
          matrix: ComplexMatrix.fromData(
            rows: 0,
            columns: 0,
            data: const [],
          ),
        ).decompose(),
        throwsA(isA<MatrixException>()),
      );
    });

    test('1x1 matrix decomposition', () {
      final matrix = _matrix(const [
        [Complex.fromReal(5)],
      ]);

      final svd = SVDComplex(matrix: matrix).decompose();
      expect(svd.length, equals(3));
      expect(svd[0](0, 0), equals(const Complex.fromReal(5)));
      expect(svd[1](0, 0), equals(const Complex.fromReal(1)));
      expect(svd[2](0, 0), equals(const Complex.fromReal(1)));
    });

    test('The singular value of a complex 1x1 matrix is its magnitude', () {
      final matrix = _matrix(const [
        [Complex(3, -4)],
      ]);

      final singularValues = expectValidComplexSVD(
        matrix,
        SVDComplex(matrix: matrix).decompose(),
      );
      expect(singularValues.single, const MoreOrLessEquals(5));
    });

    final matrices = <String, ComplexMatrix>{
      '2x2 with complex values': _matrix(const [
        [Complex.i(), Complex.fromReal(2)],
        [Complex(7, 1), Complex.fromReal(6)],
      ]),
      '3x2 with complex values': _matrix(const [
        [Complex(1, 1), Complex(2, -1)],
        [Complex(3, 2), Complex(4, -2)],
        [Complex(5, 3), Complex(6, -3)],
      ]),
      'very small values': _matrix(const [
        [Complex(1e-10, 1e-12), Complex(1e-14, 1e-16)],
        [Complex(1e-18, 1e-20), Complex(1e-22, 1e-24)],
      ]),
      'symmetric (not Hermitian)': _matrix(const [
        [Complex(1, 1), Complex(2, -1), Complex(3, 2)],
        [Complex(2, -1), Complex(4, 2), Complex(5, -2)],
        [Complex(3, 2), Complex(5, -2), Complex(6, 3)],
      ]),
      'pure imaginary values': _matrix(const [
        [Complex.i(), Complex(0, 2)],
        [Complex(0, 3), Complex(0, 4)],
      ]),
      'mixed real and imaginary values': _matrix(const [
        [Complex(1, 2), Complex(3, 4)],
        [Complex(5, 6), Complex(7, 8)],
      ]),
      'rank deficient wide matrix': _matrix(const [
        [Complex(1, 0), Complex(1, 0), Complex(1e-15, 0), Complex(1e-15, 0)],
        [Complex(1, 0), Complex(1, 0), Complex(1e-15, 0), Complex(1e-15, 0)],
        [Complex(1, 0), Complex(1, 0), Complex(1e-15, 0), Complex(1e-15, 0)],
      ]),
      'very small singular value': _matrix(const [
        [Complex(1, 0), Complex.zero(), Complex.zero(), Complex(1e-12, 0)],
        [Complex.zero(), Complex(1, 0), Complex.zero(), Complex(1e-12, 0)],
        [Complex.zero(), Complex.zero(), Complex(1, 0), Complex(1e-12, 0)],
        [Complex.zero(), Complex.zero(), Complex.zero(), Complex(1e-12, 0)],
      ]),
      'wide matrix': _matrix(const [
        [Complex(1, 0), Complex(2, 0), Complex(3, 0), Complex(4, 0)],
        [Complex(5, 0), Complex(6, 0), Complex(7, 0), Complex(8, 0)],
      ]),
      'tall matrix': _matrix(const [
        [Complex(1, 0), Complex(2, 0)],
        [Complex(3, 0), Complex(4, 0)],
        [Complex(5, 0), Complex(6, 0)],
        [Complex(7, 0), Complex(8, 0)],
      ]),
      'tridiagonal 5x5': ComplexMatrix.fromFlattenedData(
        rows: 5,
        columns: 5,
        data: List<Complex>.generate(25, (k) {
          final distance = (k ~/ 5 - k % 5).abs();

          if (distance == 0) {
            return const Complex.fromReal(10);
          }

          return distance == 1
              ? const Complex.fromReal(1)
              : const Complex.zero();
        }),
      ),
      'first column with zero complex norm': _matrix(const [
        [Complex.fromReal(1), Complex.fromReal(2)],
        [Complex.i(), Complex.fromReal(3)],
      ]),
      'diagonal': _matrix(const [
        [Complex.fromReal(1), Complex.zero(), Complex.zero()],
        [Complex.zero(), Complex.fromReal(2), Complex.zero()],
        [Complex.zero(), Complex.zero(), Complex.fromReal(3)],
      ]),
    };

    for (final MapEntry(key: name, value: matrix) in matrices.entries) {
      test('Valid decomposition: $name', () {
        expectValidComplexSVD(matrix, SVDComplex(matrix: matrix).decompose());
      });
    }

    test('Random matrices of different shapes', () {
      final random = Random(42);

      for (final (rows, columns) in const [(6, 6), (9, 4), (4, 9), (1, 5)]) {
        final matrix = _random(rows, columns, random);
        expectValidComplexSVD(matrix, SVDComplex(matrix: matrix).decompose());
      }
    });

    test('Known singular values', () {
      // All the rows are equal to (1 + i, 1 + i, 1 + i): the matrix has rank 1
      // and its only non-zero singular value is 3 x |1 + i| = 3 sqrt(2).
      final repeated = ComplexMatrix.fromFlattenedData(
        rows: 3,
        columns: 3,
        data: List<Complex>.filled(9, const Complex(1, 1)),
      );
      final repeatedValues = expectValidComplexSVD(
        repeated,
        SVDComplex(matrix: repeated).decompose(),
      );
      expect(repeatedValues.first, MoreOrLessEquals(3 * sqrt(2)));
      expect(repeatedValues[1], const MoreOrLessEquals(0));
      expect(repeatedValues[2], const MoreOrLessEquals(0));

      final diagonal = matrices['diagonal']!;
      final diagonalValues = expectValidComplexSVD(
        diagonal,
        diagonal.singleValueDecomposition(),
      );
      expect(diagonalValues.first, const MoreOrLessEquals(3));
      expect(diagonalValues[1], const MoreOrLessEquals(2));
      expect(diagonalValues[2], const MoreOrLessEquals(1));
    });

    test('Zero matrix', () {
      final matrix = ComplexMatrix(rows: 2, columns: 3);
      final svd = matrix.singleValueDecomposition();

      expect(expectValidComplexSVD(matrix, svd), everyElement(isZero));
    });

    test('Data with very large and very small magnitudes', () {
      final random = Random(7);

      for (final scale in const [1e-200, 1e200]) {
        final unit = _random(4, 3, random);
        final scaled = ComplexMatrix.fromFlattenedData(
          rows: 4,
          columns: 3,
          data: unit.flattenData
              .map(
                (value) => Complex(value.real * scale, value.imaginary * scale),
              )
              .toList(),
        );

        // Comparing the singular values at unit scale avoids overflows.
        final scaledValues = SVDComplex(matrix: scaled).decompose().first;
        final unitValues = expectValidComplexSVD(
          unit,
          SVDComplex(matrix: unit).decompose(),
        );
        for (var i = 0; i < 3; i++) {
          expect(
            scaledValues(i, i).real / scale,
            MoreOrLessEquals(unitValues[i]),
          );
        }
      }
    });

    test('NaN and infinite values are rejected', () {
      for (final value in const [
        Complex(double.nan, 0),
        Complex(0, double.infinity),
      ]) {
        final matrix = _matrix([
          [value, const Complex.zero()],
          [const Complex.zero(), const Complex.fromReal(1)],
        ]);

        expect(
          matrix.singleValueDecomposition,
          throwsA(isA<MatrixException>()),
        );
      }
    });
  });

  group('SVDComplex edge cases', () {
    List<double> singularValues(ComplexMatrix matrix) =>
        expectValidComplexSVD(matrix, SVDComplex(matrix: matrix).decompose());

    test(
      'Real-valued input gives the same singular values of the real SVD',
      () {
        final random = Random(50);
        final real = RealMatrix.fromFlattenedData(
          rows: 5,
          columns: 4,
          data: List<double>.generate(20, (_) => random.nextDouble() * 2 - 1),
        );
        final complexValues = singularValues(
          ComplexMatrix.fromFlattenedData(
            rows: 5,
            columns: 4,
            data: real.flattenData.map(Complex.fromReal).toList(),
          ),
        );
        final [realE, _, _] = real.singleValueDecomposition();

        for (var i = 0; i < 4; i++) {
          expect(complexValues[i], MoreOrLessEquals(realE(i, i)));
        }
      },
    );

    test('Singular values are invariant under unitary transformations', () {
      final random = Random(51);
      final matrix = _random(4, 3, random);
      final [unitary, _] = _random(4, 4, random).qrDecomposition();

      final values = singularValues(matrix);
      final transformedValues = singularValues(unitary * matrix);
      final unitaryValues = singularValues(unitary);

      for (var i = 0; i < 3; i++) {
        expect(transformedValues[i], MoreOrLessEquals(values[i]));
      }
      for (final value in unitaryValues) {
        expect(value, const MoreOrLessEquals(1));
      }
    });

    test('Norm identities', () {
      final random = Random(52);
      final matrix = _random(3, 5, random);
      final values = singularValues(matrix);

      final frobenius = matrix.flattenData.fold<double>(
        0,
        (sum, value) =>
            sum + value.real * value.real + value.imaginary * value.imaginary,
      );
      expect(
        values.fold<double>(0, (sum, value) => sum + value * value),
        MoreOrLessEquals(frobenius),
      );

      // The conjugate transpose and complex multiples (|3 - 4i| = 5)
      final conjugateValues = singularValues(conjugateTranspose(matrix));
      final scaledValues = singularValues(
        ComplexMatrix.fromFlattenedData(
          rows: 3,
          columns: 5,
          data: matrix.flattenData
              .map((value) => value * const Complex(3, -4))
              .toList(),
        ),
      );
      for (var i = 0; i < 3; i++) {
        expect(conjugateValues[i], MoreOrLessEquals(values[i]));
        expect(scaledValues[i], MoreOrLessEquals(5 * values[i]));
      }
    });

    test('The number of non-zero singular values is the rank', () {
      final random = Random(53);

      for (var rank = 1; rank <= 4; rank++) {
        final matrix = _random(6, rank, random) * _random(rank, 5, random);
        final values = singularValues(matrix);

        expect(values.where((value) => value > 1e-12).length, equals(rank));
      }
    });

    test('Large square matrix', () {
      singularValues(_random(30, 30, Random(54)));
    });
  });
}
