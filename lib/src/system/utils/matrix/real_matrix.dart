import 'dart:math';

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/eigenvalue_decomposition/eigendecomposition_real.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_real_decomposition.dart';
import 'package:equations/src/system/utils/matrix/decompositions/singular_value_decomposition/svd_real.dart';

/// The machine epsilon of [double], which is the difference between 1 and the
/// smallest [double] greater than 1.
const _epsilon = 2.220446049250313e-16;

/// Thrown when an operation requires a square matrix.
const _notSquareError = MatrixException('The matrix must be square.');

/// Thrown when an element-wise operation is applied to matrices with
/// different shapes.
const _shapeMismatchError = MatrixException(
  'The two matrices must have the same number of rows and columns.',
);

/// Thrown when an operation requires an invertible matrix.
const _singularMatrixError = MatrixException('The matrix is singular.');

/// The compact result of the LU factorization with partial pivoting of a
/// square `n x n` matrix `A`, such that `P x A = L x U`.
///
///  - `lu`: a flattened `n x n` matrix in row-major order. The elements above
///    and on the main diagonal belong to `U`, while the elements below the
///    main diagonal are the multipliers of `L` (whose diagonal is made of
///    ones and is not stored).
///  - `permutation`: row `i` of `P x A` is row `permutation[i]` of `A`.
///  - `isOddPermutation`: whether an odd number of row swaps was performed,
///    in which case `det(P) = -1`.
typedef _LUFactors = ({
  List<double> lu,
  List<int> permutation,
  bool isOddPermutation,
});

