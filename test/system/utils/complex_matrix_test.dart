import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group("Testing the constructors of the 'ComplexMatrix' class", () {
    test('Making sure that a new matrix is initialized with 0s.', () {
      final matrix = ComplexMatrix(
        columns: 5,
        rows: 3,
      );

      // Checking the sizes
      expect(matrix.rowCount, equals(3));
      expect(matrix.columnCount, equals(5));
      expect(matrix.isSquareMatrix, isFalse);

      // Checking the content of the matrix
      for (var i = 0; i < matrix.rowCount; ++i) {
        for (var j = 0; j < matrix.columnCount; ++j) {
          expect(matrix(i, j), equals(const Complex.zero()));
          expect(matrix(i, j), equals(matrix.itemAt(i, j)));
        }
      }
    });

    test(
      'Making sure that an exception is thrown when the user tries to '
      'build a matrix whose row or column count is zero.',
      () {
        expect(
          () => ComplexMatrix(
            columns: 0,
            rows: 2,
          ),
          throwsA(isA<MatrixException>()),
        );
      },
    );

    test(
      "Making sure that the matrix can correctly be 'flattened' and converted"
      " into a list of 'double' values.",
      () {
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
      },
    );

    test(
      "Making sure that the matrix can correctly be created from a 'flattened'"
      ' list of values.',
      () {
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
          equals(ComplexMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [Complex(1, 2), Complex(3, 4)],
              [Complex(5, 6), Complex(7, 8)],
            ],
          )),
        );
      },
    );

    test(
      'Making sure that a diagonal, square matrix is correctly build with '
      'the given value in the diagonal',
      () {
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

        const stringRepresentation = '[6 + 2i, 0i, 0i]\n'
            '[0i, 6 + 2i, 0i]\n'
            '[0i, 0i, 6 + 2i]';

        expect('$matrix', equals(stringRepresentation));
      },
    );

    test(
      'Making sure that a diagonal, non square matrix is correctly build '
      'with the given value in the diagonal',
      () {
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

        const stringRepresentation = '[6 + 2i, 0i, 0i, 0i, 0i]\n'
            '[0i, 6 + 2i, 0i, 0i, 0i]\n'
            '[0i, 0i, 6 + 2i, 0i, 0i]';

        expect('$matrix', equals(stringRepresentation));
      },
    );

    test(
      'Making sure that a diagonal, non square matrix is correctly build '
      'with the given value in the diagonal',
      () {
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

        const stringRepresentation = '[6 + 2i, 0i]\n'
            '[0i, 6 + 2i]\n'
            '[0i, 0i]\n'
            '[0i, 0i]\n'
            '[0i, 0i]\n'
            '[0i, 0i]';

        expect('$matrix', equals(stringRepresentation));
      },
    );

    test(
      'Making sure that a diagonal of a single element is correctly built',
      () {
        final matrix = RealMatrix.diagonal(
          rows: 1,
          columns: 1,
          diagonalValue: 31,
        );

        expect(matrix(0, 0), equals(31));
        expect('$matrix', equals('[31.0]'));
      },
    );

    test(
      'Making sure that an exception is thrown when the matrix is being built '
      'from a list but the sizes are wrong',
      () {
        expect(
          () => ComplexMatrix.fromFlattenedData(
            rows: 2,
            columns: 2,
            data: const [Complex(1, 2), Complex(1, 1)],
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'Making sure that the identity matrix is filled with 0s except for '
      'its diagonal, which must contain all 1s.',
      () {
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
      },
    );

    test(
      'Making sure that an exception is thrown when the user tries to '
      'build an identity matrix with a non-squared entry.',
      () {
        expect(
          () => ComplexMatrix(columns: 3, rows: 5, identity: true),
          throwsA(isA<MatrixException>()),
        );
      },
    );

    test("Making sure that 'toString()' works as expected.", () {
      final matrix = ComplexMatrix.fromData(columns: 2, rows: 2, data: const [
        [Complex(1, 2), Complex(3, 4)],
        [Complex(5, 6), Complex(6, 7)],
      ]);

      const expected = '[1 + 2i, 3 + 4i]\n[5 + 6i, 6 + 7i]';
      expect(matrix.toString(), equals(expected));
    });

    test(
      'Making sure that a matrix is properly built from a list of lists '
      'entries.',
      () {
        final matrix = ComplexMatrix.fromData(columns: 2, rows: 2, data: const [
          [Complex(1, 2), Complex(3, 4)],
          [Complex(5, 6), Complex(7, 8)],
        ]);

        // Checking the sizes
        expect(matrix.rowCount, equals(2));
        expect(matrix.columnCount, equals(2));

        // Checking the content of the matrix
        expect(matrix(0, 0), equals(const Complex(1, 2)));
        expect(matrix(0, 1), equals(const Complex(3, 4)));
        expect(matrix(1, 0), equals(const Complex(5, 6)));
        expect(matrix(1, 1), equals(const Complex(7, 8)));
      },
    );
  });

  group("Testing equality of 'ComplexMatrix' objects", () {
    test('Making sure that objects comparison works properly.', () {
      final matrix = ComplexMatrix(
        columns: 2,
        rows: 2,
      );

      // Equality tests
      expect(ComplexMatrix(columns: 2, rows: 2), equals(matrix));
      expect(ComplexMatrix(columns: 2, rows: 2) == matrix, isTrue);
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
    });
  });

  group('Testing operation on matrices (+, *, - and /)', () {
    /*
    * A = |    i   3-8i  |
    *     | 4+7i   0     |
    * */
    final matrixA = ComplexMatrix.fromData(columns: 2, rows: 2, data: const [
      [Complex.i(), Complex(3, -8)],
      [Complex(4, 7), Complex.zero()],
    ]);

    /*
    * B = |   5   -7+i  |
    *     |  6i    1+i  |
    * */
    final matrixB = ComplexMatrix.fromData(columns: 2, rows: 2, data: const [
      [Complex.fromReal(5), Complex(-7, 1)],
      [Complex.fromImaginary(6), Complex(1, 1)],
    ]);

    test('Making sure that operator+ works properly.', () {
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

    test('Making sure that operator+ works on rectangular matrices too.', () {
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

    test('Making sure that operator- works properly.', () {
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

    test('Making sure that operator- works on rectangular matrices too.', () {
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

    test('Making sure that operator* works properly.', () {
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

    test('Making sure that operator* works on rectangular matrices too.', () {
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

    test('Making sure that operator/ works properly.', () {
      final divResult = matrixA / matrixB;

      // Comparing members one by one due to machine precision issues
      expect(divResult(0, 0), equals(const Complex(0, 1 / 5)));
      expect(divResult(1, 1), equals(const Complex.zero()));

      // Value at [1, 0]
      expect(
        divResult(1, 0).real,
        const MoreOrLessEquals(7 / 6, precision: 1.0e-3),
      );
      expect(
        divResult(1, 0).imaginary,
        const MoreOrLessEquals(-2 / 3, precision: 1.0e-3),
      );

      // Value at [0, 1]
      expect(
        divResult(0, 1).real,
        const MoreOrLessEquals(-29 / 50, precision: 1.0e-3),
      );
      expect(
        divResult(0, 1).imaginary,
        const MoreOrLessEquals(53 / 50, precision: 1.0e-3),
      );
    });

    test('Making sure that operator/ works on rectangular matrices too.', () {
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
  });

  group('Testing the computation of the determinant.', () {
    test('Making sure that the determinant of an 1*1 matrix is correct.', () {
      final matrix = ComplexMatrix.fromData(
        columns: 1,
        rows: 1,
        data: const [
          [Complex(4, 7)],
        ],
      );
      expect(matrix.determinant(), equals(const Complex(4, 7)));
    });

    test('Making sure that the determinant of a 2*2 matrix is correct.', () {
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

    test('Making sure that the determinant of a 3*3 matrix is correct.', () {
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

    test('Making sure that the determinant of a 4*4 matrix is correct.', () {
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

    test('Making sure that the determinant of a 5*5 matrix is correct.', () {
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

  group('Testing operations on matrices.', () {
    test(
      'Making sure that the LU decomposition properly works on a square '
      'matrix of a given dimension.',
      () {
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
        expect(lu.length, equals(2));

        // Checking L
        final L = lu[0];
        expect(L.rowCount, equals(matrix.rowCount));
        expect(L.columnCount, equals(matrix.columnCount));
        expect(L.isSquareMatrix, isTrue);
        expect(
          L.flattenData,
          orderedEquals(
            const <Complex>[
              Complex.fromReal(1),
              Complex.zero(),
              Complex.zero(),
              Complex.fromReal(4),
              Complex.fromReal(1),
              Complex.zero(),
              Complex.fromReal(7),
              Complex.fromReal(2),
              Complex.fromReal(1),
            ],
          ),
        );

        // Checking U
        final U = lu[1];
        expect(U.rowCount, equals(matrix.rowCount));
        expect(U.columnCount, equals(matrix.columnCount));
        expect(U.isSquareMatrix, isTrue);
        expect(
          U.flattenData,
          orderedEquals(
            const <Complex>[
              Complex.fromReal(1),
              Complex.fromReal(2),
              Complex.fromReal(3),
              Complex.zero(),
              Complex.fromReal(-3),
              Complex.fromReal(-6),
              Complex.zero(),
              Complex.zero(),
              Complex.zero(),
            ],
          ),
        );
      },
    );

    test(
      "Making sure that the LU decomposition properly doesn't work when "
      'the matrix is not square.',
      () {
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
      },
    );

    test(
      'Making sure that Cholesky decomposition properly works on a square '
      'matrix of a given dimension.',
      () {
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
        final L = cholesky[0];
        expect(
          L.flattenData,
          orderedEquals(
            const <Complex>[
              Complex.fromReal(5),
              Complex.zero(),
              Complex.zero(),
              Complex.fromReal(3),
              Complex.fromReal(3),
              Complex.zero(),
              Complex.fromReal(-1),
              Complex.fromReal(1),
              Complex.fromReal(3),
            ],
          ),
        );
        expect(L.rowCount, equals(matrix.rowCount));
        expect(L.columnCount, equals(matrix.columnCount));
        expect(L.isSquareMatrix, isTrue);

        // Checking Lt
        final transposedL = cholesky[1];
        expect(
          transposedL.flattenData,
          orderedEquals(
            const <Complex>[
              Complex.fromReal(5),
              Complex.fromReal(3),
              Complex.fromReal(-1),
              Complex.zero(),
              Complex.fromReal(3),
              Complex.fromReal(1),
              Complex.zero(),
              Complex.zero(),
              Complex.fromReal(3),
            ],
          ),
        );
        expect(transposedL.rowCount, equals(matrix.rowCount));
        expect(transposedL.columnCount, equals(matrix.columnCount));
        expect(transposedL.isSquareMatrix, isTrue);
      },
    );

    test(
      "Making sure that the Cholesky decomposition properly doesn't work "
      'when the matrix is not square.',
      () {
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
      },
    );

    test('Making sure that the transposed view is correct', () {
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

    test('Making sure that the transposed matrix is correct (2x2)', () {
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

    test('Making sure that the transposed matrix is correct (1x3)', () {
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

    test('Making sure that minors are correctly generated', () {
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
        orderedEquals(
          const [
            Complex.i(),
            Complex.zero(),
            Complex.fromReal(6),
            Complex(-3, 7),
          ],
        ),
      );

      // Removing (1; 2)
      final minor2 = matrix.minor(1, 2);
      expect(
        minor2.flattenData,
        orderedEquals(
          const [
            Complex(4, -5),
            Complex(-1, 10),
            Complex(2, 1),
            Complex.fromReal(6),
          ],
        ),
      );

      // Errors
      expect(
        () => matrix.minor(-1, 2),
        throwsA(isA<MatrixException>()),
      );
      expect(
        () => matrix.minor(11, 2),
        throwsA(isA<MatrixException>()),
      );
    });

    test('Making sure that the cofactor matrix is correctly computed', () {
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

    test(
      'Making sure that the cofactor matrix is NOT computed if the source '
      'matrix is NOT square',
      () {
        final matrix = ComplexMatrix.fromData(
          rows: 2,
          columns: 1,
          data: const [
            [Complex.i()],
            [Complex.fromImaginary(3)],
          ],
        );

        expect(() => matrix.cofactorMatrix(), throwsA(isA<MatrixException>()));
      },
    );

    test(
      'Making sure that the inverse matrix is NOT computed if the source '
      'matrix is NOT square',
      () {
        final matrix = ComplexMatrix.fromData(
          rows: 2,
          columns: 1,
          data: const [
            [Complex.i()],
            [Complex.fromImaginary(3)],
          ],
        );

        expect(() => matrix.inverse(), throwsA(isA<MatrixException>()));
      },
    );

    test('Making sure that the inverse of a 2x2 matrix is correct', () {
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

    test('Making sure that the inverse of a matrix is correct', () {
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
      expect(
        matrix(0, 0).imaginary,
        isZero,
      );
      expect(
        matrix(0, 1).real,
        const MoreOrLessEquals(-0.068181, precision: 1.0e-6),
      );
      expect(
        matrix(0, 1).imaginary,
        isZero,
      );
      expect(
        matrix(0, 2).real,
        const MoreOrLessEquals(0.159091, precision: 1.0e-6),
      );
      expect(
        matrix(0, 2).imaginary,
        isZero,
      );
      expect(
        matrix(1, 0).real,
        const MoreOrLessEquals(-0.681818, precision: 1.0e-6),
      );
      expect(
        matrix(1, 0).imaginary,
        isZero,
      );
      expect(
        matrix(1, 1).real,
        const MoreOrLessEquals(-0.136364, precision: 1.0e-6),
      );
      expect(
        matrix(1, 1).imaginary,
        isZero,
      );
      expect(
        matrix(1, 2).real,
        const MoreOrLessEquals(0.318182, precision: 1.0e-6),
      );
      expect(
        matrix(1, 2).imaginary,
        isZero,
      );
      expect(
        matrix(2, 0).real,
        const MoreOrLessEquals(-0.090909, precision: 1.0e-6),
      );
      expect(
        matrix(2, 0).imaginary,
        isZero,
      );
      expect(
        matrix(2, 1).real,
        const MoreOrLessEquals(0.181818, precision: 1.0e-6),
      );
      expect(
        matrix(2, 1).imaginary,
        isZero,
      );
      expect(
        matrix(2, 2).real,
        const MoreOrLessEquals(-0.090909, precision: 1.0e-6),
      );
      expect(
        matrix(2, 2).imaginary,
        isZero,
      );
    });

    test('Making sure that the trace is correctly computed', () {
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

    test('Making sure that symmetric matrices are correctly identified.', () {
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

    test('Making sure that diagonal matrices are correctly identified.', () {
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

    test('Making sure that identity matrices are correctly identified.', () {
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

    test('Making sure that identity matrix is only computed when square.', () {
      final identity = ComplexMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [Complex.fromReal(1), Complex.zero(), Complex.zero()],
          [Complex.zero(), Complex.fromReal(1), Complex.zero()],
        ],
      );

      expect(() => identity.isIdentity(), throwsA(isA<MatrixException>()));
    });

    test('Making sure that the rank can correctly be computed.', () {
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

    test('Making sure that the trace only computed on square matrices', () {
      final matrix = ComplexMatrix.fromData(
        rows: 2,
        columns: 3,
        data: const [
          [Complex.fromImaginary(3), Complex.zero(), Complex.fromReal(-2)],
          [Complex.fromReal(15), Complex(2, -8), Complex.i()],
        ],
      );

      expect(() => matrix.trace(), throwsA(isA<MatrixException>()));
    });

    test('Making sure that eigenvalues can be computed (1x1 matrices)', () {
      final matrix = ComplexMatrix.fromData(
        rows: 1,
        columns: 1,
        data: const [
          [Complex.fromReal(-16)],
        ],
      );

      final eigenvalues = matrix.eigenvalues();

      expect(eigenvalues.length, equals(1));
      expect(eigenvalues[0], equals(const Complex.fromReal(-16)));
    });

    test('Making sure that eigenvalues can be computed (2x2 matrices)', () {
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
        eigenvalues[0].real,
        const MoreOrLessEquals(2.4328, precision: 1.0e-4),
      );
      expect(
        eigenvalues[1].real,
        const MoreOrLessEquals(-2.4328, precision: 1.0e-4),
      );
      expect(
        eigenvalues[0].imaginary,
        const MoreOrLessEquals(0.0889, precision: 1.0e-4),
      );
      expect(
        eigenvalues[1].imaginary,
        const MoreOrLessEquals(0.911, precision: 1.0e-4),
      );
    });

    test('Making sure that eigenvalues can be computed (3x3 matrices)', () {
      final matrix = ComplexMatrix.fromData(
        rows: 3,
        columns: 3,
        data: const [
          [Complex.i(), Complex.fromReal(2), Complex.fromReal(-1)],
          [Complex(3, -1), Complex.zero(), Complex.fromImaginary(-1)],
          [Complex.zero(), Complex.zero(), Complex.fromReal(3)],
        ],
      );

      final eigenvalues = matrix.eigenvalues();

      expect(eigenvalues.length, equals(3));
      expect(
        eigenvalues[0].real,
        const MoreOrLessEquals(2.4328, precision: 1.0e-4),
      );
      expect(
        eigenvalues[1].real,
        const MoreOrLessEquals(-2.4328, precision: 1.0e-4),
      );
      expect(
        eigenvalues[2].real,
        const MoreOrLessEquals(3, precision: 1.0e-4),
      );
      expect(
        eigenvalues[0].imaginary,
        const MoreOrLessEquals(0.0889, precision: 1.0e-4),
      );
      expect(
        eigenvalues[1].imaginary,
        const MoreOrLessEquals(0.911, precision: 1.0e-4),
      );
      expect(
        eigenvalues[2].imaginary,
        isZero,
      );
    });

    test('Batch tests - Minors', () {
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

    test('Batch tests - Cofactor matrix', () {
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
    test('Batch tests - Inverse matrix', () {
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

    test('Batch tests - Rank of a matrix', () {
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

      final ranks = [
        3,
        1,
        2,
        2,
        1,
      ];

      for (var i = 0; i < source.length; ++i) {
        expect(source[i], equals(ranks[i]));
      }
    });

    test('Batch tests - Characteristic polynomial', () {
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
        Algebraic.from(
          [
            const Complex.fromReal(1),
            const Complex(-7, 2),
            const Complex(-17, -16),
            const Complex(191, 46),
          ],
        ),
        Algebraic.from(
          [
            const Complex.fromReal(1),
            const Complex(-7, -2),
            const Complex(-75, 17),
            const Complex(293, -72),
            const Complex(1898, -27),
          ],
        ),
        Algebraic.from(
          [
            const Complex.fromReal(1),
            const Complex.fromReal(-5),
            const Complex(2, -6),
          ],
        ),
        Algebraic.from(
          [
            const Complex.fromReal(1),
            -const Complex.fromReal(14),
          ],
        ),
        Algebraic.from(
          [
            const Complex.fromReal(1),
            -const Complex.fromReal(5),
            const Complex.fromReal(69),
          ],
        ),
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

    test('Batch tests - Eigenvalues', () {
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
        const [
          Complex(4, -2),
        ],
        const [
          Complex(1, 1),
          Complex(-1, 1),
        ],
        const [
          Complex(-0.1837, -0.2127),
          Complex(3.6609, -3.0358),
          Complex(-8.4772, 8.2485),
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
}
