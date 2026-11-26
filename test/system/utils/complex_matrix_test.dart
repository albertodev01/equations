import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/eigenvalue_decomposition/eigendecomposition_complex.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_complex_decomposition.dart';
import 'package:equations/src/system/utils/matrix/decompositions/singular_value_decomposition/svd_complex.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';
import 'decompositions/decomposition_checks.dart';

void main() {
  group('ComplexMatrix', () {
    test('Smoke test', () {
      final matrix = ComplexMatrix(columns: 5, rows: 3);

      expect(matrix.rowCount, equals(3));
      expect(matrix.columnCount, equals(5));
      expect(matrix.isSquareMatrix, isFalse);

      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          expect(matrix(i, j), equals(const Complex.zero()));
          expect(matrix(i, j), equals(matrix.itemAt(i, j)));
        }
      }
    });

    test('Exception thrown for zero row/column count', () {
      expect(
        () => ComplexMatrix(columns: 0, rows: 2),
        throwsA(isA<MatrixException>()),
      );
    });

    test('Matrix flattened to list of double values', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex(1, 2), Complex(3, 4)],
          [Complex(5, 6), Complex(7, 8)],
        ],
      );

      // Checking the sizes
      final flattenedMatrix = matrix.toList();

      expect(flattenedMatrix.length, equals(4));
      expect(
        flattenedMatrix,
        orderedEquals(const <Complex>[
          Complex(1, 2),
          Complex(3, 4),
          Complex(5, 6),
          Complex(7, 8),
        ]),
      );
    });

    test('Matrix created from flattened list', () {
      final matrix = ComplexMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: const [
          Complex(1, 2),
          Complex(3, 4),
          Complex(5, 6),
          Complex(7, 8),
        ],
      );

      expect(matrix.rowCount * matrix.columnCount, equals(4));
      expect(
        matrix,
        equals(
          ComplexMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [Complex(1, 2), Complex(3, 4)],
              [Complex(5, 6), Complex(7, 8)],
            ],
          ),
        ),
      );
    });

    test('Diagonal square matrix built with given value', () {
      final matrix = ComplexMatrix.diagonal(
        rows: 3,
        columns: 3,
        diagonalValue: const Complex(6, 2),
      );

      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          if (i == j) {
            expect(matrix(i, j), equals(const Complex(6, 2)));
          } else {
            expect(matrix(i, j), equals(const Complex.zero()));
          }
        }
      }

      const stringRepresentation =
          '[6 + 2i, 0, 0]\n'
          '[0, 6 + 2i, 0]\n'
          '[0, 0, 6 + 2i]';

      expect('$matrix', equals(stringRepresentation));
    });

    test('Diagonal non-square matrix built with given value', () {
      final matrix = ComplexMatrix.diagonal(
        rows: 3,
        columns: 5,
        diagonalValue: const Complex(6, 2),
      );

      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          if (i == j) {
            expect(matrix(i, j), equals(const Complex(6, 2)));
          } else {
            expect(matrix(i, j), equals(const Complex.zero()));
          }
        }
      }

      const stringRepresentation =
          '[6 + 2i, 0, 0, 0, 0]\n'
          '[0, 6 + 2i, 0, 0, 0]\n'
          '[0, 0, 6 + 2i, 0, 0]';

      expect('$matrix', equals(stringRepresentation));
    });

    test('Diagonal non-square matrix built with given value', () {
      final matrix = ComplexMatrix.diagonal(
        rows: 6,
        columns: 2,
        diagonalValue: const Complex(6, 2),
      );

      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          if (i == j) {
            expect(matrix(i, j), equals(const Complex(6, 2)));
          } else {
            expect(matrix(i, j), equals(const Complex.zero()));
          }
        }
      }

      const stringRepresentation =
          '[6 + 2i, 0]\n'
          '[0, 6 + 2i]\n'
          '[0, 0]\n'
          '[0, 0]\n'
          '[0, 0]\n'
          '[0, 0]';

      expect('$matrix', equals(stringRepresentation));
    });

    test('Single element diagonal', () {
      final matrix = RealMatrix.diagonal(
        rows: 1,
        columns: 1,
        diagonalValue: 31,
      );

      expect(matrix(0, 0), equals(31));
      expect('$matrix', equals('[31.0]'));
    });

    test('Exception thrown for wrong list sizes', () {
      expect(
        () => ComplexMatrix.fromFlattenedData(
          rows: 2,
          columns: 2,
          data: const [Complex(1, 2), Complex(1, 1)],
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Identity matrix filled with zeros except diagonal ones', () {
      final matrix = ComplexMatrix(columns: 3, rows: 3, identity: true);

      // Checking the sizes
      expect(matrix.rowCount, equals(3));
      expect(matrix.columnCount, equals(3));

      // Checking the content of the matrix
      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          if (i == j) {
            expect(matrix(i, j), equals(const Complex(1, 0)));
          } else {
            expect(matrix(i, j), equals(const Complex.zero()));
          }
          expect(matrix(i, j), equals(matrix.itemAt(i, j)));
        }
      }
    });

    test('Exception thrown for non-square identity matrix', () {
      expect(
        () => ComplexMatrix(columns: 3, rows: 5, identity: true),
        throwsA(isA<MatrixException>()),
      );
    });

    test('toString() works as expected', () {
      final matrix = ComplexMatrix.fromData(
        columns: 2,
        rows: 2,
        data: const [
          [Complex(1, 2), Complex(3, 4)],
          [Complex(5, 6), Complex(6, 7)],
        ],
      );

      const expected = '[1 + 2i, 3 + 4i]\n[5 + 6i, 6 + 7i]';
      expect(matrix.toString(), equals(expected));
    });

    test('Matrix built from list of lists', () {
      final matrix = ComplexMatrix.fromData(
        columns: 2,
        rows: 2,
        data: const [
          [Complex(1, 2), Complex(3, 4)],
          [Complex(5, 6), Complex(7, 8)],
        ],
      );

      // Checking the sizes
      expect(matrix.rowCount, equals(2));
      expect(matrix.columnCount, equals(2));

      // Checking the content of the matrix
      expect(matrix(0, 0), equals(const Complex(1, 2)));
      expect(matrix(0, 1), equals(const Complex(3, 4)));
      expect(matrix(1, 0), equals(const Complex(5, 6)));
      expect(matrix(1, 1), equals(const Complex(7, 8)));
    });
  });

  test('Equality test', () {
    final matrix = ComplexMatrix(columns: 2, rows: 2);

    // Equality tests
    expect(ComplexMatrix(columns: 2, rows: 2), equals(matrix));
    expect(matrix, equals(ComplexMatrix(columns: 2, rows: 2)));
    expect(ComplexMatrix(columns: 2, rows: 2) == matrix, isTrue);
    expect(matrix == ComplexMatrix(columns: 2, rows: 2), isTrue);
    expect(
      ComplexMatrix(columns: 2, rows: 2).hashCode,
      equals(matrix.hashCode),
    );

    // Inequality tests
    expect(
      ComplexMatrix(columns: 2, rows: 2, identity: true) == matrix,
      isFalse,
    );
    expect(
      ComplexMatrix(columns: 2, rows: 1).hashCode == matrix.hashCode,
      isFalse,
    );
    expect(
      matrix == ComplexMatrix(columns: 2, rows: 2, identity: true),
      isFalse,
    );
    expect(
      ComplexMatrix(columns: 2, rows: 1).hashCode == matrix.hashCode,
      isFalse,
    );
  });

  group('Operators', () {
    /*
    * A = |    i   3-8i  |
    *     | 4+7i   0     |
    * */
    final matrixA = ComplexMatrix.fromData(
      columns: 2,
      rows: 2,
      data: const [
        [Complex.i(), Complex(3, -8)],
        [Complex(4, 7), Complex.zero()],
      ],
    );

    /*
    * B = |   5   -7+i  |
    *     |  6i    1+i  |
    * */
    final matrixB = ComplexMatrix.fromData(
      columns: 2,
      rows: 2,
      data: const [
        [Complex.fromReal(5), Complex(-7, 1)],
        [Complex.fromImaginary(6), Complex(1, 1)],
      ],
    );

    test('operator+', () {
      final matrixSum = ComplexMatrix.fromData(
        columns: 2,
        rows: 2,
        data: const [
          [Complex(5, 1), Complex(-4, -7)],
          [Complex(4, 13), Complex(1, 1)],
        ],
      );
      expect(matrixA + matrixB, equals(matrixSum));
    });

    test('operator+ on rectangular matrices', () {
      final matrixA = ComplexMatrix.fromData(
        columns: 2,
        rows: 3,
        data: const [
          [Complex.i(), Complex.fromReal(-1)],
          [Complex(4, -1), Complex.fromReal(9)],
          [Complex(5, 2), Complex(6, -3)],
        ],
      );

      final matrixB = ComplexMatrix.fromData(
        columns: 2,
        rows: 3,
        data: const [
          [Complex.fromReal(3), Complex.fromImaginary(4)],
          [Complex.fromImaginary(-1), Complex.fromReal(5)],
          [Complex(2, 2), Complex(2, -2)],
        ],
      );

      expect(
        matrixA + matrixB,
        equals(
          ComplexMatrix.fromData(
            columns: 2,
            rows: 3,
            data: const [
              [Complex(3, 1), Complex(-1, 4)],
              [Complex(4, -2), Complex.fromReal(14)],
              [Complex(7, 4), Complex(8, -5)],
            ],
          ),
        ),
      );
    });

    test('operator-', () {
      final matrixSub = ComplexMatrix.fromData(
        columns: 2,
        rows: 2,
        data: const [
          [Complex(-5, 1), Complex(10, -9)],
          [Complex(4, 1), Complex(-1, -1)],
        ],
      );
      expect(matrixA - matrixB, equals(matrixSub));
    });

    test('operator- on rectangular matrices', () {
      final matrixA = ComplexMatrix.fromData(
        columns: 2,
        rows: 3,
        data: const [
          [Complex.i(), Complex.fromReal(-1)],
          [Complex(4, -1), Complex.fromReal(9)],
          [Complex(5, 2), Complex(6, -3)],
        ],
      );

      final matrixB = ComplexMatrix.fromData(
        columns: 2,
        rows: 3,
        data: const [
          [Complex.fromReal(3), Complex.fromImaginary(4)],
          [Complex.fromImaginary(-1), Complex.fromReal(5)],
          [Complex(2, 2), Complex(2, -2)],
        ],
      );

      expect(
        matrixA - matrixB,
        equals(
          ComplexMatrix.fromData(
            columns: 2,
            rows: 3,
            data: const [
              [Complex(-3, 1), Complex(-1, -4)],
              [Complex.fromReal(4), Complex.fromReal(4)],
              [Complex.fromReal(3), Complex(4, -1)],
            ],
          ),
        ),
      );
    });

    test('operator*', () {
      final matrixProd = ComplexMatrix.fromData(
        columns: 2,
        rows: 2,
        data: const [
          [Complex(48, 23), Complex(10, -12)],
          [Complex(20, 35), Complex(-35, -45)],
        ],
      );
      expect(matrixA * matrixB, equals(matrixProd));
    });

    test('operator* on rectangular matrices', () {
      final matrixA = ComplexMatrix.fromData(
        columns: 2,
        rows: 2,
        data: const [
          [Complex.fromReal(2), Complex.i()],
          [Complex(2, -3), Complex(5, 1)],
        ],
      );

      final matrixB = ComplexMatrix.fromData(
        columns: 3,
        rows: 2,
        data: const [
          [Complex(-1, -2), Complex.i(), Complex(2, 5)],
          [Complex.zero(), Complex(10, 1), Complex.fromImaginary(2)],
        ],
      );

      final matrixMul = ComplexMatrix.fromData(
        columns: 3,
        rows: 2,
        data: const [
          [Complex(-2, -4), Complex(-1, 12), Complex(2, 10)],
          [Complex(-8, -1), Complex(52, 17), Complex(17, 14)],
        ],
      );

      expect(matrixA * matrixB, equals(matrixMul));
    });

    test('operator/', () {
      final divResult = matrixA / matrixB;

      expect(divResult(0, 0), equals(const Complex(0, 1 / 5)));
      expect(divResult(1, 1), equals(const Complex.zero()));

      expect(
        divResult(1, 0).real,
        const MoreOrLessEquals(7 / 6, precision: 1.0e-3),
      );
      expect(
        divResult(1, 0).imaginary,
        const MoreOrLessEquals(-2 / 3, precision: 1.0e-3),
      );

      expect(
        divResult(0, 1).real,
        const MoreOrLessEquals(-29 / 50, precision: 1.0e-3),
      );
      expect(
        divResult(0, 1).imaginary,
        const MoreOrLessEquals(53 / 50, precision: 1.0e-3),
      );
    });

    test('operator/ on rectangular matrices', () {
      final matrixA = ComplexMatrix.fromData(
        columns: 2,
        rows: 3,
        data: const [
          [Complex.i(), Complex.fromReal(-1)],
          [Complex(4, -1), Complex.fromReal(9)],
          [Complex(5, 2), Complex(6, -3)],
        ],
      );

      final matrixB = ComplexMatrix.fromData(
        columns: 2,
        rows: 3,
        data: const [
          [Complex.fromReal(3), Complex.fromImaginary(4)],
          [Complex.fromImaginary(-1), Complex.fromReal(5)],
          [Complex(2, 2), Complex(2, -2)],
        ],
      );

      expect(
        matrixA / matrixB,
        equals(
          ComplexMatrix.fromData(
            columns: 2,
            rows: 3,
            data: const [
              [Complex.fromImaginary(1 / 3), Complex.fromImaginary(1 / 4)],
              [Complex(1, 4), Complex.fromReal(9 / 5)],
              [Complex(7 / 4, -3 / 4), Complex(9 / 4, 3 / 4)],
            ],
          ),
        ),
      );
    });

    test(
      'operator+, operator- and operator/ on different sized matrices',
      () {
        final otherMatrix = ComplexMatrix.fromFlattenedData(
          rows: 1,
          columns: 1,
          data: const [Complex.i()],
        );

        expect(() => matrixA + otherMatrix, throwsA(isA<MatrixException>()));

        expect(() => matrixA - otherMatrix, throwsA(isA<MatrixException>()));

        expect(() => matrixA / otherMatrix, throwsA(isA<MatrixException>()));
      },
    );

    test('operator* fails on non-matching sizes', () {
      final otherMatrix = ComplexMatrix.fromFlattenedData(
        rows: 1,
        columns: 2,
        data: const [Complex.i(), Complex(2, 1)],
      );

      expect(() => matrixA * otherMatrix, throwsA(isA<MatrixException>()));
    });
  });

  group('Determinant', () {
    test('Determinant of 1x1 matrix', () {
      final matrix = ComplexMatrix.fromData(
        columns: 1,
        rows: 1,
        data: const [
          [Complex(4, 7)],
        ],
      );
      expect(matrix.determinant(), equals(const Complex(4, 7)));
    });

    test('Determinant of 2x2 matrix', () {
      final matrix = ComplexMatrix.fromData(
        columns: 2,
        rows: 2,
        data: const [
          [Complex(48, 23), Complex(10, -12)],
          [Complex(20, 35), Complex(-35, -45)],
        ],
      );
      expect(matrix.determinant(), equals(const Complex(-1265, -3075)));
    });

    test('Determinant of 3x3 matrix', () {
      final matrix = ComplexMatrix.fromData(
        columns: 3,
        rows: 3,
        data: const [
          [Complex.i(), Complex(3, -8), Complex(3, -3)],
          [Complex(4, 7), Complex.zero(), Complex(2, -6)],
          [Complex(6, 1), Complex.zero(), Complex(5, 4)],
        ],
      );
      expect(matrix.determinant(), equals(const Complex(-602, -463)));
    });

    test('Determinant of 4x4 matrix', () {
      final matrix = ComplexMatrix.fromData(
        columns: 4,
        rows: 4,
        data: const [
          [Complex.i(), Complex(3, -8), Complex(3, -3), Complex.i()],
          [Complex(4, 7), Complex.zero(), Complex(2, -6), Complex.zero()],
          [Complex(6, 1), Complex.zero(), Complex(5, 4), Complex(1, 2)],
          [Complex(3, -2), Complex(5, 2), Complex(1, 3), Complex(6, -3)],
        ],
      );
      expect(matrix.determinant(), equals(const Complex(-5444, -802)));
    });

    test('Determinant of 5x5 matrix', () {
      final matrix = ComplexMatrix.fromData(
        columns: 5,
        rows: 5,
        data: const [
          [
            Complex.i(),
            Complex(3, -8),
            Complex(3, -3),
            Complex.i(),
            Complex(4, -4),
          ],
          [
            Complex(-4, 4),
            Complex(2, 9),
            Complex(4, 7),
            Complex(-2, 5),
            Complex(10, 2),
          ],
          [
            Complex(4, 7),
            Complex.zero(),
            Complex(6, 7),
            Complex(2, -6),
            Complex.zero(),
          ],
          [
            Complex(6, 1),
            Complex.i(),
            Complex.zero(),
            Complex(5, 4),
            Complex(1, 2),
          ],
          [
            Complex(3, -2),
            Complex(5, 2),
            Complex(1, 3),
            Complex(6, -3),
            Complex.fromReal(8),
          ],
        ],
      );

      final det = matrix.determinant();

      expect(det.real.round(), equals(33818));
      expect(det.imaginary.round(), equals(21240));
    });
  });

  group('API', () {
    test('LU decomposition on square matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex.fromReal(1), Complex.fromReal(2), Complex.fromReal(3)],
          [Complex.fromReal(4), Complex.fromReal(5), Complex.fromReal(6)],
          [Complex.fromReal(7), Complex.fromReal(8), Complex.fromReal(9)],
        ],
      );

      // Decomposition
      final lu = matrix.luDecomposition();
      expect(lu.length, equals(3));

      final L = lu.first;
      final U = lu[1];
      final P = lu[2];

      for (final m in lu) {
        expect(m.rowCount, equals(matrix.rowCount));
        expect(m.columnCount, equals(matrix.columnCount));
      }

      // L is lower triangular with ones on the diagonal, U is upper triangular
      for (var i = 0; i < 3; i++) {
        expect(L(i, i), equals(const Complex.fromReal(1)));
        for (var j = i + 1; j < 3; j++) {
          expect(L(i, j), equals(const Complex.zero()));
          expect(U(j, i), equals(const Complex.zero()));
        }
      }

      // Partial pivoting selects the row with the largest pivot first
      expect(
        P.flattenData,
        orderedEquals(const <Complex>[
          Complex.zero(),
          Complex.zero(),
          Complex.fromReal(1),
          Complex.fromReal(1),
          Complex.zero(),
          Complex.zero(),
          Complex.zero(),
          Complex.fromReal(1),
          Complex.zero(),
        ]),
      );

      // P x A = L x U
      final pA = P * matrix;
      final luMatrix = L * U;
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
          expect(
            pA(i, j).real,
            MoreOrLessEquals(luMatrix(i, j).real, precision: 1.0e-10),
          );
          expect(
            pA(i, j).imaginary,
            MoreOrLessEquals(luMatrix(i, j).imaginary, precision: 1.0e-10),
          );
        }
      }
    });

    test('LU decomposition fails on non-square matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [Complex.fromReal(1), Complex.fromReal(2), Complex.fromReal(3)],
          [Complex.fromReal(4), Complex.fromReal(5), Complex.fromReal(6)],
        ],
      );

      // Decomposition
      expect(matrix.luDecomposition, throwsA(isA<MatrixException>()));
    });

    test('Cholesky decomposition on square matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex.fromReal(25), Complex.fromReal(15), Complex.fromReal(-5)],
          [Complex.fromReal(15), Complex.fromReal(18), Complex.fromReal(0)],
          [Complex.fromReal(-5), Complex.fromReal(0), Complex.fromReal(11)],
        ],
      );

      // Decomposition
      final cholesky = matrix.choleskyDecomposition();
      expect(cholesky.length, equals(2));

      // Checking L
      final L = cholesky.first;
      expect(
        L.flattenData,
        orderedEquals(const <Complex>[
          Complex.fromReal(5),
          Complex.zero(),
          Complex.zero(),
          Complex.fromReal(3),
          Complex.fromReal(3),
          Complex.zero(),
          Complex.fromReal(-1),
          Complex.fromReal(1),
          Complex.fromReal(3),
        ]),
      );
      expect(L.rowCount, equals(matrix.rowCount));
      expect(L.columnCount, equals(matrix.columnCount));
      expect(L.isSquareMatrix, isTrue);

      // Checking Lt
      final transposedL = cholesky[1];
      expect(
        transposedL.flattenData,
        orderedEquals(const <Complex>[
          Complex.fromReal(5),
          Complex.fromReal(3),
          Complex.fromReal(-1),
          Complex.zero(),
          Complex.fromReal(3),
          Complex.fromReal(1),
          Complex.zero(),
          Complex.zero(),
          Complex.fromReal(3),
        ]),
      );
      expect(transposedL.rowCount, equals(matrix.rowCount));
      expect(transposedL.columnCount, equals(matrix.columnCount));
      expect(transposedL.isSquareMatrix, isTrue);
    });

    test('Cholesky decomposition fails on non-square matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 2,
        data: const [
          [Complex.fromReal(1), Complex.fromReal(2)],
          [Complex.fromReal(3), Complex.fromReal(4)],
          [Complex.fromReal(5), Complex.fromReal(6)],
        ],
      );

      // Decomposition
      expect(matrix.choleskyDecomposition, throwsA(isA<MatrixException>()));
    });

    test(
      'Cholesky decomposition on large matrix to trigger block processing',
      () {
        final data = <List<Complex>>[];
        for (var i = 0; i < 40; i++) {
          final row = <Complex>[];
          for (var j = 0; j < 40; j++) {
            if (i == j) {
              row.add(Complex.fromReal(40.0 + i));
            } else {
              row.add(const Complex.fromReal(0.1));
            }
          }
          data.add(row);
        }

        final matrix = ComplexMatrix.fromData(
          rows: 40,
          columns: 40,
          data: data,
        );

        final cholesky = matrix.choleskyDecomposition();
        expect(cholesky.length, equals(2));

        // Verify L * L^T = original matrix
        final L = cholesky[0];
        final lt = cholesky[1];
        final reconstructed = L * lt;

        for (var i = 0; i < 40; i++) {
          for (var j = 0; j < 40; j++) {
            expect(
              reconstructed(i, j).real,
              MoreOrLessEquals(matrix(i, j).real, precision: 1.0e-5),
            );
            expect(
              reconstructed(i, j).imaginary,
              MoreOrLessEquals(matrix(i, j).imaginary, precision: 1.0e-5),
            );
          }
        }
      },
    );

    test('qrDecomposition', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.fromReal(1), Complex.fromReal(2)],
          [Complex.fromReal(3), Complex.fromReal(4)],
        ],
      );

      expect(
        matrix.qrDecomposition(),
        orderedEquals(
          QRDecompositionComplex(matrix: matrix).decompose(),
        ),
      );
    });

    test('svdDecomposition', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.fromReal(1), Complex.fromReal(2)],
          [Complex.fromReal(3), Complex.fromReal(4)],
        ],
      );

      expect(
        matrix.singleValueDecomposition(),
        orderedEquals(
          SVDComplex(matrix: matrix).decompose(),
        ),
      );
    });

    test('eigenDecomposition', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.fromReal(1), Complex.fromReal(2)],
          [Complex.fromReal(3), Complex.fromReal(4)],
        ],
      );

      expect(
        matrix.eigenDecomposition(),
        orderedEquals(
          EigendecompositionComplex(matrix: matrix).decompose(),
        ),
      );
    });

    test('transposedValue', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.fromReal(1), Complex.fromReal(2)],
          [Complex.fromReal(3), Complex.fromReal(4)],
        ],
      );

      expect(matrix.transposedValue(0, 0), equals(const Complex.fromReal(1)));
      expect(matrix.transposedValue(0, 1), equals(const Complex.fromReal(3)));
      expect(matrix.transposedValue(1, 0), equals(const Complex.fromReal(2)));
      expect(matrix.transposedValue(1, 1), equals(const Complex.fromReal(4)));
    });

    test('Zero matrix multiplication optimization', () {
      final zeroMatrix1 = ComplexMatrix(rows: 2, columns: 3);
      final zeroMatrix2 = ComplexMatrix(rows: 3, columns: 2);
      final result = zeroMatrix1 * zeroMatrix2;

      expect(result.rowCount, equals(2));
      expect(result.columnCount, equals(2));
      expect(result.isZero(), isTrue);

      // Test with one zero matrix (first operand is zero)
      final nonZeroMatrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 2,
        data: const [
          [Complex.fromReal(1), Complex.fromReal(2)],
          [Complex.fromReal(3), Complex.fromReal(4)],
          [Complex.fromReal(5), Complex.fromReal(6)],
        ],
      );
      final result2 = zeroMatrix1 * nonZeroMatrix;
      expect(result2.isZero(), isTrue);

      // Test with one zero matrix (second operand is zero)
      final nonZeroMatrix2 = ComplexMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [Complex.fromReal(1), Complex.fromReal(2), Complex.fromReal(3)],
          [Complex.fromReal(4), Complex.fromReal(5), Complex.fromReal(6)],
        ],
      );
      final result3 = nonZeroMatrix2 * zeroMatrix2;
      expect(result3.isZero(), isTrue);
    });

    test('Transposed matrix is correct (2x2)', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.fromReal(1), Complex.fromReal(2)],
          [Complex.fromReal(3), Complex.fromReal(4)],
        ],
      );

      final transposed = matrix.transpose();

      expect(transposed(0, 0), equals(const Complex.fromReal(1)));
      expect(transposed(0, 1), equals(const Complex.fromReal(3)));
      expect(transposed(1, 0), equals(const Complex.fromReal(2)));
      expect(transposed(1, 1), equals(const Complex.fromReal(4)));
    });

    test('Transposed matrix is correct (1x3)', () {
      final matrix = ComplexMatrix.fromData(
        rows: 1,
        columns: 3,
        data: const [
          [Complex.i(), Complex(2, -5), Complex.zero()],
        ],
      );

      final transposed = matrix.transpose();
      expect(transposed(0, 0), equals(const Complex.i()));
      expect(transposed(1, 0), equals(const Complex(2, -5)));
      expect(transposed(2, 0), equals(const Complex.zero()));
    });

    test('Minors correctly generated', () {
      final matrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex(4, -5), Complex(-1, 10), Complex(3, 1)],
          [Complex.fromReal(3), Complex.i(), Complex.zero()],
          [Complex(2, 1), Complex.fromReal(6), Complex(-3, 7)],
        ],
      );

      // Removing (0; 0)
      final minor1 = matrix.minor(0, 0);
      expect(
        minor1.flattenData,
        orderedEquals(const [
          Complex.i(),
          Complex.zero(),
          Complex.fromReal(6),
          Complex(-3, 7),
        ]),
      );

      // Removing (1; 2)
      final minor2 = matrix.minor(1, 2);
      expect(
        minor2.flattenData,
        orderedEquals(const [
          Complex(4, -5),
          Complex(-1, 10),
          Complex(2, 1),
          Complex.fromReal(6),
        ]),
      );

      // Errors
      expect(() => matrix.minor(-1, 2), throwsA(isA<MatrixException>()));
      expect(() => matrix.minor(11, 2), throwsA(isA<MatrixException>()));
    });

    test('cofactorMatrix', () {
      final matrixSize2 = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex(4, -5), Complex(-1, 10)],
          [Complex.fromReal(3), Complex.i()],
        ],
      );

      final cofactorMatrixSize2 = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.i(), Complex.fromReal(-3)],
          [Complex(1, -10), Complex(4, -5)],
        ],
      );

      expect(matrixSize2.cofactorMatrix(), equals(cofactorMatrixSize2));

      final matrixSize3 = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex(4, -5), Complex(-1, 10), Complex(3, 1)],
          [Complex.fromReal(3), Complex.i(), Complex.zero()],
          [Complex(2, 1), Complex.fromReal(6), Complex(-3, 7)],
        ],
      );

      final cofactorMatrixSize3 = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex(-7, -3), Complex(9, -21), Complex(19, -2)],
          [Complex(85, 43), Complex(18, 38), Complex(-36, 49)],
          [Complex(1, -3), Complex(9, 3), Complex(8, -26)],
        ],
      );

      expect(matrixSize3.cofactorMatrix(), equals(cofactorMatrixSize3));
    });

    test('Cofactor matrix not computed for non-square matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 1,
        data: const [
          [Complex.i()],
          [Complex.fromImaginary(3)],
        ],
      );

      expect(matrix.cofactorMatrix, throwsA(isA<MatrixException>()));
    });

    test('Inverse matrix not computed for non-square matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 1,
        data: const [
          [Complex.i()],
          [Complex.fromImaginary(3)],
        ],
      );

      expect(matrix.inverse, throwsA(isA<MatrixException>()));
    });

    test('inverse of 2x2 matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.i(), Complex.fromReal(5)],
          [Complex.fromImaginary(-4), Complex(7, -6)],
        ],
      ).inverse();

      expect(
        matrix(0, 0).real,
        const MoreOrLessEquals(-0.1568, precision: 1.0e-4),
      );
      expect(
        matrix(0, 0).imaginary,
        const MoreOrLessEquals(-0.2941, precision: 1.0e-4),
      );
      expect(
        matrix(0, 1).real,
        const MoreOrLessEquals(-0.0392, precision: 1.0e-4),
      );
      expect(
        matrix(0, 1).imaginary,
        const MoreOrLessEquals(0.1764, precision: 1.0e-4),
      );
      expect(
        matrix(1, 0).real,
        const MoreOrLessEquals(0.1411, precision: 1.0e-4),
      );
      expect(
        matrix(1, 0).imaginary,
        const MoreOrLessEquals(0.0313, precision: 1.0e-4),
      );
      expect(
        matrix(1, 1).real,
        const MoreOrLessEquals(0.0352, precision: 1.0e-4),
      );
      expect(
        matrix(1, 1).imaginary,
        const MoreOrLessEquals(0.0078, precision: 1.0e-4),
      );
    });

    test('inverse', () {
      final matrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex.fromReal(2), Complex.fromReal(-1), Complex.fromReal(0)],
          [Complex.fromReal(4), Complex.fromReal(0), Complex.fromReal(7)],
          [Complex.fromReal(6), Complex.fromReal(1), Complex.fromReal(3)],
        ],
      ).inverse();

      expect(
        matrix(0, 0).real,
        const MoreOrLessEquals(0.159091, precision: 1.0e-6),
      );
      expect(matrix(0, 0).imaginary, isZero);
      expect(
        matrix(0, 1).real,
        const MoreOrLessEquals(-0.068181, precision: 1.0e-6),
      );
      expect(matrix(0, 1).imaginary, isZero);
      expect(
        matrix(0, 2).real,
        const MoreOrLessEquals(0.159091, precision: 1.0e-6),
      );
      expect(matrix(0, 2).imaginary, isZero);
      expect(
        matrix(1, 0).real,
        const MoreOrLessEquals(-0.681818, precision: 1.0e-6),
      );
      expect(matrix(1, 0).imaginary, isZero);
      expect(
        matrix(1, 1).real,
        const MoreOrLessEquals(-0.136364, precision: 1.0e-6),
      );
      expect(matrix(1, 1).imaginary, isZero);
      expect(
        matrix(1, 2).real,
        const MoreOrLessEquals(0.318182, precision: 1.0e-6),
      );
      expect(matrix(1, 2).imaginary, isZero);
      expect(
        matrix(2, 0).real,
        const MoreOrLessEquals(-0.090909, precision: 1.0e-6),
      );
      expect(matrix(2, 0).imaginary, isZero);
      expect(
        matrix(2, 1).real,
        const MoreOrLessEquals(0.181818, precision: 1.0e-6),
      );
      expect(matrix(2, 1).imaginary, isZero);
      expect(
        matrix(2, 2).real,
        const MoreOrLessEquals(-0.090909, precision: 1.0e-6),
      );
      expect(matrix(2, 2).imaginary, isZero);
    });

    test('trace', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.fromImaginary(3), Complex.fromReal(-2)],
          [Complex.fromReal(15), Complex(2, -8)],
        ],
      );

      expect(matrix.trace(), equals(const Complex(2, -5)));
    });

    test('isSymmetric', () {
      final symmetric = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex.fromReal(6), Complex(4, -5), Complex.i()],
          [Complex(4, -5), Complex.fromReal(41), Complex(-3, 5)],
          [Complex.i(), Complex(-3, 5), Complex.fromImaginary(3)],
        ],
      );

      expect(symmetric.isSymmetric(), isTrue);

      final notSymmetric = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex.fromReal(-6), Complex(4, -5), Complex.i()],
          [Complex(4, -5), Complex.fromReal(41), Complex(-3, 6)],
          [Complex.i(), Complex(-3, 5), Complex.fromImaginary(3)],
        ],
      );

      expect(notSymmetric.isSymmetric(), isFalse);
    });

    test('isDiagonal', () {
      final diagonal = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex.fromReal(6), Complex.zero(), Complex.zero()],
          [Complex.zero(), Complex.fromReal(41), Complex.zero()],
          [Complex.zero(), Complex.zero(), Complex.fromImaginary(3)],
        ],
      );

      expect(diagonal.isDiagonal(), isTrue);

      final stillDiagonal = ComplexMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [Complex.fromReal(6), Complex.zero(), Complex.zero()],
          [Complex.zero(), Complex.fromReal(41), Complex.zero()],
        ],
      );

      expect(stillDiagonal.isDiagonal(), isTrue);

      final notDiagonal = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex.fromReal(6), Complex.zero(), Complex.zero()],
          [Complex.zero(), Complex.fromReal(41), Complex.zero()],
          [Complex.i(), Complex.zero(), Complex.fromImaginary(3)],
        ],
      );

      expect(notDiagonal.isDiagonal(), isFalse);
    });

    test('isIdentity', () {
      final diagonal = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex.fromReal(1), Complex.zero(), Complex.zero()],
          [Complex.zero(), Complex.fromReal(1), Complex.zero()],
          [Complex.zero(), Complex.zero(), Complex.fromReal(1)],
        ],
      );

      expect(diagonal.isDiagonal(), isTrue);
      expect(diagonal.isIdentity(), isTrue);

      final notDiagonal = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex.fromReal(1), Complex.zero(), Complex.zero()],
          [Complex.zero(), Complex.fromReal(1), Complex.zero()],
          [Complex.zero(), Complex.zero(), Complex.fromReal(-1)],
        ],
      );

      expect(notDiagonal.isDiagonal(), isTrue);
      expect(notDiagonal.isIdentity(), isFalse);
    });

    test('Non-square matrices are never the identity', () {
      final identity = ComplexMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [Complex.fromReal(1), Complex.zero(), Complex.zero()],
          [Complex.zero(), Complex.fromReal(1), Complex.zero()],
        ],
      );

      expect(identity.isIdentity(), isFalse);
    });

    test('rank', () {
      final rank = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.fromReal(3), Complex(4, -6)],
          [Complex(2, -8), Complex.fromImaginary(2)],
        ],
      );

      expect(rank.rank(), equals(2));

      final singularRank = ComplexMatrix.fromData(
        rows: 1,
        columns: 1,
        data: const [
          [Complex.i()],
        ],
      );

      expect(singularRank.rank(), equals(1));

      final zeroRank = ComplexMatrix.fromData(
        rows: 1,
        columns: 1,
        data: const [
          [Complex.zero()],
        ],
      );

      expect(zeroRank.rank(), isZero);

      final rectangularRank1 = ComplexMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [Complex.fromReal(3), Complex.fromReal(-6), Complex.fromReal(5)],
          [Complex.fromReal(1), Complex.fromReal(9), Complex.zero()],
        ],
      );

      expect(rectangularRank1.rank(), equals(2));

      final rectangularRank2 = ComplexMatrix.fromData(
        rows: 3,
        columns: 1,
        data: const [
          [Complex.fromReal(3)],
          [Complex(3, -7)],
          [Complex(2, 3)],
        ],
      );

      expect(rectangularRank2.rank(), equals(1));
    });

    test('trace only computed on square matrices', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [Complex.fromImaginary(3), Complex.zero(), Complex.fromReal(-2)],
          [Complex.fromReal(15), Complex(2, -8), Complex.i()],
        ],
      );

      expect(matrix.trace, throwsA(isA<MatrixException>()));
    });

    test('eigenvalues for 1x1 matrices', () {
      final matrix = ComplexMatrix.fromData(
        rows: 1,
        columns: 1,
        data: const [
          [Complex.fromReal(-16)],
        ],
      );

      final eigenvalues = matrix.eigenvalues();

      expect(eigenvalues.length, equals(1));
      expect(eigenvalues.first, equals(const Complex.fromReal(-16)));
    });

    test('eigenvalues for 2x2 matrices', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex.i(), Complex.fromReal(2)],
          [Complex(3, -1), Complex.zero()],
        ],
      );

      final eigenvalues = matrix.eigenvalues();

      expect(eigenvalues.length, equals(2));
      expect(
        eigenvalues.first.real,
        const MoreOrLessEquals(2.4328, precision: 1.0e-4),
      );
      expect(
        eigenvalues[1].real,
        const MoreOrLessEquals(-2.4328, precision: 1.0e-4),
      );
      expect(
        eigenvalues.first.imaginary,
        const MoreOrLessEquals(0.0889, precision: 1.0e-4),
      );
      expect(
        eigenvalues[1].imaginary,
        const MoreOrLessEquals(0.911, precision: 1.0e-4),
      );
    });

    test('eigenvalues for 3x3 matrices', () {
      final matrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex.i(), Complex.fromReal(2), Complex.fromReal(-1)],
          [Complex(3, -1), Complex.zero(), Complex.fromImaginary(-1)],
          [Complex.zero(), Complex.zero(), Complex.fromReal(3)],
        ],
      );

      // The order of the eigenvalues is not specified
      final eigenvalues = matrix.eigenvalues()
        ..sort((a, b) => a.real.compareTo(b.real));

      expect(eigenvalues.length, equals(3));
      expect(
        eigenvalues.first.real,
        const MoreOrLessEquals(-2.4328, precision: 1.0e-4),
      );
      expect(
        eigenvalues[1].real,
        const MoreOrLessEquals(2.4328, precision: 1.0e-4),
      );
      expect(eigenvalues[2].real, const MoreOrLessEquals(3, precision: 1.0e-4));
      expect(
        eigenvalues.first.imaginary,
        const MoreOrLessEquals(0.911, precision: 1.0e-4),
      );
      expect(
        eigenvalues[1].imaginary,
        const MoreOrLessEquals(0.0889, precision: 1.0e-4),
      );
      expect(
        eigenvalues[2].imaginary,
        const MoreOrLessEquals(0, precision: 1.0e-10),
      );
    });

    test('minors', () {
      final source = [
        ComplexMatrix.fromData(
          rows: 3,
          columns: 4,
          data: const [
            [
              Complex.fromReal(2),
              Complex.fromReal(-1),
              Complex.fromReal(5),
              Complex.fromReal(9),
            ],
            [
              Complex.fromReal(-12),
              Complex.fromReal(3),
              Complex.fromReal(2),
              Complex.fromReal(0),
            ],
            [
              Complex.fromReal(1),
              Complex.fromReal(-1),
              Complex.fromReal(9),
              Complex.fromReal(8),
            ],
          ],
        ).minor(1, 2),
        ComplexMatrix.fromData(
          rows: 3,
          columns: 4,
          data: const [
            [
              Complex.fromReal(2),
              Complex.i(),
              Complex(-8, 3),
              Complex.fromReal(9),
            ],
            [Complex.zero(), Complex(4, 4), Complex.i(), Complex(9, -9)],
            [
              Complex.fromReal(1),
              Complex.i(),
              Complex(3, 5),
              Complex.fromReal(8),
            ],
          ],
        ).minor(2, 3),
        ComplexMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [Complex.i(), Complex(4, 5)],
            [Complex.fromReal(2), Complex.fromImaginary(-7)],
          ],
        ).minor(0, 1),
        ComplexMatrix.fromData(
          rows: 4,
          columns: 2,
          data: const [
            [Complex.i(), Complex.zero()],
            [Complex(6, 7), Complex.i()],
            [Complex.fromReal(2), Complex(3, -10)],
            [Complex.zero(), Complex(8, 1)],
          ],
        ).minor(2, 0),
      ];

      final minors = [
        ComplexMatrix.fromData(
          rows: 2,
          columns: 3,
          data: const [
            [Complex.fromReal(2), Complex.fromReal(-1), Complex.fromReal(9)],
            [Complex.fromReal(1), Complex.fromReal(-1), Complex.fromReal(8)],
          ],
        ),
        ComplexMatrix.fromData(
          rows: 2,
          columns: 3,
          data: const [
            [Complex.fromReal(2), Complex.i(), Complex(-8, 3)],
            [Complex.zero(), Complex(4, 4), Complex.i()],
          ],
        ),
        ComplexMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [Complex.fromReal(2)],
          ],
        ),
        ComplexMatrix.fromData(
          rows: 3,
          columns: 1,
          data: const [
            [Complex.zero()],
            [Complex.i()],
            [Complex(8, 1)],
          ],
        ),
      ];

      for (var i = 0; i < source.length; ++i) {
        expect(source[i], equals(minors[i]));
      }

      // Exception test
      expect(
        () => ComplexMatrix.fromData(
          rows: 2,
          columns: 1,
          data: const [
            [Complex(3, 7)],
            [Complex.fromImaginary(-9)],
          ],
        ).minor(1, 0),
        throwsA(isA<MatrixException>()),
      );
    });

    test('cofactorMatrix', () {
      final source = [
        ComplexMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [Complex.fromReal(1), Complex.fromReal(2), Complex.fromReal(3)],
            [Complex.fromReal(0), Complex.fromReal(4), Complex.fromReal(5)],
            [Complex.fromReal(1), Complex.fromReal(0), Complex.fromReal(6)],
          ],
        ).cofactorMatrix(),
        ComplexMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [Complex.i(), Complex(3, -7), Complex.zero()],
            [Complex(-5, 1), Complex(8, 10), Complex.fromImaginary(-5)],
            [Complex(2, 2), Complex.i(), Complex.fromReal(-2)],
          ],
        ).cofactorMatrix(),
        ComplexMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [Complex.fromReal(-3), Complex.fromReal(6)],
            [Complex.fromReal(7), Complex.fromReal(9)],
          ],
        ).cofactorMatrix(),
        ComplexMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [Complex(4, -7)],
          ],
        ).cofactorMatrix(),
      ];

      final cofactorMatrices = [
        ComplexMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [Complex.fromReal(24), Complex.fromReal(5), Complex.fromReal(-4)],
            [Complex.fromReal(-12), Complex.fromReal(3), Complex.fromReal(2)],
            [Complex.fromReal(-2), Complex.fromReal(-5), Complex.fromReal(4)],
          ],
        ),
        ComplexMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [Complex(-21, -20), Complex.fromImaginary(-8), Complex(3, -41)],
            [Complex(6, -14), Complex.fromImaginary(-2), Complex(21, -8)],
            [Complex(-35, -15), Complex.fromReal(-5), Complex(-2, -30)],
          ],
        ),
        ComplexMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [Complex.fromReal(9), Complex.fromReal(-7)],
            [Complex.fromReal(-6), Complex.fromReal(-3)],
          ],
        ),
        ComplexMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [Complex.fromReal(1)],
          ],
        ),
      ];

      for (var i = 0; i < source.length; ++i) {
        expect(source[i], equals(cofactorMatrices[i]));
      }
    });
    test('inverse', () {
      final source = [
        ComplexMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [Complex.i(), Complex.zero(), Complex.fromReal(-1)],
            [Complex.zero(), Complex.i(), Complex.fromReal(1)],
            [Complex(1, -1), Complex(0, -1), Complex(1, 1)],
          ],
        ).inverse(),
        ComplexMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [Complex.fromReal(4), Complex.fromReal(7)],
            [Complex.fromReal(2), Complex.fromReal(6)],
          ],
        ).inverse(),
        ComplexMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [Complex.fromReal(13)],
          ],
        ).inverse(),
        ComplexMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [Complex.i(), Complex.zero()],
            [Complex.zero(), Complex.i()],
          ],
        ).inverse(),
      ];

      final inverse = [
        ComplexMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [Complex(1, -2), Complex(0, -1), Complex(0, -1)],
            [Complex(-1, 1), Complex.zero(), Complex.i()],
            [Complex(1, 1), Complex.fromReal(1), Complex.fromReal(1)],
          ],
        ),
        ComplexMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [Complex.fromReal(0.6), Complex.fromReal(-0.7)],
            [Complex.fromReal(-0.2), Complex.fromReal(0.4)],
          ],
        ),
        ComplexMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [Complex.fromReal(1 / 13)],
          ],
        ),
        ComplexMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [Complex.fromImaginary(-1), Complex.zero()],
            [Complex.zero(), Complex.fromImaginary(-1)],
          ],
        ),
      ];

      for (var i = 0; i < source.length; ++i) {
        for (var j = 0; j < source[i].rowCount; ++j) {
          for (var k = 0; k < source[i].rowCount; ++k) {
            expect(
              source[i](j, k).real,
              MoreOrLessEquals(inverse[i](j, k).real, precision: 1.0e-2),
            );
            expect(
              source[i](j, k).imaginary,
              MoreOrLessEquals(inverse[i](j, k).imaginary, precision: 1.0e-2),
            );
          }
        }
      }
    });

    test('rank', () {
      final source = [
        ComplexMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [Complex.fromReal(3), Complex(9, 4), Complex.fromReal(2)],
            [Complex.fromReal(2), Complex(3, -2), Complex.fromReal(-2)],
            [Complex.fromReal(8), Complex.fromReal(1), Complex.fromReal(1)],
          ],
        ).rank(),
        ComplexMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [Complex(1, 3)],
          ],
        ).rank(),
        ComplexMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [Complex(2, -4), Complex.i()],
            [Complex(7, -9), Complex.zero()],
          ],
        ).rank(),
        ComplexMatrix.fromData(
          rows: 3,
          columns: 2,
          data: const [
            [Complex.fromReal(1), Complex.fromReal(6)],
            [Complex.fromReal(-2), Complex.fromReal(9)],
            [Complex.zero(), Complex.fromReal(1)],
          ],
        ).rank(),
        ComplexMatrix.fromData(
          rows: 3,
          columns: 2,
          data: const [
            [Complex(2, 2), Complex(6, 6)],
            [Complex(3, 3), Complex(9, 9)],
            [Complex(4, 4), Complex(12, 12)],
          ],
        ).rank(),
      ];

      final ranks = [3, 1, 2, 2, 1];

      for (var i = 0; i < source.length; ++i) {
        expect(source[i], equals(ranks[i]));
      }
    });

    test('characteristicPolynomial', () {
      final polynomials = [
        ComplexMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [Complex.fromReal(3), Complex(9, 4), Complex.fromReal(2)],
            [Complex.fromReal(2), Complex(3, -2), Complex.fromReal(-2)],
            [Complex.fromReal(8), Complex.fromReal(1), Complex.fromReal(1)],
          ],
        ).characteristicPolynomial(),
        ComplexMatrix.fromData(
          rows: 4,
          columns: 4,
          data: const [
            [
              Complex.fromReal(3),
              Complex(9, 4),
              Complex.fromReal(2),
              Complex.fromReal(2),
            ],
            [
              Complex.fromReal(2),
              Complex(3, -2),
              Complex.fromReal(-2),
              Complex.zero(),
            ],
            [
              Complex.fromReal(8),
              Complex.i(),
              Complex.fromReal(1),
              Complex(6, -1),
            ],
            [
              Complex(5, 3),
              Complex.zero(),
              Complex.fromReal(9),
              Complex.fromImaginary(4),
            ],
          ],
        ).characteristicPolynomial(),
        ComplexMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [Complex.fromReal(3), Complex(6, -4)],
            [Complex.i(), Complex.fromReal(2)],
          ],
        ).characteristicPolynomial(),
        ComplexMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [Complex.fromReal(14)],
          ],
        ).characteristicPolynomial(),
        ComplexMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [Complex.fromReal(3), Complex.fromReal(9)],
            [Complex.fromReal(-7), Complex.fromReal(2)],
          ],
        ).characteristicPolynomial(),
      ];

      final expectedSolutions = <Algebraic>[
        Algebraic.from([
          const Complex.fromReal(1),
          const Complex(-7, 2),
          const Complex(-17, -16),
          const Complex(191, 46),
        ]),
        Algebraic.from([
          const Complex.fromReal(1),
          const Complex(-7, -2),
          const Complex(-75, 17),
          const Complex(293, -72),
          const Complex(1898, -27),
        ]),
        Algebraic.from([
          const Complex.fromReal(1),
          const Complex.fromReal(-5),
          const Complex(2, -6),
        ]),
        Algebraic.from([
          const Complex.fromReal(1),
          -const Complex.fromReal(14),
        ]),
        Algebraic.from([
          const Complex.fromReal(1),
          -const Complex.fromReal(5),
          const Complex.fromReal(69),
        ]),
      ];

      for (var i = 0; i < polynomials.length; ++i) {
        expect(polynomials[i].degree, equals(expectedSolutions[i].degree));

        for (var j = 0; j < polynomials[i].coefficients.length; ++j) {
          expect(
            polynomials[i].coefficients[j].real,
            MoreOrLessEquals(
              expectedSolutions[i].coefficients[j].real,
              precision: 1.0e-3,
            ),
          );
          expect(
            polynomials[i].coefficients[j].imaginary,
            MoreOrLessEquals(
              expectedSolutions[i].coefficients[j].imaginary,
              precision: 1.0e-3,
            ),
          );
        }
      }
    });

    test('eigenvalues', () {
      final eigenvalues = [
        ComplexMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [Complex.fromReal(2), Complex(6, -1)],
            [Complex(5, 3), Complex.zero()],
          ],
        ).eigenvalues(),
        ComplexMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [Complex.fromReal(5), Complex.fromReal(8), Complex.fromReal(16)],
            [Complex.fromReal(4), Complex.fromReal(1), Complex.fromReal(8)],
            [Complex.fromReal(6), Complex.fromReal(-4), Complex.fromReal(-11)],
          ],
        ).eigenvalues(),
        ComplexMatrix.fromData(
          rows: 4,
          columns: 4,
          data: const [
            [
              Complex.fromReal(3),
              Complex(9, 4),
              Complex.fromReal(2),
              Complex.fromReal(2),
            ],
            [
              Complex.fromReal(2),
              Complex(3, -2),
              Complex.fromReal(-2),
              Complex.zero(),
            ],
            [
              Complex.fromReal(8),
              Complex.i(),
              Complex.fromReal(1),
              Complex(6, -1),
            ],
            [
              Complex(5, 3),
              Complex.zero(),
              Complex.fromReal(9),
              Complex.fromImaginary(4),
            ],
          ],
        ).eigenvalues(),
        ComplexMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [Complex(4, -2)],
          ],
        ).eigenvalues(),
        ComplexMatrix.fromData(
          rows: 2,
          columns: 2,
          data: [
            [const Complex.i(), -const Complex.i()],
            [const Complex.i(), const Complex.i()],
          ],
        ).eigenvalues(),
        ComplexMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [Complex(3, 5), Complex.i(), Complex(6, -8)],
            [Complex.i(), Complex.zero(), Complex.fromReal(3)],
            [Complex(6, -8), Complex.fromReal(3), Complex.fromReal(-8)],
          ],
        ).eigenvalues(),
      ];

      final expected = <List<Complex>>[
        const [Complex(6.9329, 1.0955), Complex(-4.9329, -1.0955)],
        const [
          Complex.fromReal(11.8062),
          Complex.fromReal(-13.8062),
          Complex.fromReal(-3),
        ],
        const [
          Complex(9.9301, 1.6185),
          Complex(-3.52, -1.1455),
          Complex(7.1789, -0.9473),
          Complex(-6.5891, 2.4743),
        ],
        const [Complex(4, -2)],
        const [Complex(1, 1), Complex(-1, 1)],
        const [
          Complex(-0.1837, -0.2127),
          Complex(3.6609, -3.0358),
          Complex(-8.4772, 8.2485),
        ],
      ];

      // The order of the eigenvalues is not specified
      int byRealPart(Complex a, Complex b) => a.real.compareTo(b.real);
      for (final values in eigenvalues) {
        values.sort(byRealPart);
      }
      final sortedExpected = expected
          .map((values) => [...values]..sort(byRealPart))
          .toList();

      for (var i = 0; i < eigenvalues.length; ++i) {
        for (var j = 0; j < expected[i].length; ++j) {
          expect(
            eigenvalues[i][j].real,
            MoreOrLessEquals(sortedExpected[i][j].real, precision: 1.0e-4),
          );
          expect(
            eigenvalues[i][j].imaginary,
            MoreOrLessEquals(sortedExpected[i][j].imaginary, precision: 1.0e-4),
          );
        }
      }
    });
  });

  group('Regressions', () {
    ComplexMatrix fromRealRows(List<List<double>> rows) =>
        ComplexMatrix.fromData(
          rows: rows.length,
          columns: rows.first.length,
          data: rows.map((row) => row.map(Complex.fromReal).toList()).toList(),
        );

    void expectClose(Complex actual, Complex expected) {
      expect(actual.real, MoreOrLessEquals(expected.real, precision: 1.0e-10));
      expect(
        actual.imaginary,
        MoreOrLessEquals(expected.imaginary, precision: 1.0e-10),
      );
    }

    void expectSameMatrix(ComplexMatrix actual, ComplexMatrix expected) {
      for (var i = 0; i < expected.rowCount; i++) {
        for (var j = 0; j < expected.columnCount; j++) {
          expectClose(actual(i, j), expected(i, j));
        }
      }
    }

    // A permutation matrix with a single swap: det = -1 and a zero in the
    // top-left corner, which requires pivoting.
    final swapped5x5 = fromRealRows(const [
      [0, 1, 0, 0, 0],
      [1, 0, 0, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 1, 0],
      [0, 0, 0, 0, 1],
    ]);

    final complex5x5 = ComplexMatrix.fromFlattenedData(
      rows: 5,
      columns: 5,
      data: List<Complex>.generate(25, (k) {
        final i = k ~/ 5;
        final j = k % 5;

        return i == j ? Complex(4, i.toDouble()) : Complex(1, (i - j) / 2);
      }),
    );

    test('Operators return a ComplexMatrix', () {
      final matrix = fromRealRows(const [
        [1, 2],
        [3, 4],
      ]);

      expect(matrix + matrix, isA<ComplexMatrix>());
      expect(matrix - matrix, isA<ComplexMatrix>());
      expect(matrix * matrix, isA<ComplexMatrix>());
      expect(matrix / matrix, isA<ComplexMatrix>());
    });

    test('Determinant of 5x5 matrices requires pivoting', () {
      expectClose(swapped5x5.determinant(), const Complex.fromReal(-1));
    });

    test('Determinant via LU matches the cofactor expansion', () {
      // Laplace expansion along the first row, using the 4x4 closed form
      var expected = const Complex.zero();
      for (var j = 0; j < 5; j++) {
        final term = complex5x5(0, j) * complex5x5.minor(0, j).determinant();
        expected = j.isEven ? expected + term : expected - term;
      }

      expectClose(complex5x5.determinant(), expected);
    });

    test('LU decomposition returns L, U and P', () {
      for (final matrix in [swapped5x5, complex5x5]) {
        final lu = matrix.luDecomposition();
        expect(lu.length, equals(3));
        expectSameMatrix(lu.first * lu[1], lu[2] * matrix);
      }
    });

    test('Inverse of big matrices', () {
      final identity = ComplexMatrix(rows: 5, columns: 5, identity: true);

      expectSameMatrix(complex5x5 * complex5x5.inverse(), identity);
      expectSameMatrix(swapped5x5 * swapped5x5.inverse(), identity);
    });

    test('Inverse of singular matrices throws', () {
      final singular2x2 = fromRealRows(const [
        [1, 2],
        [2, 4],
      ]);
      final singular3x3 = fromRealRows(const [
        [1, 2, 3],
        [2, 4, 6],
        [1, 1, 1],
      ]);

      expect(singular2x2.inverse, throwsA(isA<MatrixException>()));
      expect(singular3x3.inverse, throwsA(isA<MatrixException>()));
    });

    test('Rank of square matrices', () {
      final singular = fromRealRows(const [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ]);

      expect(singular.rank(), equals(2));
      expect(swapped5x5.rank(), equals(5));
      expect(complex5x5.rank(), equals(5));
    });

    test('Minor bounds are validated', () {
      final matrix = fromRealRows(const [
        [1, 2],
        [3, 4],
      ]);

      expect(() => matrix.minor(2, 0), throwsA(isA<MatrixException>()));
      expect(() => matrix.minor(0, 2), throwsA(isA<MatrixException>()));
    });

    test('Cholesky decomposition of a Hermitian matrix', () {
      final matrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex.fromReal(4), Complex(1, -2), Complex(0, 1)],
          [Complex(1, 2), Complex.fromReal(6), Complex(2, -1)],
          [Complex(0, -1), Complex(2, 1), Complex.fromReal(5)],
        ],
      );

      final cholesky = matrix.choleskyDecomposition();
      final L = cholesky.first;
      final conjugateTransposeL = cholesky[1];

      // The second factor is the conjugate transpose of the first one
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
          expect(conjugateTransposeL(i, j), equals(L(j, i).conjugate()));
        }
      }

      expectSameMatrix(L * conjugateTransposeL, matrix);
    });

    test('Cholesky decomposition rejects non-Hermitian diagonals', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [Complex(4, 1), Complex.zero()],
          [Complex.zero(), Complex.fromReal(4)],
        ],
      );

      expect(
        matrix.choleskyDecomposition,
        throwsA(isA<SystemSolverException>()),
      );
    });
  });

  group('Edge cases', () {
    /// A matrix with random elements in the square [-1, 1] x [-1, 1].
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

    /// A random, diagonally dominant (hence invertible) matrix.
    ComplexMatrix invertibleMatrix(int n, Random random) =>
        randomMatrix(n, n, random) +
        ComplexMatrix.diagonal(
          rows: n,
          columns: n,
          diagonalValue: Complex.fromReal(2.0 * n),
        );

    /// The [matrix] with every element multiplied by the real [factor].
    ComplexMatrix scaled(ComplexMatrix matrix, double factor) =>
        ComplexMatrix.fromFlattenedData(
          rows: matrix.rowCount,
          columns: matrix.columnCount,
          data: matrix.flattenData
              .map(
                (value) =>
                    Complex(value.real * factor, value.imaginary * factor),
              )
              .toList(),
        );

    /// Expects [actual] to be close to [expected], relative to its magnitude.
    void expectClose(
      Complex actual,
      Complex expected, [
      double tolerance = 1e-9,
    ]) {
      final precision = tolerance * max(1, expected.abs());
      expect(
        actual.real,
        MoreOrLessEquals(expected.real, precision: precision),
      );
      expect(
        actual.imaginary,
        MoreOrLessEquals(expected.imaginary, precision: precision),
      );
    }

    ComplexMatrix identity(int n) =>
        ComplexMatrix(rows: n, columns: n, identity: true);

    group('Data integrity', () {
      test('Constructors copy the source data', () {
        final flat = <Complex>[
          const Complex(1, 1),
          const Complex(2, 2),
          const Complex(3, 3),
          const Complex(4, 4),
        ];
        final rows = <List<Complex>>[
          [const Complex(1, 1), const Complex(2, 2)],
          [const Complex(3, 3), const Complex(4, 4)],
        ];
        final fromFlat = ComplexMatrix.fromFlattenedData(
          rows: 2,
          columns: 2,
          data: flat,
        );
        final fromRows = ComplexMatrix.fromData(
          rows: 2,
          columns: 2,
          data: rows,
        );

        flat[0] = const Complex.zero();
        rows.first[0] = const Complex.zero();

        expect(fromFlat(0, 0), equals(const Complex(1, 1)));
        expect(fromRows(0, 0), equals(const Complex(1, 1)));
      });

      test('The flattened data is read-only', () {
        final matrix = ComplexMatrix(rows: 2, columns: 2);

        expect(
          () => matrix.flattenData[0] = const Complex(1, 1),
          throwsUnsupportedError,
        );
      });

      test('Rows of different lengths are rejected', () {
        expect(
          () => ComplexMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [Complex(1, 1), Complex(2, 2), Complex(3, 3)],
              [Complex(4, 4)],
            ],
          ),
          throwsA(isA<MatrixException>()),
        );
      });

      test('Operators do not modify the operands', () {
        final random = Random(1);
        final a = invertibleMatrix(3, random);
        final b = invertibleMatrix(3, random);
        final copyA = ComplexMatrix.fromFlattenedData(
          rows: 3,
          columns: 3,
          data: a.toList(),
        );
        final copyB = ComplexMatrix.fromFlattenedData(
          rows: 3,
          columns: 3,
          data: b.toList(),
        );

        final results = <Object>[
          a + b,
          a - b,
          a * b,
          a / b,
          a.transpose(),
          a.inverse(),
          a.luDecomposition(),
          a.rank(),
          a.determinant(),
        ];

        expect(results, hasLength(9));
        expect(a, equals(copyA));
        expect(b, equals(copyB));
      });
    });

    group('Equality and hashing', () {
      test('Same data with a different shape is not equal', () {
        const data = <Complex>[
          Complex(1, 1),
          Complex(2, 2),
          Complex(3, 3),
          Complex(4, 4),
        ];
        final wide = ComplexMatrix.fromFlattenedData(
          rows: 1,
          columns: 4,
          data: data,
        );
        final square = ComplexMatrix.fromFlattenedData(
          rows: 2,
          columns: 2,
          data: data,
        );

        expect(wide, isNot(equals(square)));
        expect(wide.transpose(), isNot(equals(wide)));
      });

      test('Negative zeros are equal to positive zeros', () {
        // The sign of zero is what is being tested: this can't be an integer
        // literal, which would turn into a positive zero.
        const negativeZero = -0.0;

        final negative = ComplexMatrix.fromFlattenedData(
          rows: 1,
          columns: 2,
          data: const [
            Complex(negativeZero, negativeZero),
            Complex(1, negativeZero),
          ],
        );
        final positive = ComplexMatrix.fromFlattenedData(
          rows: 1,
          columns: 2,
          data: const [Complex.zero(), Complex.fromReal(1)],
        );

        expect(negative, equals(positive));
        expect(negative.hashCode, equals(positive.hashCode));
        expect(negative.isZero(), isFalse);
        expect(
          ComplexMatrix.fromFlattenedData(
            rows: 1,
            columns: 1,
            data: const [Complex(negativeZero, negativeZero)],
          ).isZero(),
          isTrue,
        );
      });

      test('Matrices containing NaN are only equal to themselves', () {
        // A constant NaN would be canonicalized into a single instance, which
        // is always identical (hence equal) to itself.
        ComplexMatrix nanMatrix() => ComplexMatrix.fromFlattenedData(
          rows: 1,
          columns: 1,
          data: [Complex(0, double.parse('NaN'))],
        );
        final matrix = nanMatrix();

        expect(matrix, equals(matrix));
        expect(matrix, isNot(equals(nanMatrix())));
      });
    });

    group('Indexing and formatting', () {
      test('Out of bounds indices throw', () {
        final matrix = ComplexMatrix(rows: 2, columns: 3);
        const invalid = [(-1, 0), (0, -1), (2, 0), (0, 3)];

        for (final (row, col) in invalid) {
          expect(() => matrix(row, col), throwsA(isA<MatrixException>()));
          expect(
            () => matrix.itemAt(row, col),
            throwsA(isA<MatrixException>()),
          );
        }

        // transposedValue(row, col) reads the element at (col, row)
        expect(matrix.transposedValue(2, 1), equals(const Complex.zero()));
        expect(
          () => matrix.transposedValue(1, 2),
          throwsA(isA<MatrixException>()),
        );
      });

      test('Single row and single column matrices', () {
        expect(
          ComplexMatrix.fromFlattenedData(
            rows: 1,
            columns: 2,
            data: const [Complex(3, -4), Complex.fromReal(5)],
          ).toString(),
          equals('[3 - 4i, 5]'),
        );
        expect(
          ComplexMatrix.fromFlattenedData(
            rows: 2,
            columns: 1,
            data: const [Complex.i(), Complex.zero()],
          ).toString(),
          equals('[1i]\n[0]'),
        );
      });
    });

    group('Arithmetic', () {
      test('Block multiplication matches the naive product', () {
        final random = Random(2);

        // The block size is 16: these shapes cross the block boundaries
        for (final (n, m, p) in const [
          (17, 18, 19),
          (33, 16, 40),
          (1, 20, 33),
        ]) {
          final a = randomMatrix(n, m, random);
          final b = randomMatrix(m, p, random);

          final expected = List<Complex>.generate(n * p, (index) {
            final i = index ~/ p;
            final j = index % p;
            var sum = const Complex.zero();
            for (var k = 0; k < m; k++) {
              sum += a(i, k) * b(k, j);
            }

            return sum;
          });

          expectComplexMatrixClose(
            a * b,
            ComplexMatrix.fromFlattenedData(
              rows: n,
              columns: p,
              data: expected,
            ),
          );
        }
      });

      test('Products with the identity, the zero matrix and vectors', () {
        final random = Random(3);
        final a = randomMatrix(3, 3, random);

        expect(a * identity(3), equals(a));
        expect(identity(3) * a, equals(a));
        expect((a * ComplexMatrix(rows: 3, columns: 2)).isZero(), isTrue);

        final row = ComplexMatrix.fromFlattenedData(
          rows: 1,
          columns: 2,
          data: const [Complex(1, 1), Complex.fromReal(2)],
        );
        final column = ComplexMatrix.fromFlattenedData(
          rows: 2,
          columns: 1,
          data: const [Complex(1, -1), Complex.i()],
        );

        // (1 + i)(1 - i) + 2i = 2 + 2i
        expect((row * column).flattenData.single, equals(const Complex(2, 2)));
      });

      test('Algebraic properties of the operators', () {
        final random = Random(4);
        final a = randomMatrix(3, 4, random);
        final b = randomMatrix(4, 2, random);
        final c = randomMatrix(2, 5, random);
        final d = randomMatrix(4, 2, random);

        expect((a - a).isZero(), isTrue);
        expectComplexMatrixClose((a * b) * c, a * (b * c));
        expectComplexMatrixClose(a * (b + d), a * b + a * d);
        expectComplexMatrixClose(
          (a * b).transpose(),
          b.transpose() * a.transpose(),
        );
        expectComplexMatrixClose(
          conjugateTranspose(a * b),
          conjugateTranspose(b) * conjugateTranspose(a),
        );
      });

      test('Element-wise division by zero gives NaN', () {
        final quotient =
            ComplexMatrix.fromFlattenedData(
              rows: 1,
              columns: 2,
              data: const [Complex(1, 2), Complex.zero()],
            ) /
            ComplexMatrix(rows: 1, columns: 2);

        for (final value in quotient.flattenData) {
          expect(value.real.isNaN, isTrue);
          expect(value.imaginary.isNaN, isTrue);
        }
      });
    });

    group('Determinant', () {
      test('The determinant is multiplicative', () {
        final random = Random(5);

        for (var n = 1; n <= 7; n++) {
          final a = randomMatrix(n, n, random);
          final b = randomMatrix(n, n, random);

          expectClose(
            (a * b).determinant(),
            a.determinant() * b.determinant(),
          );
        }
      });

      test('Transposing, conjugating, scaling and swapping rows', () {
        final random = Random(6);

        for (var n = 1; n <= 7; n++) {
          final a = randomMatrix(n, n, random);
          final determinant = a.determinant();

          expectClose(a.transpose().determinant(), determinant);
          expectClose(
            conjugateTranspose(a).determinant(),
            determinant.conjugate(),
          );

          // det(i A) = i^n det(A)
          final rotated = ComplexMatrix.fromFlattenedData(
            rows: n,
            columns: n,
            data: a.flattenData
                .map((value) => value * const Complex.i())
                .toList(),
          );
          var power = const Complex.fromReal(1);
          for (var i = 0; i < n; i++) {
            power *= const Complex.i();
          }
          expectClose(rotated.determinant(), power * determinant);

          if (n > 1) {
            // Swapping the first two rows flips the sign
            final rows = a.toListOfList();
            final first = rows.first;
            rows[0] = rows[1];
            rows[1] = first;

            expectClose(
              ComplexMatrix.fromData(
                rows: n,
                columns: n,
                data: rows,
              ).determinant(),
              -determinant,
            );
          }
        }
      });

      test('Triangular and Hermitian matrices', () {
        final random = Random(7);

        for (var n = 1; n <= 7; n++) {
          final triangular = ComplexMatrix.fromFlattenedData(
            rows: n,
            columns: n,
            data: List<Complex>.generate(
              n * n,
              (k) => k ~/ n <= k % n
                  ? Complex(random.nextDouble() + 0.5, random.nextDouble())
                  : const Complex.zero(),
            ),
          );

          var diagonalProduct = const Complex.fromReal(1);
          for (var i = 0; i < n; i++) {
            diagonalProduct *= triangular(i, i);
          }

          expectClose(triangular.determinant(), diagonalProduct);

          // The determinant of a Hermitian matrix is real
          final b = randomMatrix(n, n, random);
          final hermitian = b + conjugateTranspose(b);
          expect(
            hermitian.determinant().imaginary,
            MoreOrLessEquals(
              0,
              precision: 1e-9 * max(1, hermitian.determinant().abs()),
            ),
          );
        }
      });

      test('The 4x4 formula agrees with the Laplace expansion', () {
        final a = randomMatrix(4, 4, Random(8));
        var expansion = const Complex.zero();
        for (var j = 0; j < 4; j++) {
          final term = a(0, j) * a.minor(0, j).determinant();
          expansion = j.isEven ? expansion + term : expansion - term;
        }

        expectClose(a.determinant(), expansion);
      });
    });

    group('Inverse', () {
      test('Round trip for every algorithm (1x1, 2x2 and LU)', () {
        final random = Random(9);

        for (var n = 1; n <= 8; n++) {
          final a = invertibleMatrix(n, random);
          final inverse = a.inverse();

          expectComplexMatrixClose(a * inverse, identity(n));
          expectComplexMatrixClose(inverse * a, identity(n));
          expectComplexMatrixClose(inverse.inverse(), a);
        }
      });

      test('The inverse of a unitary matrix is its conjugate transpose', () {
        // A diagonal matrix of unit phases, followed by a permutation
        final phases = ComplexMatrix.fromFlattenedData(
          rows: 3,
          columns: 3,
          data: [
            const Complex.i(),
            const Complex.zero(),
            const Complex.zero(),
            const Complex.zero(),
            const Complex.fromReal(-1),
            const Complex.zero(),
            const Complex.zero(),
            const Complex.zero(),
            const Complex(sqrt1_2, sqrt1_2),
          ],
        );
        final permutation = ComplexMatrix.fromFlattenedData(
          rows: 3,
          columns: 3,
          data: const [
            Complex.zero(),
            Complex.fromReal(1),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.fromReal(1),
            Complex.fromReal(1),
            Complex.zero(),
            Complex.zero(),
          ],
        );
        final unitary = permutation * phases;

        expect(identity(3).inverse(), equals(identity(3)));
        expectComplexMatrixClose(
          unitary.inverse(),
          conjugateTranspose(unitary),
        );
      });

      test('The 2x2 inverse does not depend on the scale of the data', () {
        final a = invertibleMatrix(2, Random(10));
        final expected = a.inverse();

        for (final factor in const [1e-200, 1e200]) {
          expectComplexMatrixClose(
            scaled(scaled(a, factor).inverse(), factor),
            expected,
          );
        }
      });

      test('Numerically singular matrices are rejected', () {
        final matrices = [
          ComplexMatrix.fromFlattenedData(
            rows: 2,
            columns: 2,
            data: const [
              Complex(0.1, 0.1),
              Complex(0.2, 0.2),
              Complex(0.2, 0.2),
              Complex(0.4, 0.4),
            ],
          ),
          ComplexMatrix(rows: 1, columns: 1),
          ComplexMatrix(rows: 2, columns: 2),
          ComplexMatrix(rows: 4, columns: 4),
        ];

        for (final matrix in matrices) {
          expect(matrix.inverse, throwsA(isA<MatrixException>()));
        }
      });

      test('A x adj(A) = det(A) x I', () {
        final random = Random(11);

        for (var n = 2; n <= 6; n++) {
          final a = randomMatrix(n, n, random);
          final adjugate = a.cofactorMatrix().transpose();

          expectComplexMatrixClose(
            a * adjugate,
            ComplexMatrix.diagonal(
              rows: n,
              columns: n,
              diagonalValue: a.determinant(),
            ),
          );
        }
      });
    });

    group('Trace and rank', () {
      test('Trace identities', () {
        final random = Random(12);
        final a = randomMatrix(3, 5, random);
        final b = randomMatrix(5, 3, random);
        final c = randomMatrix(3, 3, random);

        expectClose((a * b).trace(), (b * a).trace());
        expect(c.transpose().trace(), equals(c.trace()));
        expectClose(
          conjugateTranspose(c).trace(),
          c.trace().conjugate(),
        );
      });

      test('Rank of products and rectangular matrices', () {
        final random = Random(13);
        final rankTwo = randomMatrix(5, 2, random) * randomMatrix(2, 6, random);
        final rankOne = randomMatrix(4, 1, random) * randomMatrix(1, 4, random);

        expect(rankTwo.rank(), equals(2));
        expect(conjugateTranspose(rankTwo).rank(), equals(2));
        expect(rankOne.rank(), equals(1));
        expect(randomMatrix(4, 6, random).rank(), equals(4));
        expect(randomMatrix(6, 4, random).rank(), equals(4));
        expect(ComplexMatrix(rows: 3, columns: 4).rank(), isZero);
        expect(identity(5).rank(), equals(5));
      });

      test('The rank does not depend on the scale of the data', () {
        final random = Random(14);
        final rankTwo = randomMatrix(4, 2, random) * randomMatrix(2, 4, random);

        for (final factor in const <double>[1e-100, 1, 1e100]) {
          expect(scaled(rankTwo, factor).rank(), equals(2));
        }
      });
    });

    group('Predicates', () {
      test('Symmetric is not the same as Hermitian', () {
        // Hermitian, but not symmetric
        final hermitian = ComplexMatrix.fromFlattenedData(
          rows: 2,
          columns: 2,
          data: const [
            Complex.fromReal(1),
            Complex.i(),
            Complex(0, -1),
            Complex.fromReal(1),
          ],
        );

        // Symmetric, but not Hermitian
        final symmetric = ComplexMatrix.fromFlattenedData(
          rows: 2,
          columns: 2,
          data: const [
            Complex.fromReal(1),
            Complex.i(),
            Complex.i(),
            Complex.fromReal(1),
          ],
        );

        expect(hermitian.isSymmetric(), isFalse);
        expect(hermitian, equals(conjugateTranspose(hermitian)));
        expect(symmetric.isSymmetric(), isTrue);
      });

      test('Rectangular matrices', () {
        final diagonal = ComplexMatrix.diagonal(
          rows: 3,
          columns: 2,
          diagonalValue: const Complex(1, 1),
        );

        expect(diagonal.isDiagonal(), isTrue);
        expect(diagonal.isSymmetric(), isFalse);
        expect(diagonal.isIdentity(), isFalse);
        expect(
          ComplexMatrix.diagonal(
            rows: 2,
            columns: 2,
            diagonalValue: const Complex(1, 1),
          ).isIdentity(),
          isFalse,
        );
      });
    });

    group('Characteristic polynomial and eigenvalues', () {
      test('Coefficients are related to the trace and the determinant', () {
        final random = Random(15);

        for (var n = 1; n <= 6; n++) {
          final a = randomMatrix(n, n, random);
          final coefficients = a.characteristicPolynomial().coefficients;
          final sign = Complex.fromReal(n.isEven ? 1 : -1);

          expect(coefficients.length, equals(n + 1));
          expect(coefficients.first, equals(const Complex.fromReal(1)));
          expectClose(coefficients[1], -a.trace());
          expectClose(coefficients.last, sign * a.determinant());
        }
      });

      test('Eigenvalues sum to the trace and multiply to the determinant', () {
        final random = Random(16);

        for (var n = 1; n <= 6; n++) {
          final a = randomMatrix(n, n, random);
          final eigenvalues = a.eigenvalues();

          expect(eigenvalues.length, equals(n));
          expectClose(
            eigenvalues.fold<Complex>(
              const Complex.zero(),
              (total, value) => total + value,
            ),
            a.trace(),
          );
          expectClose(
            eigenvalues.fold<Complex>(
              const Complex.fromReal(1),
              (total, value) => total * value,
            ),
            a.determinant(),
          );
        }
      });

      test('Hermitian matrices have real eigenvalues', () {
        final random = Random(17);

        for (var n = 1; n <= 6; n++) {
          final b = randomMatrix(n, n, random);
          final hermitian = b + conjugateTranspose(b);

          for (final eigenvalue in hermitian.eigenvalues()) {
            expect(
              eigenvalue.imaginary,
              const MoreOrLessEquals(0, precision: 1e-9),
            );
          }
        }
      });

      test('Square-only methods reject non-square matrices', () {
        final matrix = ComplexMatrix(rows: 3, columns: 2);
        final methods = <Object? Function()>[
          matrix.determinant,
          matrix.characteristicPolynomial,
          matrix.eigenvalues,
          matrix.luDecomposition,
          matrix.choleskyDecomposition,
          matrix.inverse,
          matrix.trace,
          matrix.cofactorMatrix,
        ];

        for (final method in methods) {
          expect(method, throwsA(isA<MatrixException>()));
        }
      });
    });

    group('LU and Cholesky decompositions', () {
      test('LU of identity and permutation matrices', () {
        final [l, u, p] = identity(3).luDecomposition();
        expect(l, equals(identity(3)));
        expect(u, equals(identity(3)));
        expect(p, equals(identity(3)));

        final permutation = ComplexMatrix.fromFlattenedData(
          rows: 3,
          columns: 3,
          data: const [
            Complex.zero(),
            Complex.zero(),
            Complex.fromReal(1),
            Complex.fromReal(1),
            Complex.zero(),
            Complex.zero(),
            Complex.zero(),
            Complex.fromReal(1),
            Complex.zero(),
          ],
        );
        final [pl, pu, pp] = permutation.luDecomposition();
        expect(pl, equals(identity(3)));
        expect(pu, equals(identity(3)));
        expect(pp * permutation, equals(identity(3)));
      });

      test('LU factors have the right structure', () {
        final random = Random(18);

        for (var n = 1; n <= 7; n++) {
          final a = randomMatrix(n, n, random);
          final [l, u, p] = a.luDecomposition();

          for (var i = 0; i < n; i++) {
            expect(l(i, i), equals(const Complex.fromReal(1)));

            // Partial pivoting keeps the multipliers inside the unit circle
            for (var j = 0; j < i; j++) {
              expect(l(i, j).abs(), lessThanOrEqualTo(1 + 1e-12));
              expect(u(i, j), equals(const Complex.zero()));
            }
            for (var j = i + 1; j < n; j++) {
              expect(l(i, j), equals(const Complex.zero()));
            }
          }

          expectComplexMatrixClose(p * p.transpose(), identity(n));
          expectComplexMatrixClose(p * a, l * u);
        }
      });

      test('Cholesky rejects matrices that are not positive-definite', () {
        final matrices = [
          // Hermitian but indefinite: the eigenvalues are 3 and -1
          ComplexMatrix.fromFlattenedData(
            rows: 2,
            columns: 2,
            data: const [
              Complex.fromReal(1),
              Complex(0, 2),
              Complex(0, -2),
              Complex.fromReal(1),
            ],
          ),
          ComplexMatrix(rows: 3, columns: 3),
          ComplexMatrix.fromFlattenedData(
            rows: 1,
            columns: 1,
            data: const [Complex.fromReal(-4)],
          ),
        ];

        for (final matrix in matrices) {
          expect(
            matrix.choleskyDecomposition,
            throwsA(isA<SystemSolverException>()),
          );
        }
      });

      test('Cholesky of random Hermitian positive-definite matrices', () {
        final random = Random(19);

        for (var n = 1; n <= 6; n++) {
          final b = randomMatrix(n, n, random);
          final a = conjugateTranspose(b) * b + identity(n);
          final [l, lh] = a.choleskyDecomposition();

          expect(lh, equals(conjugateTranspose(l)));
          for (var i = 0; i < n; i++) {
            expect(l(i, i).imaginary, isZero);
            expect(l(i, i).real, greaterThan(0));
            for (var j = i + 1; j < n; j++) {
              expect(l(i, j), equals(const Complex.zero()));
            }
          }
          expectComplexMatrixClose(l * lh, a);
        }
      });
    });
  });
}