/// A Dart implementation of an `NxM` matrix whose data type is [double].
///
/// ```dart
/// final matrix = RealMatrix(
///   rows: 3,
///   columns: 4,
/// );
/// ```
///
/// By default, the cells of a matrix are initialized with zeroes. You can
/// access elements of the matrix very conveniently with the following syntax:
///
/// ```dart
/// final matrix = RealMatrix(
///   rows: 6,
///   columns: 6,
/// );
///
/// final value1 = matrix(2, 3);
/// final value2 = matrix.itemAt(2, 3);
/// ```
///
/// Both versions return the same value but the first one is less verbose and
/// preferred. In the example, `value1` holds the value of the element at
/// position `(2, 3)` in the matrix.
base class RealMatrix extends Matrix<double> {
  /// {@macro matrix_constructor_intro}
  new({required super.rows, required super.columns, super.identity})
    : super(defaultValue: 0, identityOneValue: 1);

  /// {@macro matrix_fromData_constructor}
  new fromData({
    required super.rows,
    required super.columns,
    required super.data,
  }) : super.fromData();

  /// {@macro matrix_fromFlattenedData_constructor}
  new fromFlattenedData({
    required super.rows,
    required super.columns,
    required super.data,
  }) : super.fromFlattenedData();

  /// {@macro matrix_diagonal_constructor}
  new diagonal({
    required super.rows,
    required super.columns,
    required super.diagonalValue,
  }) : super.diagonal(defaultValue: 0);

  @override
  RealMatrix operator +(Matrix<double> other) {
    _checkSameShape(other);

    final a = flattenData;
    final b = other.flattenData;

    return RealMatrix.fromFlattenedData(
      rows: rowCount,
      columns: columnCount,
      data: List<double>.generate(a.length, (i) => a[i] + b[i]),
    );
  }

  @override
  RealMatrix operator -(Matrix<double> other) {
    _checkSameShape(other);

    final a = flattenData;
    final b = other.flattenData;

    return RealMatrix.fromFlattenedData(
      rows: rowCount,
      columns: columnCount,
      data: List<double>.generate(a.length, (i) => a[i] - b[i]),
    );
  }

  @override
  RealMatrix operator *(Matrix<double> other) {
    if (columnCount != other.rowCount) {
      throw const MatrixException(
        'The column count of this matrix must match the row count of the '
        'other matrix.',
      );
    }

    final flatMatrix = List<double>.filled(rowCount * other.columnCount, 0);
    final n = rowCount;
    final m = columnCount;
    final p = other.columnCount;
    final a = flattenData;
    final b = other.flattenData;

    // Block multiplication for better cache locality
    const blockSize = 32;
    for (var ii = 0; ii < n; ii += blockSize) {
      final iEnd = (ii + blockSize < n) ? ii + blockSize : n;
      for (var jj = 0; jj < p; jj += blockSize) {
        final jEnd = (jj + blockSize < p) ? jj + blockSize : p;
        for (var kk = 0; kk < m; kk += blockSize) {
          final kEnd = (kk + blockSize < m) ? kk + blockSize : m;

          // Multiply blocks
          for (var i = ii; i < iEnd; i++) {
            for (var j = jj; j < jEnd; j++) {
              var sum = 0.0;
              for (var k = kk; k < kEnd; k++) {
                sum += a[m * i + k] * b[p * k + j];
              }
              flatMatrix[p * i + j] += sum;
            }
          }
        }
      }
    }

    return RealMatrix.fromFlattenedData(
      rows: rowCount,
      columns: other.columnCount,
      data: flatMatrix,
    );
  }

  @override
  RealMatrix operator /(Matrix<double> other) {
    _checkSameShape(other);

    final a = flattenData;
    final b = other.flattenData;

    return RealMatrix.fromFlattenedData(
      rows: rowCount,
      columns: columnCount,
      data: List<double>.generate(a.length, (i) => a[i] / b[i]),
    );
  }

  @override
  RealMatrix transpose() {
    final a = flattenData;

    return RealMatrix.fromFlattenedData(
      rows: columnCount,
      columns: rowCount,
      data: List<double>.generate(a.length, (k) {
        final r = k ~/ rowCount;
        final c = k % rowCount;

        return a[columnCount * c + r];
      }),
    );
  }

  @override
  RealMatrix minor(int row, int col) {
    if (rowCount == 1 || columnCount == 1) {
      throw const MatrixException(
        'Cannot compute minors when "rowCount" or "columnCount" is 1.',
      );
    }

    if (row < 0 || row >= rowCount || col < 0 || col >= columnCount) {
      throw MatrixException('The ($row, $col) position is out of bounds.');
    }

    final a = flattenData;
    final minorColumns = columnCount - 1;

    return RealMatrix.fromFlattenedData(
      rows: rowCount - 1,
      columns: minorColumns,
      data: List<double>.generate((rowCount - 1) * minorColumns, (k) {
        final i = k ~/ minorColumns;
        final j = k % minorColumns;
        final sourceRow = i < row ? i : i + 1;
        final sourceCol = j < col ? j : j + 1;

        return a[columnCount * sourceRow + sourceCol];
      }),
    );
  }

  @override
  RealMatrix cofactorMatrix() {
    if (!isSquareMatrix) {
      throw _notSquareError;
    }

    // By convention, the cofactor matrix of an 1x1 matrix is [1].
    if (rowCount == 1) {
      return RealMatrix.fromFlattenedData(rows: 1, columns: 1, data: [1]);
    }

    final n = rowCount;
    return RealMatrix.fromFlattenedData(
      rows: n,
      columns: n,
      data: List<double>.generate(n * n, (k) {
        final i = k ~/ n;
        final j = k % n;
        final minorDeterminant = minor(i, j).determinant();

        return (i + j).isEven ? minorDeterminant : -minorDeterminant;
      }, growable: false),
    );
  }

  @override
  RealMatrix inverse() {
    if (!isSquareMatrix) {
      throw _notSquareError;
    }

    // The inverse of an 1x1 matrix "A" is simply "1/A(0,0)"
    if (rowCount == 1) {
      final value = flattenData.first;
      if (value == 0) {
        throw _singularMatrixError;
      }

      return RealMatrix.fromFlattenedData(
        rows: 1,
        columns: 1,
        data: [1 / value],
      );
    }

    // In case of 2x2 matrix, we can directly compute it and save computational
    // time. The matrix is considered singular when its determinant is
    // negligible compared to the elements.
    if (rowCount == 2) {
      final scale = _powerOfTwoNear(_maxAbs());
      if (scale == 0) {
        throw _singularMatrixError;
      }

      final a = flattenData
          .map((value) => value / scale)
          .toList(growable: false);
      final maxAbs = a.fold<double>(0, (m, value) => max(m, value.abs()));
      final determinant = a.first * a[3] - a[1] * a[2];

      if (determinant.abs() <= 2 * maxAbs * _epsilon * maxAbs) {
        throw _singularMatrixError;
      }

      final mult = 1 / (determinant * scale);

      return RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: [mult * a[3], -mult * a[1], -mult * a[2], mult * a.first],
      );
    }

    // For 3x3 matrices and bigger, use the LU factorization: P x A = L x U.
    // The j-th column of the inverse is the solution of A x = e_j, which is
    // found by solving L y = P e_j (forward) and then U x = y (backward). The
    // matrix is considered singular when a pivot is negligible compared to
    // the elements.
    final tolerance = _pivotTolerance();
    final factors = _factorize();
    final n = rowCount;
    final lu = factors.lu;
    final permutation = factors.permutation;

    for (var i = 0; i < n; ++i) {
      if (lu[n * i + i].abs() <= tolerance) {
        throw _singularMatrixError;
      }
    }

    final inverse = List<double>.filled(n * n, 0);
    final column = List<double>.filled(n, 0);

    for (var j = 0; j < n; ++j) {
      for (var i = 0; i < n; ++i) {
        var sum = permutation[i] == j ? 1.0 : 0.0;
        for (var k = 0; k < i; ++k) {
          sum -= lu[n * i + k] * column[k];
        }
        column[i] = sum;
      }
      for (var i = n - 1; i >= 0; --i) {
        var sum = column[i];
        for (var k = i + 1; k < n; ++k) {
          sum -= lu[n * i + k] * column[k];
        }
        column[i] = sum / lu[n * i + i];
      }

      for (var i = 0; i < n; ++i) {
        inverse[n * i + j] = column[i];
      }
    }

    return RealMatrix.fromFlattenedData(rows: n, columns: n, data: inverse);
  }

  @override
  double trace() {
    if (!isSquareMatrix) {
      throw _notSquareError;
    }

    final a = flattenData;
    var trace = 0.0;
    for (var i = 0; i < rowCount; ++i) {
      trace += a[columnCount * i + i];
    }

    return trace;
  }

  @override
  bool isDiagonal() {
    final a = flattenData;
    for (var k = 0; k < a.length; ++k) {
      if ((k ~/ columnCount != k % columnCount) && (a[k] != 0)) {
        return false;
      }
    }
    return true;
  }

  @override
  bool isIdentity() {
    if (!isSquareMatrix) {
      return false;
    }

    for (var k = 0; k < flattenData.length; ++k) {
      final expected = (k ~/ columnCount == k % columnCount) ? 1.0 : 0.0;
      if (flattenData[k] != expected) {
        return false;
      }
    }

    return true;
  }

  @override
  int rank() {
    final tolerance = _pivotTolerance();
    final m = rowCount;
    final n = columnCount;
    final a = toList();
    var rank = 0;

    for (var col = 0; col < n && rank < m; ++col) {
      var pivotRow = rank;
      for (var i = rank + 1; i < m; ++i) {
        if (a[n * i + col].abs() > a[n * pivotRow + col].abs()) {
          pivotRow = i;
        }
      }

      if (a[n * pivotRow + col].abs() <= tolerance) {
        continue;
      }

      _swapRows(a, n, rank, pivotRow);
      final pivot = a[n * rank + col];
      for (var i = rank + 1; i < m; ++i) {
        final factor = a[n * i + col] / pivot;
        for (var j = col; j < n; ++j) {
          a[n * i + j] -= factor * a[n * rank + j];
        }
      }

      ++rank;
    }

    return rank;
  }

  @override
  double determinant() {
    if (!isSquareMatrix) {
      throw _notSquareError;
    }

    final a = flattenData;
    switch (rowCount) {
      case 1:
        return a.first;
      case 2:
        return a.first * a[3] - a[1] * a[2];
      case 3:
        return _compute3x3Determinant(a);
      case 4:
        return _compute4x4Determinant(a);
    }

    // For 5x5 matrices and bigger, LU factorization
    final factors = _factorize();
    final n = rowCount;
    var determinant = factors.isOddPermutation ? -1.0 : 1.0;
    for (var i = 0; i < n; ++i) {
      determinant *= factors.lu[n * i + i];
    }

    return determinant;
  }

  @override
  Algebraic characteristicPolynomial() {
    if (!isSquareMatrix) {
      throw _notSquareError;
    }

    if (rowCount == 1) {
      return Linear.realEquation(b: -flattenData.first);
    }

    if (rowCount == 2) {
      return Quadratic.realEquation(b: -trace(), c: determinant());
    }

    // For 3x3 matrices and bigger, Faddeev-LeVerrier algorithm
    var supportMatrix = this;
    var oldTrace = supportMatrix.trace();
    final coefficients = <double>[1, -oldTrace];

    for (var i = 1; i < rowCount; ++i) {
      final diagonal = RealMatrix.diagonal(
        rows: rowCount,
        columns: columnCount,
        diagonalValue: (1 / i) * oldTrace,
      );
      supportMatrix = this * (supportMatrix - diagonal);
      oldTrace = supportMatrix.trace();
      coefficients.add((-1 / (i + 1)) * oldTrace);
    }

    return Algebraic.fromReal(coefficients);
  }

  @override
  List<Complex> eigenvalues() {
    if (!isSquareMatrix) {
      throw _notSquareError;
    }

    if (rowCount == 1 || rowCount == 2) {
      return characteristicPolynomial().solutions();
    }

    // For 3x3 matrices and bigger, use the "eigendecomposition" algorithm.
    final eigenDecomposition = EigendecompositionReal(matrix: this);
    final decomposition = eigenDecomposition.decompose()[1];
    final eigenvalues = <Complex>[];

    for (var i = 0; i < decomposition.rowCount; ++i) {
      final real = decomposition(i, i);
      if (i > 0 && i < (decomposition.rowCount - 1)) {
        final pre = decomposition(i, i - 1);
        final post = decomposition(i, i + 1);
        if (pre == 0 && post == 0) {
          eigenvalues.add(Complex.fromReal(real));
        } else {
          eigenvalues.add(Complex(real, pre == 0 ? post : pre));
        }
      } else {
        if (i == 0) {
          eigenvalues.add(Complex(real, decomposition(i, i + 1)));
        } else {
          eigenvalues.add(Complex(real, decomposition(i, i - 1)));
        }
      }
    }

    return eigenvalues;
  }

  @override
  List<RealMatrix> luDecomposition() {
    if (!isSquareMatrix) {
      throw _notSquareError;
    }

    final factors = _factorize();
    final n = rowCount;
    final lu = factors.lu;

    final L = List<double>.generate(n * n, (k) {
      final i = k ~/ n;
      final j = k % n;
      if (i == j) {
        return 1;
      }

      return i > j ? lu[k] : 0;
    }, growable: false);

    final U = List<double>.generate(
      n * n,
      (k) => (k ~/ n <= k % n) ? lu[k] : 0,
      growable: false,
    );
    final P = List<double>.generate(
      n * n,
      (k) => factors.permutation[k ~/ n] == k % n ? 1 : 0,
      growable: false,
    );

    return [
      RealMatrix.fromFlattenedData(rows: n, columns: n, data: L),
      RealMatrix.fromFlattenedData(rows: n, columns: n, data: U),
      RealMatrix.fromFlattenedData(rows: n, columns: n, data: P),
    ];
  }

  @override
  List<RealMatrix> choleskyDecomposition() {
    if (!isSquareMatrix) {
      throw _notSquareError;
    }

    final n = rowCount;
    final a = flattenData;
    final L = List<double>.filled(n * n, 0);

    // Cholesky-Banachiewicz algorithm: L is computed row by row. Only the
    // lower triangular part of the source matrix is read.
    for (var i = 0; i < n; ++i) {
      for (var j = 0; j <= i; ++j) {
        var sum = 0.0;
        for (var k = 0; k < j; ++k) {
          sum += L[n * i + k] * L[n * j + k];
        }

        if (i == j) {
          final diagonal = a[n * i + i] - sum;
          if (diagonal <= 0) {
            throw const SystemSolverException(
              'The matrix is not positive-definite.',
            );
          }

          L[n * i + i] = sqrt(diagonal);
        } else {
          L[n * i + j] = (a[n * i + j] - sum) / L[n * j + j];
        }
      }
    }

    final lower = RealMatrix.fromFlattenedData(rows: n, columns: n, data: L);

    return [lower, lower.transpose()];
  }

  @override
  List<RealMatrix> qrDecomposition() =>
      QRDecompositionReal(matrix: this).decompose();

  @override
  List<RealMatrix> singleValueDecomposition() =>
      SVDReal(matrix: this).decompose();

  @override
  List<RealMatrix> eigenDecomposition() =>
      EigendecompositionReal(matrix: this).decompose();

  @override
  bool isZero() => flattenData.every((value) => value == 0);

  /// Throws a [MatrixException] if [other] doesn't have the same number of
  /// rows and columns of this matrix.
  void _checkSameShape(Matrix<double> other) {
    if (rowCount != other.rowCount || columnCount != other.columnCount) {
      throw _shapeMismatchError;
    }
  }

  /// The threshold at or below which a pivot is considered to be zero.
  ///
  /// It is relative to the magnitude of the matrix elements and to its size,
  /// so that the result doesn't depend on the scale of the data.
  double _pivotTolerance() => max(rowCount, columnCount) * _maxAbs() * _epsilon;

  /// The power of two closest to [value] from below, or zero if [value] is
  /// zero.
  static double _powerOfTwoNear(double value) =>
      value == 0 ? 0 : pow(2.0, (log(value) / ln2).floor()).toDouble();

  /// The largest absolute value among the elements of the matrix.
  double _maxAbs() => flattenData.fold<double>(
    0,
    (current, value) => max(current, value.abs()),
  );

  /// Swaps rows [first] and [second] of the flattened [data], whose rows have
  /// [columns] elements each.
  static void _swapRows(List<double> data, int columns, int first, int second) {
    if (first == second) {
      return;
    }

    for (var j = 0; j < columns; ++j) {
      final temp = data[columns * first + j];
      data[columns * first + j] = data[columns * second + j];
      data[columns * second + j] = temp;
    }
  }

  /// Computes the LU factorization with partial pivoting of this square
  /// matrix (see [_LUFactors]).
  ///
  /// The factorization always succeeds. If the matrix is singular, at least
  /// one element on the diagonal of `U` is zero (or negligible).
  _LUFactors _factorize() {
    final n = rowCount;
    final lu = toList();
    final permutation = List<int>.generate(n, (i) => i, growable: false);
    var isOddPermutation = false;

    for (var k = 0; k < n; ++k) {
      var pivotRow = k;
      for (var i = k + 1; i < n; ++i) {
        if (lu[n * i + k].abs() > lu[n * pivotRow + k].abs()) {
          pivotRow = i;
        }
      }

      final pivot = lu[n * pivotRow + k];
      if (pivot == 0) {
        continue;
      }

      if (pivotRow != k) {
        _swapRows(lu, n, k, pivotRow);

        final temp = permutation[k];
        permutation[k] = permutation[pivotRow];
        permutation[pivotRow] = temp;

        isOddPermutation = !isOddPermutation;
      }

      for (var i = k + 1; i < n; ++i) {
        final factor = lu[n * i + k] / pivot;
        lu[n * i + k] = factor;

        for (var j = k + 1; j < n; ++j) {
          lu[n * i + j] -= factor * lu[n * k + j];
        }
      }
    }

    return (
      lu: lu,
      permutation: permutation,
      isOddPermutation: isOddPermutation,
    );
  }

  /// Computes the determinant of a 3x3 matrix, given its flattened [a] data.
  static double _compute3x3Determinant(List<double> a) {
    final x = a[0] * (a[4] * a[8] - a[5] * a[7]);
    final y = a[1] * (a[3] * a[8] - a[5] * a[6]);
    final z = a[2] * (a[3] * a[7] - a[4] * a[6]);

    return x - y + z;
  }

  /// Computes the determinant of a 4x4 matrix, given its flattened [a] data.
  ///
  /// The determinant is computed with a Laplace expansion along the last row,
  /// reusing the 2x2 minors of the first two rows.
  static double _compute4x4Determinant(List<double> a) {
    // 2x2 minors of rows 0 and 1 (the suffix lists the columns).
    final m01 = a[0] * a[5] - a[1] * a[4];
    final m02 = a[0] * a[6] - a[2] * a[4];
    final m03 = a[0] * a[7] - a[3] * a[4];
    final m12 = a[1] * a[6] - a[2] * a[5];
    final m13 = a[1] * a[7] - a[3] * a[5];
    final m23 = a[2] * a[7] - a[3] * a[6];

    // 3x3 minors of rows 0, 1 and 2 (the suffix lists the columns).
    final m012 = a[8] * m12 - a[9] * m02 + a[10] * m01;
    final m013 = a[8] * m13 - a[9] * m03 + a[11] * m01;
    final m023 = a[8] * m23 - a[10] * m03 + a[11] * m02;
    final m123 = a[9] * m23 - a[10] * m13 + a[11] * m12;

    return -a[12] * m123 + a[13] * m023 - a[14] * m013 + a[15] * m012;
  }
}
