import 'dart:math';

import 'package:equations/equations.dart';

/// A simple Dart implementation of an `m x n` matrix whose data type is [Complex].
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is ComplexMatrix) {
      // The lengths of the data lists must match
      if (flattenData.length != other.flattenData.length) {
        return false;
      }

      // Each successful comparison increases a counter by 1. If all elements
      // are equal, then the counter will match the actual length of the data
      // list.
      var equalsCount = 0;

      for (var i = 0; i < flattenData.length; ++i) {
        if (flattenData[i] == other.flattenData[i]) {
          ++equalsCount;
        }
      }

      // They must have the same runtime type AND all items must be equal.
      return runtimeType == other.runtimeType &&
          equalsCount == flattenData.length &&
          rowCount == other.rowCount &&
          columnCount == other.columnCount;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 83;

    // Like we did in operator== iterating over all elements ensures that the
    // hashCode is properly calculated.
    for (var i = 0; i < flattenData.length; ++i) {
      result = 37 * result + flattenData[i].hashCode;
    }

    result = 37 * result + rowCount.hashCode;
    result = 37 * result + columnCount.hashCode;

    return result;
  }

  /// Returns the sum of two matrices in `O(n)` complexity.
  @override
  Matrix<Complex> operator +(Matrix<Complex> other) {
    final matrix = ComplexMatrix(rows: rowCount, columns: columnCount);

    // Performing the sum
    for (var i = 0; i < flattenData.length; ++i) {
      matrix.flattenData[i] = flattenData[i] + other.flattenData[i];
    }

    return matrix;
  }

  /// Returns the difference of two matrices in `O(n)` complexity.
  @override
  Matrix<Complex> operator -(Matrix<Complex> other) {
    final matrix = ComplexMatrix(rows: rowCount, columns: columnCount);

    // Performing the difference
    for (var i = 0; i < flattenData.length; ++i) {
      matrix.flattenData[i] = flattenData[i] - other.flattenData[i];
    }

    return matrix;
  }

  /// Returns the sum of two matrices in `O(n^3)` complexity.
  @override
  Matrix<Complex> operator *(Matrix<Complex> other) {
    if (columnCount != other.rowCount) {
      throw const MatrixException("Matrices shapes mismatch! The column count "
          "of the source matrix must match the row count of the other.");
    }

    final result = ComplexMatrix(rows: rowCount, columns: other.columnCount);

    // Performing the multiplication
    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < other.columnCount; j++) {
        var sum = Complex.zero();
        for (var k = 0; k < rowCount; k++) {
          sum += (this(i, k) * other(k, j));
        }
        result.flattenData[columnCount * i + j] = sum;
      }
    }

    return result;
  }

  /// Returns the division of two matrices in `O(n)` complexity.
  @override
  Matrix<Complex> operator /(Matrix<Complex> other) {
    final matrix = ComplexMatrix(rows: rowCount, columns: columnCount);

    // Performing the division
    for (var i = 0; i < flattenData.length; ++i) {
      matrix.flattenData[i] = flattenData[i] / other.flattenData[i];
    }

    return matrix;
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
    final tempMatrix = ComplexMatrix(
        rows: source.rowCount - 1, columns: source.columnCount - 1);
    var det = Complex.zero();

    for (var x = 0; x < source.rowCount; ++x) {
      var subI = 0;
      for (var i = 1; i < source.rowCount; ++i) {
        var subJ = 0;
        for (var j = 0; j < source.rowCount; ++j) {
          if (j == x) {
            continue;
          }
          tempMatrix.flattenData[(source.columnCount - 1) * subI + subJ] =
              this(i, j);
          subJ++;
        }
        subI++;
      }

      final sign = Complex.fromReal(pow(-1, x) as double);
      det = det + (sign * source(0, x) * _computeDeterminant(tempMatrix));
    }

    return det;
  }
}
