import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/eigenvalue_decomposition/eigendecomposition_real.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_real_decomposition.dart';
import 'package:equations/src/system/utils/matrix/decompositions/singular_value_decomposition/svd_real.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';
import 'decompositions/decomposition_checks.dart';

void main() {
  group('RealMatrix', () {
    test('Smoke test', () {
      final matrix = RealMatrix(columns: 5, rows: 3);

      // Checking the sizes
      expect(matrix.rowCount, equals(3));
      expect(matrix.columnCount, equals(5));
      expect(matrix.isSquareMatrix, isFalse);

      // Checking the content of the matrix
      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          expect(matrix(i, j), isZero);
          expect(matrix(i, j), equals(matrix.itemAt(i, j)));
        }
      }
    });

    test('Matrix validation test', () {
      expect(
        () => RealMatrix(columns: 0, rows: 2),
        throwsA(isA<MatrixException>()),
      );

      expect(
        () => RealMatrix(columns: 2, rows: 2, identity: true)(12, 1),
        throwsA(isA<MatrixException>()),
      );

      expect(
        () => RealMatrix(columns: 2, rows: 2, identity: true)(1, 12),
        throwsA(isA<MatrixException>()),
      );
    });

    test('isZero', () {
      final matrix = RealMatrix(columns: 2, rows: 2);
      expect(matrix.isZero(), isTrue);
    });

    test('Identity matrix has all zeroes except for the diagonal', () {
      final matrix = RealMatrix(columns: 3, rows: 3, identity: true);

      // Checking the sizes
      expect(matrix.rowCount, equals(3));
      expect(matrix.columnCount, equals(3));

      // Checking the content of the matrix
      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          if (i == j) {
            expect(matrix(i, j), equals(1));
          } else {
            expect(matrix(i, j), isZero);
          }
          expect(matrix(i, j), equals(matrix.itemAt(i, j)));
        }
      }
    });

    test('Exception is thrown if identity matrix is non-square.', () {
      expect(
        () => RealMatrix(columns: 3, rows: 5, identity: true),
        throwsA(isA<MatrixException>()),
      );
    });

    test('Matrix can be flattened into a list of doubles.', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: [
          [1, 2],
          [3, 4],
        ],
      );

      // Checking the sizes
      final flattenedMatrix = matrix.toList();

      expect(flattenedMatrix.length, equals(4));
      expect(flattenedMatrix, orderedEquals(<double>[1, 2, 3, 4]));
    });

    test('Matrix can be created from a flattened list of values.', () {
      final matrix = RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: [1, 2, 3, 4],
      );

      expect(matrix.rowCount * matrix.columnCount, equals(4));
      expect(
        matrix,
        equals(
          RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: [
              [1, 2],
              [3, 4],
            ],
          ),
        ),
      );
    });

    test('Diagonal matrix can be created.', () {
      final matrix = RealMatrix.diagonal(rows: 3, columns: 3, diagonalValue: 8);

      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          if (i == j) {
            expect(matrix(i, j), equals(8));
          } else {
            expect(matrix(i, j), isZero);
          }
        }
      }

      const stringRepresentation =
          '[8.0, 0.0, 0.0]\n'
          '[0.0, 8.0, 0.0]\n'
          '[0.0, 0.0, 8.0]';

      expect('$matrix', equals(stringRepresentation));
    });

    test('Diagonal non square matrix is created wit the given value', () {
      final matrix = RealMatrix.diagonal(rows: 3, columns: 5, diagonalValue: 8);

      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          if (i == j) {
            expect(matrix(i, j), equals(8));
          } else {
            expect(matrix(i, j), isZero);
          }
        }
      }

      const stringRepresentation =
          '[8.0, 0.0, 0.0, 0.0, 0.0]\n'
          '[0.0, 8.0, 0.0, 0.0, 0.0]\n'
          '[0.0, 0.0, 8.0, 0.0, 0.0]';

      expect('$matrix', equals(stringRepresentation));
    });

    test('Diagonal, non square matrix', () {
      final matrix = RealMatrix.diagonal(rows: 6, columns: 2, diagonalValue: 1);

      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          if (i == j) {
            expect(matrix(i, j), equals(1));
          } else {
            expect(matrix(i, j), isZero);
          }
        }
      }

      const stringRepresentation =
          '[1.0, 0.0]\n'
          '[0.0, 1.0]\n'
          '[0.0, 0.0]\n'
          '[0.0, 0.0]\n'
          '[0.0, 0.0]\n'
          '[0.0, 0.0]';

      expect('$matrix', equals(stringRepresentation));
    });

    test('Diagonal of a single element', () {
      final matrix = RealMatrix.diagonal(
        rows: 1,
        columns: 1,
        diagonalValue: 31,
      );

      expect(matrix(0, 0), equals(31));
      expect('$matrix', equals('[31.0]'));
    });

    test('Exception if sizes and array length do not match', () {
      expect(
        () => RealMatrix.fromFlattenedData(
          rows: 6,
          columns: 2,
          data: [1, 2, 3, 4],
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('String conversion test', () {
      final matrix = RealMatrix.fromData(
        columns: 3,
        rows: 3,
        data: const [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ],
      );

      const expected =
          '[1.0, 2.0, 3.0]\n'
          '[4.0, 5.0, 6.0]\n'
          '[7.0, 8.0, 9.0]';
      expect(matrix.toString(), equals(expected));
    });

    test('Matrix creation from list of lists', () {
      final matrix = RealMatrix.fromData(
        columns: 3,
        rows: 3,
        data: const [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ],
      );

      // Checking the sizes
      expect(matrix.rowCount, equals(3));
      expect(matrix.columnCount, equals(3));

      // Checking the content of the matrix
      expect(matrix(0, 0), equals(1));
      expect(matrix(0, 1), equals(2));
      expect(matrix(0, 2), equals(3));
      expect(matrix(1, 0), equals(4));
      expect(matrix(1, 1), equals(5));
      expect(matrix(1, 2), equals(6));
      expect(matrix(2, 0), equals(7));
      expect(matrix(2, 1), equals(8));
      expect(matrix(2, 2), equals(9));
    });
  });

  group('Equality', () {
    test('Objects comparison works properly.', () {
      final matrix = RealMatrix(columns: 2, rows: 2);

      // Equality tests
      expect(RealMatrix(columns: 2, rows: 2), equals(matrix));
      expect(matrix, equals(RealMatrix(columns: 2, rows: 2)));
      expect(RealMatrix(columns: 2, rows: 2) == matrix, isTrue);
      expect(matrix == RealMatrix(columns: 2, rows: 2), isTrue);
      expect(RealMatrix(columns: 2, rows: 2).hashCode, equals(matrix.hashCode));

      expect(
        RealMatrix.fromFlattenedData(rows: 1, columns: 1, data: [5.0]),
        equals(RealMatrix.fromFlattenedData(rows: 1, columns: 1, data: [5.0])),
      );

      expect(
        RealMatrix.fromFlattenedData(rows: 1, columns: 1, data: [5.0]) ==
            RealMatrix.fromFlattenedData(rows: 1, columns: 1, data: [5.01]),
        isFalse,
      );

      // Inequality tests
      expect(
        RealMatrix(columns: 2, rows: 2, identity: true) == matrix,
        isFalse,
      );
      expect(
        RealMatrix(columns: 2, rows: 1).hashCode == matrix.hashCode,
        isFalse,
      );
    });
  });

  group('Operators', () {
    /*
    * A = |  2  6  |
    *     | -5  0  |
    * */
    final matrixA = RealMatrix.fromData(
      columns: 2,
      rows: 2,
      data: const [
        [2, 6],
        [-5, 0],
      ],
    );

    /*
    * B = | -4  1  |
    *     |  7 -3  |
    * */
    final matrixB = RealMatrix.fromData(
      columns: 2,
      rows: 2,
      data: const [
        [-4, 1],
        [7, -3],
      ],
    );

    test('operator+', () {
      final matrixSum = RealMatrix.fromData(
        columns: 2,
        rows: 2,
        data: [
          [-2, 7],
          [2, -3],
        ],
      );
      expect(matrixA + matrixB, equals(matrixSum));
    });

    test('operator+ on rectangular matrices', () {
      final matrixA = RealMatrix.fromData(
        columns: 2,
        rows: 3,
        data: [
          [4, -1],
          [1, 9],
          [6, 5],
        ],
      );

      final matrixB = RealMatrix.fromData(
        columns: 2,
        rows: 3,
        data: [
          [3, 1],
          [-1, 5],
          [4, 9],
        ],
      );

      expect(
        matrixA + matrixB,
        equals(
          RealMatrix.fromData(
            columns: 2,
            rows: 3,
            data: [
              [7, 0],
              [0, 14],
              [10, 14],
            ],
          ),
        ),
      );
    });

    test('operator-', () {
      final matrixSub = RealMatrix.fromData(
        columns: 2,
        rows: 2,
        data: [
          [6, 5],
          [-12, 3],
        ],
      );
      expect(matrixA - matrixB, equals(matrixSub));
    });

    test('operator- on rectangular matrices', () {
      final matrixA = RealMatrix.fromData(
        columns: 2,
        rows: 3,
        data: [
          [4, -1],
          [1, 9],
          [6, 5],
        ],
      );

      final matrixB = RealMatrix.fromData(
        columns: 2,
        rows: 3,
        data: [
          [3, 0],
          [-1, 5],
          [4, 9],
        ],
      );

      expect(
        matrixA - matrixB,
        equals(
          RealMatrix.fromData(
            columns: 2,
            rows: 3,
            data: [
              [1, -1],
              [2, 4],
              [2, -4],
            ],
          ),
        ),
      );
    });

    test('operator*', () {
      final matrixMul = RealMatrix.fromData(
        columns: 2,
        rows: 2,
        data: [
          [34, -16],
          [20, -5],
        ],
      );
      expect(matrixA * matrixB, equals(matrixMul));
    });

    test('operator* on rectangular matrices', () {
      final matrixA = RealMatrix.fromData(
        columns: 2,
        rows: 2,
        data: [
          [2, 4],
          [1, -3],
        ],
      );

      final matrixB = RealMatrix.fromData(
        columns: 3,
        rows: 2,
        data: [
          [6, 0, 4],
          [-1, 0, 2],
        ],
      );

      final matrixMul = RealMatrix.fromData(
        columns: 3,
        rows: 2,
        data: [
          [8, 0, 16],
          [9, 0, -2],
        ],
      );

      expect(matrixA * matrixB, equals(matrixMul));
    });

    test('operator/', () {
      final matrixDiv = RealMatrix.fromData(
        columns: 2,
        rows: 2,
        data: [
          [-1 / 2, 6],
          [-5 / 7, 0],
        ],
      );
      expect(matrixA / matrixB, equals(matrixDiv));
    });

    test('operator/ on rectangular matrices', () {
      final matrixA = RealMatrix.fromData(
        columns: 2,
        rows: 3,
        data: [
          [4, -1],
          [1, 9],
          [6, 5],
        ],
      );

      final matrixB = RealMatrix.fromData(
        columns: 2,
        rows: 3,
        data: [
          [3, 1],
          [-1, 5],
          [4, 9],
        ],
      );

      expect(
        matrixA / matrixB,
        equals(
          RealMatrix.fromData(
            columns: 2,
            rows: 3,
            data: [
              [4 / 3, -1],
              [-1, 9 / 5],
              [3 / 2, 5 / 9],
            ],
          ),
        ),
      );
    });

    test(
      'operator+, operator- and operator/ on different sized matrices',
      () {
        final otherMatrix = RealMatrix.fromFlattenedData(
          rows: 1,
          columns: 1,
          data: [1],
        );

        expect(() => matrixA + otherMatrix, throwsA(isA<MatrixException>()));

        expect(() => matrixA - otherMatrix, throwsA(isA<MatrixException>()));

        expect(() => matrixA / otherMatrix, throwsA(isA<MatrixException>()));
      },
    );

    test('operator* on different sized matrices', () {
      final otherMatrix = RealMatrix.fromFlattenedData(
        rows: 1,
        columns: 2,
        data: [1, 3],
      );

      expect(() => matrixA * otherMatrix, throwsA(isA<MatrixException>()));
    });
  });

  group('Determinant', () {
    test('Determinant of a 1x1 matrix', () {
      final matrix = RealMatrix.fromData(
        columns: 1,
        rows: 1,
        data: [
          [-5],
        ],
      );
      expect(matrix.determinant(), equals(-5));
    });

    test('Determinant of a 2x2 matrix', () {
      final matrix = RealMatrix.fromData(
        columns: 2,
        rows: 2,
        data: [
          [6, 5],
          [-12, 3],
        ],
      );
      expect(matrix.determinant(), equals(78));
    });

    test('Determinant of a 3x3 matrix', () {
      final matrix = RealMatrix.fromData(
        columns: 3,
        rows: 3,
        data: [
          [2, -1, 0],
          [11, 0, 7],
          [6, 1, 1],
        ],
      );
      expect(matrix.determinant(), equals(-45));
    });

    test('Determinant of a 4x4 matrix', () {
      final matrix = RealMatrix.fromData(
        columns: 4,
        rows: 4,
        data: [
          [2, -1, 13, 4],
          [11, 0, 1, 7],
          [6, -4, 7, 2],
          [1, -1, 3, 0],
        ],
      );
      expect(matrix.determinant(), equals(271));
    });

    test('Determinant of a 5x5 (or greater) matrix', () {
      final matrix = RealMatrix.fromData(
        columns: 5,
        rows: 5,
        data: [
          [2, -1, 13, 4, 1],
          [11, 0, 5, 1, 7],
          [6, -4, 7, 2, -6],
          [1, 0, -3, -6, 9],
          [7, 0, 3, -4, 1],
        ],
      );
      expect(
        matrix.determinant(),
        const MoreOrLessEquals(-28398, precision: 0.1),
      );
    });
  });

  group('API', () {
    test('LU decomposition on square matrix', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ],
      );

      // Decomposition
      final lu = matrix.luDecomposition();
      expect(lu.length, equals(3)); // Now returns [L, U, P]

      // Checking L
      final L = lu[0];
      expect(L.rowCount, equals(matrix.rowCount));
      expect(L.columnCount, equals(matrix.columnCount));
      expect(L.isSquareMatrix, isTrue);
      // L should be lower triangular with 1s on diagonal
      for (var i = 0; i < L.rowCount; i++) {
        expect(L(i, i), equals(1.0));
        for (var j = i + 1; j < L.columnCount; j++) {
          expect(L(i, j), equals(0.0));
        }
      }

      // Checking U
      final U = lu[1];
      expect(U.rowCount, equals(matrix.rowCount));
      expect(U.columnCount, equals(matrix.columnCount));
      expect(U.isSquareMatrix, isTrue);
      // U should be upper triangular
      for (var i = 0; i < U.rowCount; i++) {
        for (var j = 0; j < i; j++) {
          expect(U(i, j), equals(0.0));
        }
      }

      // Checking P (permutation matrix)
      final P = lu[2];
      expect(P.rowCount, equals(matrix.rowCount));
      expect(P.columnCount, equals(matrix.columnCount));
      expect(P.isSquareMatrix, isTrue);
      // P should be a permutation matrix (each row and column has one 1)
      for (var i = 0; i < P.rowCount; i++) {
        var rowSum = 0.0;
        var colSum = 0.0;
        for (var j = 0; j < P.columnCount; j++) {
          rowSum += P(i, j);
          colSum += P(j, i);
          expect(P(i, j) == 0.0 || P(i, j) == 1.0, isTrue);
        }
        expect(rowSum, equals(1.0));
        expect(colSum, equals(1.0));
      }

      // Verify PA = LU (with pivoting, we have PA = LU)
      final pA = P * matrix;
      final luMatrix = L * U;
      for (var i = 0; i < pA.rowCount; i++) {
        for (var j = 0; j < pA.columnCount; j++) {
          expect(
            pA(i, j),
            MoreOrLessEquals(luMatrix(i, j), precision: 1.0e-10),
          );
        }
      }
    });

    test('LU decomposition on non-square matrix', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [1, 2, 3],
          [4, 5, 6],
        ],
      );

      // Decomposition
      expect(matrix.luDecomposition, throwsA(isA<MatrixException>()));
    });

    test('Cholesky decomposition on square matrix', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [25, 15, -5],
          [15, 18, 0],
          [-5, 0, 11],
        ],
      );

      // Decomposition
      final cholesky = matrix.choleskyDecomposition();
      expect(cholesky.length, equals(2));

      // Checking L
      final L = cholesky.first;
      expect(
        L.flattenData,
        orderedEquals(<double>[5, 0, 0, 3, 3, 0, -1, 1, 3]),
      );
      expect(L.rowCount, equals(matrix.rowCount));
      expect(L.columnCount, equals(matrix.columnCount));
      expect(L.isSquareMatrix, isTrue);

      // Checking Lt
      final transposedL = cholesky[1];
      expect(
        transposedL.flattenData,
        orderedEquals(<double>[5, 3, -1, 0, 3, 1, 0, 0, 3]),
      );
      expect(transposedL.rowCount, equals(matrix.rowCount));
      expect(transposedL.columnCount, equals(matrix.columnCount));
      expect(transposedL.isSquareMatrix, isTrue);
    });

    test('Cholesky decomposition on non-square matrix', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 2,
        data: const [
          [1, 2],
          [3, 4],
          [5, 6],
        ],
      );

      // Decomposition
      expect(matrix.choleskyDecomposition, throwsA(isA<MatrixException>()));
    });

    test(
      'Cholesky decomposition on large matrix to trigger block processing',
      () {
        final data = <List<double>>[];
        for (var i = 0; i < 40; i++) {
          final row = <double>[];
          for (var j = 0; j < 40; j++) {
            if (i == j) {
              row.add(40.0 + i);
            } else {
              row.add(0.1);
            }
          }
          data.add(row);
        }

        final matrix = RealMatrix.fromData(rows: 40, columns: 40, data: data);

        final cholesky = matrix.choleskyDecomposition();
        expect(cholesky.length, equals(2));

        final L = cholesky[0];
        final lt = cholesky[1];
        final reconstructed = L * lt;

        for (var i = 0; i < 40; i++) {
          for (var j = 0; j < 40; j++) {
            expect(
              reconstructed(i, j),
              MoreOrLessEquals(matrix(i, j), precision: 1.0e-5),
            );
          }
        }
      },
    );

    test('qrDecomposition', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [1, 2],
          [3, 4],
        ],
      );

      expect(
        matrix.qrDecomposition(),
        orderedEquals(
          QRDecompositionReal(matrix: matrix).decompose(),
        ),
      );
    });

    test('svdDecomposition', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [1, 2],
          [3, 4],
        ],
      );

      expect(
        matrix.singleValueDecomposition(),
        orderedEquals(
          SVDReal(matrix: matrix).decompose(),
        ),
      );
    });

    test('eigenDecomposition', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [1, 2],
          [3, 4],
        ],
      );

      expect(
        matrix.eigenDecomposition(),
        orderedEquals(
          EigendecompositionReal(matrix: matrix).decompose(),
        ),
      );
    });

    test('transposedValue', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [6, 4, 24],
          [1, -9, 8],
        ],
      );

      expect(matrix.transposedValue(0, 0), equals(6));
      expect(matrix.transposedValue(0, 1), equals(1));
      expect(matrix.transposedValue(1, 0), equals(4));
      expect(matrix.transposedValue(1, 1), equals(-9));
      expect(matrix.transposedValue(2, 0), equals(24));
      expect(matrix.transposedValue(2, 1), equals(8));
    });

    test('transpose on square matrix', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [1, 2],
          [3, 4],
        ],
      );

      final transposed = matrix.transpose();
      expect(transposed(0, 0), equals(1));
      expect(transposed(0, 1), equals(3));
      expect(transposed(1, 0), equals(2));
      expect(transposed(1, 1), equals(4));
    });

    test('transpose on rectangular matrix', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [6, 4, 24],
          [1, -9, 8],
        ],
      );

      final transposed = matrix.transpose();
      expect(transposed(0, 0), equals(6));
      expect(transposed(0, 1), equals(1));
      expect(transposed(1, 0), equals(4));
      expect(transposed(1, 1), equals(-9));
      expect(transposed(2, 0), equals(24));
      expect(transposed(2, 1), equals(8));
    });

    test('minors', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [2, 3, 1],
          [0, 5, 6],
          [1, 1, 2],
        ],
      );

      // Removing (0; 0)
      final minor1 = matrix.minor(0, 0);
      expect(minor1.flattenData, orderedEquals([5, 6, 1, 2]));

      // Removing (1; 2)
      final minor2 = matrix.minor(1, 2);
      expect(minor2.flattenData, orderedEquals([2, 3, 1, 1]));

      // Errors
      expect(() => matrix.minor(-1, 2), throwsA(isA<MatrixException>()));
      expect(() => matrix.minor(11, 2), throwsA(isA<MatrixException>()));
    });

    test('cofactorMatrix', () {
      final matrixSize2 = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [4, -5],
          [7, 3],
        ],
      );

      final cofactorMatrixSize2 = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [3, -7],
          [5, 4],
        ],
      );

      expect(matrixSize2.cofactorMatrix(), equals(cofactorMatrixSize2));

      final matrixSize3 = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [2, 8, -3],
          [0, 6, 1],
          [-4, 7, 1],
        ],
      );

      final cofactorMatrixSize3 = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [-1, -4, 24],
          [-29, -10, -46],
          [26, -2, 12],
        ],
      );

      expect(matrixSize3.cofactorMatrix(), equals(cofactorMatrixSize3));
    });

    test('cofactorMatrix on non-square matrix', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 1,
        data: const [
          [2],
          [8],
        ],
      );

      expect(matrix.cofactorMatrix, throwsA(isA<MatrixException>()));
    });

    test('inverse on non-square matrix', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 1,
        data: const [
          [2],
          [8],
        ],
      );

      expect(matrix.inverse, throwsA(isA<MatrixException>()));
    });

    test('inverse of a 2x2 matrix', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [-4, 2],
          [1, 3],
        ],
      ).inverse();

      expect(
        matrix(0, 0),
        const MoreOrLessEquals(-0.214286, precision: 1.0e-6),
      );
      expect(matrix(0, 1), const MoreOrLessEquals(0.142857, precision: 1.0e-6));
      expect(matrix(1, 0), const MoreOrLessEquals(0.071428, precision: 1.0e-6));
      expect(matrix(1, 1), const MoreOrLessEquals(0.285714, precision: 1.0e-6));
    });

    test('inverse', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [2, -1, 0],
          [4, 0, 7],
          [6, 1, 3],
        ],
      ).inverse();

      expect(matrix(0, 0), const MoreOrLessEquals(0.159091, precision: 1.0e-6));
      expect(
        matrix(0, 1),
        const MoreOrLessEquals(-0.068181, precision: 1.0e-6),
      );
      expect(matrix(0, 2), const MoreOrLessEquals(0.159091, precision: 1.0e-6));
      expect(
        matrix(1, 0),
        const MoreOrLessEquals(-0.681818, precision: 1.0e-6),
      );
      expect(
        matrix(1, 1),
        const MoreOrLessEquals(-0.136364, precision: 1.0e-6),
      );
      expect(matrix(1, 2), const MoreOrLessEquals(0.318182, precision: 1.0e-6));
      expect(
        matrix(2, 0),
        const MoreOrLessEquals(-0.090909, precision: 1.0e-6),
      );
      expect(matrix(2, 1), const MoreOrLessEquals(0.181818, precision: 1.0e-6));
      expect(
        matrix(2, 2),
        const MoreOrLessEquals(-0.090909, precision: 1.0e-6),
      );
    });

    test('trace', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [2, 5],
          [4, 9],
        ],
      );

      expect(matrix.trace(), equals(11));
    });

    test('trace only computed on square matrices', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [2, 5, 3],
          [4, 9, 2],
        ],
      );

      expect(matrix.trace, throwsA(isA<MatrixException>()));
    });

    test('isSymmetric', () {
      final symmetric = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 7, 3],
          [7, 4, 5],
          [3, 5, 6],
        ],
      );

      expect(symmetric.isSymmetric(), isTrue);

      final notSymmetric = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, -7, 3],
          [7, 4, 5],
          [3, 5, 6],
        ],
      );

      expect(notSymmetric.isSymmetric(), isFalse);
    });

    test('isDiagonal', () {
      final diagonal = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [3, 0, 0],
          [0, 4, 0],
          [0, 0, 6],
        ],
      );

      expect(diagonal.isDiagonal(), isTrue);

      final stillDiagonal = RealMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [3, 0, 0],
          [0, 4, 0],
        ],
      );

      expect(stillDiagonal.isDiagonal(), isTrue);

      final notDiagonal = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [3, 0, 0],
          [0, 4, 0],
          [1, 0, 6],
        ],
      );

      expect(notDiagonal.isDiagonal(), isFalse);
    });

    test('isIdentity', () {
      final diagonal = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 0, 0],
          [0, 1, 0],
          [0, 0, 1],
        ],
      );

      expect(diagonal.isDiagonal(), isTrue);
      expect(diagonal.isIdentity(), isTrue);

      final notDiagonal = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 0, 0],
          [0, -1, 0],
          [0, 0, 1],
        ],
      );

      expect(notDiagonal.isDiagonal(), isTrue);
      expect(notDiagonal.isIdentity(), isFalse);
    });

    test('Non-square matrices are never the identity', () {
      final identity = RealMatrix.fromData(
        rows: 3,
        columns: 2,
        data: const [
          [1, 0],
          [0, 1],
          [0, 0],
        ],
      );

      expect(identity.isIdentity(), isFalse);
    });

    test('rank', () {
      final rank = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [6, -7],
          [0, 3],
        ],
      );

      expect(rank.rank(), equals(2));

      final singularRank = RealMatrix.fromData(
        rows: 1,
        columns: 1,
        data: const [
          [6],
        ],
      );

      expect(singularRank.rank(), equals(1));

      final zeroRank = RealMatrix.fromData(
        rows: 1,
        columns: 1,
        data: const [
          [0],
        ],
      );

      expect(zeroRank.rank(), isZero);

      final rectangularRank1 = RealMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [3, -6, 5],
          [1, 9, 0],
        ],
      );

      expect(rectangularRank1.rank(), equals(2));

      final rectangularRank2 = RealMatrix.fromData(
        rows: 3,
        columns: 1,
        data: const [
          [3],
          [4],
          [8],
        ],
      );

      expect(rectangularRank2.rank(), equals(1));
    });

    test('eigenvalues for 1x1 matrices', () {
      final matrix = RealMatrix.fromData(
        rows: 1,
        columns: 1,
        data: const [
          [-16],
        ],
      );

      final eigenvalues = matrix.eigenvalues();

      expect(eigenvalues.length, equals(1));
      expect(eigenvalues.first, equals(const Complex.fromReal(-16)));
    });

    test('eigenvalues for 2x2 matrices', () {
      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [3, 1],
          [2, 5],
        ],
      );

      final eigenvalues = matrix.eigenvalues();

      expect(eigenvalues.length, equals(2));
      expect(
        eigenvalues.first.real,
        const MoreOrLessEquals(5.732, precision: 1.0e-4),
      );
      expect(
        eigenvalues[1].real,
        const MoreOrLessEquals(2.2679, precision: 1.0e-4),
      );
      expect(eigenvalues.first.imaginary, isZero);
      expect(eigenvalues[1].imaginary, isZero);
    });

    test('eigenvalues for 3x3 matrices', () {
      final matrix = RealMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ],
      );

      final eigenvalues = matrix.eigenvalues();

      expect(eigenvalues.length, equals(3));
      expect(
        eigenvalues.first.real,
        const MoreOrLessEquals(16.1168, precision: 1.0e-4),
      );
      expect(
        eigenvalues[1].real,
        const MoreOrLessEquals(-1.1168, precision: 1.0e-4),
      );
      expect(eigenvalues[2].real, const MoreOrLessEquals(0, precision: 1.0e-4));
      expect(
        eigenvalues.first.imaginary,
        const MoreOrLessEquals(0, precision: 1.0e-4),
      );
      expect(
        eigenvalues[1].imaginary,
        const MoreOrLessEquals(0, precision: 1.0e-4),
      );
      expect(
        eigenvalues[2].imaginary,
        const MoreOrLessEquals(0, precision: 1.0e-4),
      );
    });

    test('minors', () {
      final source = [
        RealMatrix.fromData(
          rows: 3,
          columns: 4,
          data: const [
            [2, -1, 5, 9],
            [-12, 3, 2, 0],
            [1, -1, 9, 8],
          ],
        ).minor(1, 2),
        RealMatrix.fromData(
          rows: 3,
          columns: 4,
          data: const [
            [2, -1, 5, 9],
            [-12, 3, 2, 0],
            [1, -1, 9, 8],
          ],
        ).minor(2, 3),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [-6, 1],
            [2, 7],
          ],
        ).minor(0, 1),
        RealMatrix.fromData(
          rows: 4,
          columns: 2,
          data: const [
            [-6, 1],
            [2, 2],
            [8, -1],
            [0, -10],
          ],
        ).minor(2, 0),
      ];

      final minors = [
        RealMatrix.fromData(
          rows: 2,
          columns: 3,
          data: const [
            [2, -1, 9],
            [1, -1, 8],
          ],
        ),
        RealMatrix.fromData(
          rows: 2,
          columns: 3,
          data: const [
            [2, -1, 5],
            [-12, 3, 2],
          ],
        ),
        RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [2],
          ],
        ),
        RealMatrix.fromData(
          rows: 3,
          columns: 1,
          data: const [
            [1],
            [2],
            [-10],
          ],
        ),
      ];

      for (var i = 0; i < source.length; ++i) {
        expect(source[i], equals(minors[i]));
      }

      // Exception test
      expect(
        () => RealMatrix.fromData(
          rows: 2,
          columns: 1,
          data: const [
            [1],
            [2],
          ],
        ).minor(1, 0),
        throwsA(isA<MatrixException>()),
      );
    });

    test('cofactorMatrix', () {
      final source = [
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [1, 2, 3],
            [0, 4, 5],
            [1, 0, 6],
          ],
        ).cofactorMatrix(),
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [3, 1, 2],
            [-2, 4, 4],
            [1, 3, 6],
          ],
        ).cofactorMatrix(),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [-3, 6],
            [7, 9],
          ],
        ).cofactorMatrix(),
        RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [9],
          ],
        ).cofactorMatrix(),
      ];

      final cofactorMatrices = [
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [24, 5, -4],
            [-12, 3, 2],
            [-2, -5, 4],
          ],
        ),
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [12, 16, -10],
            [0, 16, -8],
            [-4, -16, 14],
          ],
        ),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [9, -7],
            [-6, -3],
          ],
        ),
        RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [1],
          ],
        ),
      ];

      for (var i = 0; i < source.length; ++i) {
        expect(source[i], equals(cofactorMatrices[i]));
      }
    });

    test('inverse', () {
      final source = [
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [3, 0, 2],
            [2, 0, -2],
            [0, 1, 1],
          ],
        ).inverse(),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [4, 7],
            [2, 6],
          ],
        ).inverse(),
        RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [13],
          ],
        ).inverse(),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 0],
            [0, 1],
          ],
        ).inverse(),
      ];

      final inverse = [
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [0.2, 0.2, 0],
            [-0.2, 3 / 10, 1],
            [0.2, -3 / 10, 0],
          ],
        ),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [0.6, -0.7],
            [-0.2, 0.4],
          ],
        ),
        RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [1 / 13],
          ],
        ),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 0],
            [0, 1],
          ],
        ),
      ];

      for (var i = 0; i < source.length; ++i) {
        for (var j = 0; j < source[i].rowCount; ++j) {
          for (var k = 0; k < source[i].rowCount; ++k) {
            expect(
              source[i](j, k),
              MoreOrLessEquals(inverse[i](j, k), precision: 1.0e-2),
            );
          }
        }
      }
    });

    test('rank', () {
      final source = [
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [3, 0, 2],
            [2, 0, -2],
            [0, 1, 1],
          ],
        ).rank(),
        RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [4],
          ],
        ).rank(),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [4, 7],
            [2, 6],
          ],
        ).rank(),
        RealMatrix.fromData(
          rows: 3,
          columns: 2,
          data: const [
            [1, 6],
            [-2, 9],
            [0, 1],
          ],
        ).rank(),
        RealMatrix.fromData(
          rows: 3,
          columns: 2,
          data: const [
            [1, 3],
            [2, 6],
            [3, 9],
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
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [3, 1, 5],
            [3, 3, 1],
            [4, 6, 4],
          ],
        ).characteristicPolynomial(),
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: const [
            [2, -1, 1],
            [-1, 2, 1],
            [1, -1, 2],
          ],
        ).characteristicPolynomial(),
        RealMatrix.fromData(
          rows: 4,
          columns: 4,
          data: const [
            [8, -1, 3, -1],
            [-1, 6, 2, 0],
            [3, 2, 9, 1],
            [-1, 0, 1, 7],
          ],
        ).characteristicPolynomial(),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [3, 9],
            [-7, 2],
          ],
        ).characteristicPolynomial(),
        RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: const [
            [12],
          ],
        ).characteristicPolynomial(),
      ];

      final expectedSolutions = <Algebraic>[
        Algebraic.fromReal([1, -10, 4, -40]),
        Algebraic.fromReal([1, -6, 11, -6]),
        Algebraic.fromReal([1, -30, 319, -1410, 2138]),
        Algebraic.fromReal([1, -5, 69]),
        Algebraic.fromReal([1, -12]),
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
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: [
            [2, -4],
            [-1, -1],
          ],
        ).eigenvalues(),
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: [
            [5, 8, 16],
            [4, 1, 8],
            [6, -4, -11],
          ],
        ).eigenvalues(),
        RealMatrix.fromData(
          rows: 4,
          columns: 4,
          data: [
            [1, 2, 3, 4],
            [-1, 8, 3, 7],
            [0, 0, 0, 0],
            [9, 5, -7, 4],
          ],
        ).eigenvalues(),
        RealMatrix.fromData(
          rows: 1,
          columns: 1,
          data: [
            [16],
          ],
        ).eigenvalues(),
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: [
            [9, 7, -6],
            [5, 8, -1],
            [5, 3, 2],
          ],
        ).eigenvalues(),
        RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: [
            [1, -1],
            [1, 1],
          ],
        ).eigenvalues(),
        RealMatrix.fromData(
          rows: 3,
          columns: 3,
          data: [
            [1, 7, 3],
            [7, 4, 5],
            [3, 5, 0],
          ],
        ).eigenvalues(),
      ];

      final expected = <List<Complex>>[
        const [Complex.fromReal(3), Complex.fromReal(-2)],
        const [
          Complex.fromReal(11.8062),
          Complex.fromReal(-13.8062),
          Complex.fromReal(-3),
        ],
        const [
          Complex.fromReal(-4.039),
          Complex.fromReal(3.1566),
          Complex.fromReal(13.8824),
          Complex.zero(),
        ],
        const [Complex.fromReal(16)],
        const [
          Complex.fromReal(11.6784),
          Complex(3.6607, 2.257),
          Complex(3.6607, -2.257),
        ],
        const [Complex(1, -1), Complex(1, 1)],
        const [
          Complex.fromReal(-4.9095),
          Complex.fromReal(-2.4546),
          Complex.fromReal(12.3641),
        ],
      ];

      for (var i = 0; i < eigenvalues.length; ++i) {
        for (var j = 0; j < expected[i].length; ++j) {
          expect(
            eigenvalues[i][j].real,
            MoreOrLessEquals(expected[i][j].real, precision: 1.0e-4),
          );
          expect(
            eigenvalues[i][j].imaginary,
            MoreOrLessEquals(expected[i][j].imaginary, precision: 1.0e-4),
          );
        }
      }
    });
  });

  group('Regressions', () {
    RealMatrix fromRows(List<List<double>> rows) => RealMatrix.fromData(
      rows: rows.length,
      columns: rows.first.length,
      data: rows,
    );

    void expectIdentity(RealMatrix matrix) {
      final n = matrix.rowCount;
      for (var i = 0; i < n; i++) {
        for (var j = 0; j < n; j++) {
          expect(
            matrix(i, j),
            MoreOrLessEquals(i == j ? 1 : 0, precision: 1.0e-10),
          );
        }
      }
    }

    void expectLUFactors(RealMatrix matrix) {
      final lu = matrix.luDecomposition();
      final pA = lu[2] * matrix;
      final product = lu.first * lu[1];

      for (var i = 0; i < matrix.rowCount; i++) {
        for (var j = 0; j < matrix.columnCount; j++) {
          expect(pA(i, j), MoreOrLessEquals(product(i, j), precision: 1.0e-10));
        }
      }
    }

    // Invertible (det = -1), but the third pivot of the first two columns is
    // zero unless pivots are chosen on the partially reduced columns.
    final tricky5x5 = fromRows(const [
      [1, 1, 0, 0, 0],
      [1, 1, 1, 0, 0],
      [0, 1, 1, 0, 0],
      [0, 0, 0, 1, 0],
      [0, 0, 0, 0, 1],
    ]);

    // Upper bidiagonal (2 and 1) plus a 1 in the bottom-left corner: the
    // determinant is 2^6 - 1 = 63.
    final invertible6x6 = RealMatrix.fromFlattenedData(
      rows: 6,
      columns: 6,
      data: List<double>.generate(36, (k) {
        final i = k ~/ 6;
        final j = k % 6;

        if (i == j) {
          return 2;
        }

        return (j == i + 1 || (i == 5 && j == 0)) ? 1 : 0;
      }),
    );

    test('Invalid dimensions are rejected', () {
      expect(
        () => RealMatrix(rows: -1, columns: -1),
        throwsA(isA<MatrixException>()),
      );
      expect(
        () => RealMatrix(rows: -1, columns: 2),
        throwsA(isA<MatrixException>()),
      );
      expect(
        () => RealMatrix.diagonal(rows: 2, columns: 0, diagonalValue: 1),
        throwsA(isA<MatrixException>()),
      );
      expect(
        () => RealMatrix.fromFlattenedData(rows: -1, columns: -2, data: [1, 2]),
        throwsA(isA<MatrixException>()),
      );
      expect(
        () => RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 2, 3],
            [4],
          ],
        ),
        throwsA(isA<MatrixException>()),
      );
    });

    test('Operators return a RealMatrix', () {
      final matrix = fromRows(const [
        [1, 2],
        [3, 4],
      ]);

      expect(matrix + matrix, isA<RealMatrix>());
      expect(matrix - matrix, isA<RealMatrix>());
      expect(matrix * matrix, isA<RealMatrix>());
      expect(matrix / matrix, isA<RealMatrix>());
    });

    test('LU decomposition works when early pivots vanish', () {
      expectLUFactors(tricky5x5);
    });

    test('LU decomposition of a singular matrix', () {
      final singular = fromRows(const [
        [1, 2, 3],
        [2, 4, 6],
        [1, 1, 1],
      ]);

      expectLUFactors(singular);
    });

    test('Determinant of 5x5 and bigger matrices', () {
      expect(
        tricky5x5.determinant(),
        const MoreOrLessEquals(-1, precision: 1.0e-10),
      );
      expect(
        invertible6x6.determinant(),
        const MoreOrLessEquals(63, precision: 1.0e-10),
      );

      final zeroRow = fromRows(const [
        [1, 2, 3, 4, 5],
        [0, 0, 0, 0, 0],
        [5, 4, 3, 2, 1],
        [1, 0, 1, 0, 1],
        [2, 2, 2, 2, 2],
      ]);
      expect(zeroRow.determinant(), isZero);

      // A row swap only changes the sign of the determinant
      final swapped = fromRows(const [
        [0, 1, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 0, 1, 0],
        [0, 0, 0, 0, 1],
      ]);
      expect(swapped.determinant(), equals(-1));
    });

    test('Inverse of big matrices', () {
      expectIdentity(invertible6x6 * invertible6x6.inverse());
      expectIdentity(tricky5x5 * tricky5x5.inverse());
    });

    test('Inverse of singular matrices throws', () {
      final singular1x1 = fromRows(const [
        [0],
      ]);
      final singular2x2 = fromRows(const [
        [1, 2],
        [2, 4],
      ]);
      final singular3x3 = fromRows(const [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ]);

      expect(singular1x1.inverse, throwsA(isA<MatrixException>()));
      expect(singular2x2.inverse, throwsA(isA<MatrixException>()));
      expect(singular3x3.inverse, throwsA(isA<MatrixException>()));
    });

    test('Rank of square matrices', () {
      final singular = fromRows(const [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ]);

      expect(singular.rank(), equals(2));
      expect(tricky5x5.rank(), equals(5));
      expect(RealMatrix(rows: 4, columns: 4).rank(), isZero);

      // The rank doesn't depend on the scale of the data
      final tiny = RealMatrix.diagonal(
        rows: 3,
        columns: 3,
        diagonalValue: 1e-20,
      );
      expect(tiny.rank(), equals(3));
    });

    test('Minor bounds are validated', () {
      final matrix = fromRows(const [
        [1, 2],
        [3, 4],
      ]);

      expect(() => matrix.minor(2, 0), throwsA(isA<MatrixException>()));
      expect(() => matrix.minor(0, 2), throwsA(isA<MatrixException>()));
      expect(matrix.minor(1, 0).flattenData, orderedEquals(<double>[2]));
    });

    test('Cholesky decomposition reconstructs the matrix', () {
      final matrix = fromRows(const [
        [4, 12, -16],
        [12, 37, -43],
        [-16, -43, 98],
      ]);

      final cholesky = matrix.choleskyDecomposition();

      expect(cholesky[1], equals(cholesky.first.transpose()));
      expect(cholesky.first * cholesky[1], equals(matrix));
    });
  });

  group('Edge cases', () {
    /// A matrix with random elements in [-1, 1].
    RealMatrix randomMatrix(int rows, int columns, Random random) =>
        RealMatrix.fromFlattenedData(
          rows: rows,
          columns: columns,
          data: List<double>.generate(
            rows * columns,
            (_) => random.nextDouble() * 2 - 1,
          ),
        );

    /// A random, diagonally dominant (hence invertible) matrix.
    RealMatrix invertibleMatrix(int n, Random random) =>
        randomMatrix(n, n, random) +
        RealMatrix.diagonal(rows: n, columns: n, diagonalValue: n.toDouble());

    /// The [matrix] with every element multiplied by [factor].
    RealMatrix scaled(RealMatrix matrix, double factor) =>
        RealMatrix.fromFlattenedData(
          rows: matrix.rowCount,
          columns: matrix.columnCount,
          data: matrix.flattenData.map((value) => value * factor).toList(),
        );

    /// Expects [actual] to be close to [expected], relative to its magnitude.
    void expectClose(
      double actual,
      double expected, [
      double tolerance = 1e-9,
    ]) {
      expect(
        actual,
        MoreOrLessEquals(
          expected,
          precision: tolerance * max(1, expected.abs()),
        ),
      );
    }

    final identity3 = RealMatrix(rows: 3, columns: 3, identity: true);

    group('Data integrity', () {
      test('Constructors copy the source data', () {
        final flat = <double>[1, 2, 3, 4];
        final rows = <List<double>>[
          [1, 2],
          [3, 4],
        ];
        final fromFlat = RealMatrix.fromFlattenedData(
          rows: 2,
          columns: 2,
          data: flat,
        );
        final fromRows = RealMatrix.fromData(rows: 2, columns: 2, data: rows);

        flat[0] = 99;
        rows.first[0] = 99;

        expect(fromFlat(0, 0), equals(1));
        expect(fromRows(0, 0), equals(1));
      });

      test('The flattened data is read-only', () {
        final matrix = RealMatrix(rows: 2, columns: 2);

        expect(() => matrix.flattenData[0] = 1, throwsUnsupportedError);
      });

      test('List conversions return independent copies', () {
        final matrix = RealMatrix.fromFlattenedData(
          rows: 2,
          columns: 2,
          data: const [1, 2, 3, 4],
        );

        final list = matrix.toList()..[0] = 99;
        final rows = matrix.toListOfList();
        rows.first[0] = 99;

        expect(list.first, equals(99));
        expect(matrix(0, 0), equals(1));
        expect(() => rows.add([]), throwsUnsupportedError);
      });

      test('Operators do not modify the operands', () {
        final random = Random(1);
        final a = invertibleMatrix(3, random);
        final b = invertibleMatrix(3, random);
        final copyA = RealMatrix.fromFlattenedData(
          rows: 3,
          columns: 3,
          data: a.toList(),
        );
        final copyB = RealMatrix.fromFlattenedData(
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
        const data = <double>[1, 2, 3, 4];
        final shapes = [(1, 4), (2, 2), (4, 1)]
            .map(
              (shape) => RealMatrix.fromFlattenedData(
                rows: shape.$1,
                columns: shape.$2,
                data: data,
              ),
            )
            .toList();

        for (var i = 0; i < shapes.length; i++) {
          for (var j = 0; j < shapes.length; j++) {
            expect(shapes[i] == shapes[j], i == j);
          }
        }
      });

      test('Negative zero is equal to positive zero', () {
        final negative = RealMatrix.fromFlattenedData(
          rows: 1,
          columns: 2,
          data: const [-0.0, 1],
        );
        final positive = RealMatrix.fromFlattenedData(
          rows: 1,
          columns: 2,
          data: const [0, 1],
        );

        expect(negative, equals(positive));
        expect(negative.hashCode, equals(positive.hashCode));
      });

      test('Matrices containing NaN are only equal to themselves', () {
        RealMatrix nanMatrix() => RealMatrix.fromFlattenedData(
          rows: 1,
          columns: 1,
          data: const [double.nan],
        );
        final matrix = nanMatrix();

        expect(matrix, equals(matrix));
        expect(matrix, isNot(equals(nanMatrix())));
      });

      test('Real and complex matrices are never equal', () {
        final real = RealMatrix(rows: 2, columns: 2, identity: true);
        final complex = ComplexMatrix(rows: 2, columns: 2, identity: true);

        expect(real, isNot(equals(complex)));
      });
    });

    group('Indexing and formatting', () {
      test('Out of bounds indices throw', () {
        final matrix = RealMatrix(rows: 2, columns: 3);
        const invalid = [(-1, 0), (0, -1), (2, 0), (0, 3)];

        for (final (row, col) in invalid) {
          expect(() => matrix(row, col), throwsA(isA<MatrixException>()));
          expect(
            () => matrix.itemAt(row, col),
            throwsA(isA<MatrixException>()),
          );
        }

        // transposedValue(row, col) reads the element at (col, row)
        expect(matrix.transposedValue(2, 1), equals(0));
        expect(
          () => matrix.transposedValue(1, 2),
          throwsA(isA<MatrixException>()),
        );
      });

      test('Single row, single column and single element matrices', () {
        expect(
          RealMatrix.fromFlattenedData(
            rows: 1,
            columns: 1,
            data: const [5],
          ).toString(),
          equals('[5.0]'),
        );
        expect(
          RealMatrix.fromFlattenedData(
            rows: 1,
            columns: 3,
            data: const [1, 2, 3],
          ).toString(),
          equals('[1.0, 2.0, 3.0]'),
        );
        expect(
          RealMatrix.fromFlattenedData(
            rows: 3,
            columns: 1,
            data: const [1, 2, 3],
          ).toString(),
          equals('[1.0]\n[2.0]\n[3.0]'),
        );
      });
    });

    group('Arithmetic', () {
      test('Block multiplication matches the naive product', () {
        final random = Random(2);

        // The block size is 32: these shapes cross the block boundaries
        for (final (n, m, p) in const [
          (33, 34, 35),
          (64, 65, 1),
          (1, 40, 70),
        ]) {
          final a = randomMatrix(n, m, random);
          final b = randomMatrix(m, p, random);

          final expected = List<double>.generate(n * p, (index) {
            final i = index ~/ p;
            final j = index % p;
            var sum = 0.0;
            for (var k = 0; k < m; k++) {
              sum += a(i, k) * b(k, j);
            }

            return sum;
          });

          expectRealMatrixClose(
            a * b,
            RealMatrix.fromFlattenedData(rows: n, columns: p, data: expected),
          );
        }
      });

      test('Products with the identity, the zero matrix and vectors', () {
        final random = Random(3);
        final a = randomMatrix(3, 3, random);

        expect(a * identity3, equals(a));
        expect(identity3 * a, equals(a));
        expect((a * RealMatrix(rows: 3, columns: 2)).isZero(), isTrue);

        final row = RealMatrix.fromFlattenedData(
          rows: 1,
          columns: 3,
          data: const [1, 2, 3],
        );
        final column = row.transpose();

        // Inner product: 1 + 4 + 9
        expect(
          row * column,
          equals(
            RealMatrix.fromFlattenedData(rows: 1, columns: 1, data: const [14]),
          ),
        );

        // Outer product
        expect(
          (column * row).flattenData,
          orderedEquals(const <double>[1, 2, 3, 2, 4, 6, 3, 6, 9]),
        );
      });

      test('Algebraic properties of the operators', () {
        final random = Random(4);
        final a = randomMatrix(3, 4, random);
        final b = randomMatrix(4, 2, random);
        final c = randomMatrix(2, 5, random);
        final d = randomMatrix(4, 2, random);

        expect(a + a.transpose().transpose(), equals(a + a));
        expect((a - a).isZero(), isTrue);
        expectRealMatrixClose((a * b) * c, a * (b * c));
        expectRealMatrixClose(a * (b + d), a * b + a * d);
        expectRealMatrixClose(
          (a * b).transpose(),
          b.transpose() * a.transpose(),
        );
        expect((b + d).transpose(), equals(b.transpose() + d.transpose()));
      });

      test('Element-wise division follows the IEEE 754 rules', () {
        final dividend = RealMatrix.fromFlattenedData(
          rows: 1,
          columns: 3,
          data: const [1, -1, 0],
        );
        final quotient = dividend / RealMatrix(rows: 1, columns: 3);

        expect(quotient(0, 0), equals(double.infinity));
        expect(quotient(0, 1), equals(double.negativeInfinity));
        expect(quotient(0, 2).isNaN, isTrue);
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

      test('Transposing, scaling and swapping rows', () {
        final random = Random(6);

        for (var n = 1; n <= 7; n++) {
          final a = randomMatrix(n, n, random);
          final determinant = a.determinant();

          expectClose(a.transpose().determinant(), determinant);
          expectClose(
            scaled(a, 2).determinant(),
            pow(2, n) * determinant,
          );

          if (n > 1) {
            // Swapping the first two rows flips the sign
            final rows = a.toListOfList();
            final first = rows.first;
            rows[0] = rows[1];
            rows[1] = first;

            expectClose(
              RealMatrix.fromData(
                rows: n,
                columns: n,
                data: rows,
              ).determinant(),
              -determinant,
            );
          }
        }
      });

      test('Triangular matrices', () {
        final random = Random(7);

        for (var n = 1; n <= 7; n++) {
          final triangular = RealMatrix.fromFlattenedData(
            rows: n,
            columns: n,
            data: List<double>.generate(
              n * n,
              (k) => k ~/ n <= k % n ? random.nextDouble() + 0.5 : 0,
            ),
          );

          final diagonalProduct = List<double>.generate(
            n,
            (i) => triangular(i, i),
          ).fold<double>(1, (product, value) => product * value);

          expectClose(triangular.determinant(), diagonalProduct);
          expectClose(triangular.transpose().determinant(), diagonalProduct);
        }
      });

      test('Closed formulas agree with the Laplace expansion', () {
        final random = Random(8);

        // The 4x4 formula is checked against 3x3 minors and the LU-based
        // 5x5 determinant against 4x4 minors.
        for (final n in const [4, 5]) {
          final a = randomMatrix(n, n, random);
          var expansion = 0.0;
          for (var j = 0; j < n; j++) {
            final term = a(0, j) * a.minor(0, j).determinant();
            expansion += j.isEven ? term : -term;
          }

          expectClose(a.determinant(), expansion);
        }
      });
    });

    group('Inverse', () {
      test('Round trip for every algorithm (1x1, 2x2 and LU)', () {
        final random = Random(9);

        for (var n = 1; n <= 8; n++) {
          final a = invertibleMatrix(n, random);
          final inverse = a.inverse();
          final identity = RealMatrix(rows: n, columns: n, identity: true);

          expectRealMatrixClose(a * inverse, identity);
          expectRealMatrixClose(inverse * a, identity);
          expectRealMatrixClose(inverse.inverse(), a);
        }
      });

      test('Special matrices', () {
        expect(identity3.inverse(), equals(identity3));

        final permutation = RealMatrix.fromFlattenedData(
          rows: 3,
          columns: 3,
          data: const [0, 1, 0, 0, 0, 1, 1, 0, 0],
        );
        expect(permutation.inverse(), equals(permutation.transpose()));

        for (final n in const [2, 4]) {
          final diagonal = RealMatrix.diagonal(
            rows: n,
            columns: n,
            diagonalValue: 4,
          );
          expect(
            diagonal.inverse(),
            equals(
              RealMatrix.diagonal(rows: n, columns: n, diagonalValue: 0.25),
            ),
          );
        }
      });

      test('The inverse does not depend on the scale of the data', () {
        final random = Random(10);

        for (final n in const [2, 4]) {
          final a = invertibleMatrix(n, random);
          final expected = a.inverse();

          for (final factor in const [1e-200, 1e200]) {
            expectRealMatrixClose(
              scaled(scaled(a, factor).inverse(), factor),
              expected,
            );
          }
        }
      });

      test('Numerically singular matrices are rejected', () {
        final matrices = [
          RealMatrix.fromFlattenedData(
            rows: 2,
            columns: 2,
            data: const [0.1, 0.2, 0.2, 0.4],
          ),
          RealMatrix(rows: 2, columns: 2),
          RealMatrix(rows: 4, columns: 4),
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

          expectRealMatrixClose(
            a * adjugate,
            RealMatrix.diagonal(
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
        final d = randomMatrix(3, 3, random);

        expectClose((a * b).trace(), (b * a).trace());
        expectClose((c + d).trace(), c.trace() + d.trace());
        expect(c.transpose().trace(), equals(c.trace()));
      });

      test('Rank of products and rectangular matrices', () {
        final random = Random(13);
        final rankTwo = randomMatrix(5, 2, random) * randomMatrix(2, 6, random);

        expect(rankTwo.rank(), equals(2));
        expect(rankTwo.transpose().rank(), equals(2));
        expect(randomMatrix(4, 6, random).rank(), equals(4));
        expect(randomMatrix(6, 4, random).rank(), equals(4));
        expect(RealMatrix(rows: 3, columns: 4).rank(), isZero);
        expect(RealMatrix(rows: 5, columns: 5, identity: true).rank(), 5);
        expect(
          RealMatrix.fromFlattenedData(
            rows: 1,
            columns: 4,
            data: const [0, 0, 3, 0],
          ).rank(),
          equals(1),
        );
      });

      test('The rank does not depend on the scale of the data', () {
        final random = Random(14);
        final rankTwo = randomMatrix(4, 2, random) * randomMatrix(2, 4, random);

        for (final factor in const <double>[1e-150, 1, 1e150]) {
          expect(scaled(rankTwo, factor).rank(), equals(2));
        }
      });
    });

    group('Predicates', () {
      test('Rectangular matrices', () {
        final diagonal = RealMatrix.diagonal(
          rows: 2,
          columns: 3,
          diagonalValue: 1,
        );
        final notDiagonal = RealMatrix.fromFlattenedData(
          rows: 2,
          columns: 3,
          data: const [1, 0, 0, 0, 1, 1],
        );

        expect(diagonal.isDiagonal(), isTrue);
        expect(diagonal.isSymmetric(), isFalse);
        expect(diagonal.isIdentity(), isFalse);
        expect(notDiagonal.isDiagonal(), isFalse);
      });

      test('Negative zeros count as zeros', () {
        final matrix = RealMatrix.fromFlattenedData(
          rows: 2,
          columns: 2,
          data: const [1, -0.0, -0.0, 1],
        );

        expect(matrix.isIdentity(), isTrue);
        expect(matrix.isDiagonal(), isTrue);
        expect(matrix.isSymmetric(), isTrue);
        expect(
          RealMatrix.fromFlattenedData(
            rows: 1,
            columns: 2,
            data: const [-0.0, 0],
          ).isZero(),
          isTrue,
        );
      });
    });

    group('Characteristic polynomial and eigenvalues', () {
      test('Coefficients are related to the trace and the determinant', () {
        final random = Random(15);

        for (var n = 1; n <= 6; n++) {
          final a = randomMatrix(n, n, random);
          final coefficients = a.characteristicPolynomial().coefficients;

          expect(coefficients.length, equals(n + 1));
          expect(coefficients.first, equals(const Complex.fromReal(1)));
          expectClose(coefficients[1].real, -a.trace());
          expectClose(
            coefficients.last.real,
            (n.isEven ? 1 : -1) * a.determinant(),
          );
        }
      });

      test('Eigenvalues sum to the trace and multiply to the determinant', () {
        final random = Random(16);

        for (var n = 1; n <= 6; n++) {
          final a = randomMatrix(n, n, random);
          final eigenvalues = a.eigenvalues();

          final sum = eigenvalues.fold<Complex>(
            const Complex.zero(),
            (total, value) => total + value,
          );
          final product = eigenvalues.fold<Complex>(
            const Complex.fromReal(1),
            (total, value) => total * value,
          );

          expect(eigenvalues.length, equals(n));
          expectClose(sum.real, a.trace());
          expect(sum.imaginary, const MoreOrLessEquals(0, precision: 1e-9));
          expectClose(product.real, a.determinant());
          expect(product.imaginary, const MoreOrLessEquals(0, precision: 1e-9));
        }
      });

      test('Square-only methods reject non-square matrices', () {
        final matrix = RealMatrix(rows: 2, columns: 3);
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
        final [l, u, p] = identity3.luDecomposition();
        expect(l, equals(identity3));
        expect(u, equals(identity3));
        expect(p, equals(identity3));

        final permutation = RealMatrix.fromFlattenedData(
          rows: 3,
          columns: 3,
          data: const [0, 0, 1, 1, 0, 0, 0, 1, 0],
        );
        final [pl, pu, pp] = permutation.luDecomposition();
        expect(pl, equals(identity3));
        expect(pu, equals(identity3));
        expect(pp * permutation, equals(identity3));
      });

      test('LU factors have the right structure', () {
        final random = Random(17);

        for (var n = 1; n <= 7; n++) {
          final a = randomMatrix(n, n, random);
          final [l, u, p] = a.luDecomposition();

          for (var i = 0; i < n; i++) {
            expect(l(i, i), equals(1));

            // Partial pivoting keeps the multipliers in [-1, 1]
            for (var j = 0; j < i; j++) {
              expect(l(i, j).abs(), lessThanOrEqualTo(1));
              expect(u(i, j), isZero);
            }
            for (var j = i + 1; j < n; j++) {
              expect(l(i, j), isZero);
            }
          }

          expectRealMatrixClose(
            p * p.transpose(),
            RealMatrix(
              rows: n,
              columns: n,
              identity: true,
            ),
          );
          expectRealMatrixClose(p * a, l * u);
        }
      });

      test('Cholesky rejects matrices that are not positive-definite', () {
        final matrices = [
          // Indefinite: the eigenvalues are 3 and -1
          RealMatrix.fromFlattenedData(
            rows: 2,
            columns: 2,
            data: const [1, 2, 2, 1],
          ),
          RealMatrix(rows: 3, columns: 3),
          RealMatrix.fromFlattenedData(rows: 1, columns: 1, data: const [-4]),
        ];

        for (final matrix in matrices) {
          expect(
            matrix.choleskyDecomposition,
            throwsA(isA<SystemSolverException>()),
          );
        }
      });

      test('Cholesky of random positive-definite matrices', () {
        final random = Random(18);

        for (var n = 1; n <= 6; n++) {
          final b = randomMatrix(n, n, random);
          final a =
              b.transpose() * b +
              RealMatrix(rows: n, columns: n, identity: true);
          final [l, lt] = a.choleskyDecomposition();

          expect(lt, equals(l.transpose()));
          for (var i = 0; i < n; i++) {
            expect(l(i, i), greaterThan(0));
            for (var j = i + 1; j < n; j++) {
              expect(l(i, j), isZero);
            }
          }
          expectRealMatrixClose(l * lt, a);
        }
      });
    });
  });
}
