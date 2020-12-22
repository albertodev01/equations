import 'dart:math';
import 'package:equations/equations.dart';

/// A simple Dart implementation of an `m x n` matrix whose data type is [double].
///
/// ```dart
/// final matrix = ComplexMatrix(
///   rowCount: 3,
///   columnCount: 4,
/// );
/// ```
///
/// By default, the cells of a matrix are initialized with all zeroes. You can
/// access elements of the matrix very conveniently with the following syntax:
///
/// ```dart
/// final matrix = ComplexMatrix(
///   rowCount: 6,
///   columnCount: 6,
/// );
///
/// final value = matrix(2, 3);
/// final value = matrix.itemAt(2, 3);
/// ```
///
/// Both versions return the same value but the first one is of course less
/// verbose and you should prefer it. In the example, we're retrieving the value
/// of the element at position `(1, 3)` in the matrix.
class ComplexMatrix extends Matrix<Complex> {
  /// Creates a new `N x M` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with zeroes.
  ///
  /// If [identity] is set to `true` (by default it's `false`) then the matrix
  /// is initialized with all zeroes **and** the diagonal is filled with ones.
  ComplexMatrix({
    required int rows,
    required int columns,
    bool identity = false,
  }) : super(
          rows: rows,
          columns: columns,
          identity: identity,
          defaultValue: Complex.zero(),
          identityOneValue: Complex.fromReal(1),
        );

  /// Creates a new `N x M` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with values from [data].
  ComplexMatrix.fromData({
    required int rows,
    required int columns,
    required List<List<Complex>> data,
  }) : super.fromData(
          rows: rows,
          columns: columns,
          data: data,
        );

  /// Returns the sum of two matrices.
  @override
  Matrix<Complex> operator +(Matrix<Complex> other) {
    if ((rowCount != other.rowCount) || (columnCount != other.columnCount)) {
      throw const MatrixException("Matrices shapes mismatch! The column count "
          "of the source matrix must match the row count of the other.");
    }

    // Performing the sum
    final matrix = List.generate(
        rowCount,
        (_) =>
            List.generate(columnCount, (_) => Complex.zero(), growable: false),
        growable: false);

    for (var i = 0; i < rowCount; ++i) {
      for (var j = 0; j < columnCount; ++j) {
        matrix[i][j] = this(i, j) + other(i, j);
      }
    }

    // Building the new matrix
    return ComplexMatrix.fromData(
        rows: rowCount, columns: columnCount, data: matrix);
  }

  /// Returns the difference of two matrices.
  @override
  Matrix<Complex> operator -(Matrix<Complex> other) {
    if (columnCount != other.rowCount) {
      throw const MatrixException("Matrices shapes mismatch! The column count "
          "of the source matrix must match the row count of the other.");
    }

    // Performing the difference
    final matrix = List.generate(
        rowCount,
        (_) =>
            List.generate(columnCount, (_) => Complex.zero(), growable: false),
        growable: false);

    for (var i = 0; i < rowCount; ++i) {
      for (var j = 0; j < columnCount; ++j) {
        matrix[i][j] = this(i, j) - other(i, j);
      }
    }

    // Building the new matrix
    return ComplexMatrix.fromData(
        rows: rowCount, columns: columnCount, data: matrix);
  }

  /// Returns the sum of two matrices.
  @override
  Matrix<Complex> operator *(Matrix<Complex> other) {
    if (columnCount != other.rowCount) {
      throw const MatrixException("Matrices shapes mismatch! The column count "
          "of the source matrix must match the row count of the other.");
    }

    // Performing the product
    final matrix = List.generate(
        rowCount,
        (_) =>
            List.generate(columnCount, (_) => Complex.zero(), growable: false),
        growable: false);

    // Performing the multiplication
    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < other.columnCount; j++) {
        var sum = Complex.zero();
        for (var k = 0; k < rowCount; k++) {
          sum += (this(i, k) * other(k, j));
        }
        matrix[i][j] = sum;
      }
    }

    // Building the new matrix
    return ComplexMatrix.fromData(
        rows: rowCount, columns: columnCount, data: matrix);
  }

  /// Returns the division of two matrices in `O(n)` complexity.
  @override
  Matrix<Complex> operator /(Matrix<Complex> other) {
    if (columnCount != other.rowCount) {
      throw const MatrixException("Matrices shapes mismatch! The column count "
          "of the source matrix must match the row count of the other.");
    }

    // Performing the difference
    final matrix = List.generate(
        rowCount,
        (_) =>
            List.generate(columnCount, (_) => Complex.zero(), growable: false),
        growable: false);

    // Performing the division
    for (var i = 0; i < rowCount; ++i) {
      for (var j = 0; j < columnCount; ++j) {
        matrix[i][j] = this(i, j) / other(i, j);
      }
    }

    return ComplexMatrix.fromData(
        rows: rowCount, columns: columnCount, data: matrix);
  }

  /// The determinant can only be computed if the matrix is **square**, meaning
  /// that it must have the same number of columns and rows.
  ///
  /// The determinant of a 1*1, 2*2, 3*3 or 4*4 matrix is efficiently computed.
  /// Note that for all the other dimensions, the algorithm is exponentially
  /// slower.
  @override
  Complex determinant() => _computeDeterminant(this);

  /// Computes the determinant of a 2x2 matrix
  Complex _compute2x2Determinant(ComplexMatrix source) {
    return source.flattenData[0] * source.flattenData[3] -
        source.flattenData[1] * source.flattenData[2];
  }

  /// Computes the determinant of a 3x3 matrix
  Complex _compute3x3Determinant(ComplexMatrix source) {
    final x = source.flattenData[0] *
        ((source.flattenData[4] * source.flattenData[8]) -
            (source.flattenData[5] * source.flattenData[7]));
    final y = source.flattenData[1] *
        ((source.flattenData[3] * source.flattenData[8]) -
            (source.flattenData[5] * source.flattenData[6]));
    final z = source.flattenData[2] *
        ((source.flattenData[3] * source.flattenData[7]) -
            (source.flattenData[4] * source.flattenData[6]));

    return x - y + z;
  }

  /// Computes the determinant of a 4x4 matrix
  Complex _compute4x4Determinant(ComplexMatrix source) {
    final det2_01_01 = source.flattenData[0] * source.flattenData[5] -
        source.flattenData[1] * source.flattenData[4];
    final det2_01_02 = source.flattenData[0] * source.flattenData[6] -
        source.flattenData[2] * source.flattenData[4];
    final det2_01_03 = source.flattenData[0] * source.flattenData[7] -
        source.flattenData[3] * source.flattenData[4];
    final det2_01_12 = source.flattenData[1] * source.flattenData[6] -
        source.flattenData[2] * source.flattenData[5];
    final det2_01_13 = source.flattenData[1] * source.flattenData[7] -
        source.flattenData[3] * source.flattenData[5];
    final det2_01_23 = source.flattenData[2] * source.flattenData[7] -
        source.flattenData[3] * source.flattenData[6];

    final det3_201_012 = source.flattenData[8] * det2_01_12 -
        source.flattenData[9] * det2_01_02 +
        source.flattenData[10] * det2_01_01;
    final det3_201_013 = source.flattenData[8] * det2_01_13 -
        source.flattenData[9] * det2_01_03 +
        source.flattenData[11] * det2_01_01;
    final det3_201_023 = source.flattenData[8] * det2_01_23 -
        source.flattenData[10] * det2_01_03 +
        source.flattenData[11] * det2_01_02;
    final det3_201_123 = source.flattenData[9] * det2_01_23 -
        source.flattenData[10] * det2_01_13 +
        source.flattenData[11] * det2_01_12;

    return -det3_201_123 * source.flattenData[12] +
        det3_201_023 * source.flattenData[13] -
        det3_201_013 * source.flattenData[14] +
        det3_201_012 * source.flattenData[15];
  }

  /// Recursively computes the determinant of a matrix. In case of 1x1, 2x2,
  /// 3x3 and 4x4 matrices, the calculations are "manually" done.
  Complex _computeDeterminant(ComplexMatrix source) {
    // Computing the determinant only if the matrix is square
    if (source.rowCount != source.columnCount) {
      throw const MatrixException("Can't compute the determinant of this "
          "matrix because it's not square.");
    }

    // In case there were an 1x1 matrix, just return the value
    if (source.rowCount * source.columnCount == 1) {
      return source.flattenData[0];
    }

    // For efficiency, manually computing a 2x2 matrix
    if (source.rowCount * source.columnCount == 4) {
      return _compute2x2Determinant(source);
    }

    // For efficiency, manually computing a 3x3 matrix
    if (source.rowCount * source.columnCount == 9) {
      return _compute3x3Determinant(source);
    }

    // For efficiency, manually computing a 4x4 matrix
    if (source.rowCount * source.columnCount == 16) {
      return _compute4x4Determinant(source);
    }

    // Computing the determinant for 5x5 matrices and bigger
    var det = Complex.zero();
    final tempMatrix = List.generate(
        source.rowCount - 1,
        (_) => List.generate(source.columnCount - 1, (_) => Complex.zero(),
            growable: false),
        growable: false);

    for (var x = 0; x < source.rowCount; ++x) {
      var subI = 0;
      for (var i = 1; i < source.rowCount; ++i) {
        var subJ = 0;
        for (var j = 0; j < source.rowCount; ++j) {
          if (j == x) {
            continue;
          }
          tempMatrix[subI][subJ] = this(i, j);
          subJ++;
        }
        subI++;
      }

      final matrix = ComplexMatrix.fromData(
          rows: rowCount - 1, columns: columnCount - 1, data: tempMatrix);

      final sign = Complex.fromReal(pow(-1, x) * 1.0);
      det = det + (sign * source(0, x) * _computeDeterminant(matrix));
    }

    return det;
  }
}
