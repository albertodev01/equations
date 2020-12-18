import 'dart:math';

import 'package:equations/equations.dart';

/// A simple Dart implementation of a matrix whose size is `m x n`. Thanks to
/// its generic nature, you can decide to work with `int`, `double` or any other
/// subtype of `num`.
///
/// ```dart
/// final matrix = Matrix(
///   rowCount: 3,
///   columnCount: 4,
/// );
/// ```
///
/// By default, the cells of a matrix are initialized with all zeroes. You can
/// access elements of the matrix very conveniently with the following syntax:
///
/// ```dart
/// final matrix = Matrix(
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
class Matrix {
  /// The number of rows of the matrix.
  final int rowCount;

  /// The number of columns of the matrix.
  final int columnCount;

  /// The internal representation of the matrix.
  late final List<double> _data;

  /// Creates a new `N x M` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with zeroes.
  ///
  /// If [identity] is set to `true` (by default it's `false`) then the matrix
  /// is initialized with all zeroes **and** the diagonal is filled with ones.
  Matrix({
    required int rows,
    required int columns,
    bool identity = false,
  })  : rowCount = rows,
        columnCount = columns {
    // Making sure the user entered valid dimensions for the matrix
    if ((rows == 0) || (columns == 0)) {
      throw const MatrixException("The rows or column count cannot be zero.");
    }

    // Creating a new FIXED length list
    _data = List<double>.filled(rows * columns, 0);

    // The identity matrix has 1 in the diagonal
    if (identity) {
      if (rows != columns) {
        throw const MatrixException("The identity matrix must be square.");
      }

      for (var i = 0; i < rowCount; ++i) {
        _data[columnCount * i + i] = 1;
      }
    }
  }

  /// Creates a new `N x M` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with values from [data].
  Matrix.fromData({
    required int rows,
    required int columns,
    required List<List<double>> data,
  })   : rowCount = rows,
        columnCount = columns {
    // "Flattening" the source into a single list
    _data = data.expand((e) => e).toList();

    // Making sure the size is correct
    if (_data.length != (rows * columns)) {
      throw const MatrixException("The given sizes don't match the size of the "
          "data to be inserted.");
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is Matrix) {
      // The lengths of the data lists must match
      if (_data.length != other._data.length) {
        return false;
      }

      // Each successful comparison increases a counter by 1. If all elements
      // are equal, then the counter will match the actual length of the data
      // list.
      var equalsCount = 0;

      for (var i = 0; i < _data.length; ++i) {
        if (_data[i] == other._data[i]) {
          ++equalsCount;
        }
      }

      // They must have the same runtime type AND all items must be equal.
      return runtimeType == other.runtimeType &&
          equalsCount == _data.length &&
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
    for (var i = 0; i < _data.length; ++i) {
      result = 37 * result + _data[i].hashCode;
    }

    result = 37 * result + rowCount.hashCode;
    result = 37 * result + columnCount.hashCode;

    return result;
  }

  /// Use this method to retrieve the element at a given position in the matrix.
  /// For example:
  ///
  /// ```dart
  /// final matrix = Matrix(
  ///   rowCount: 3,
  ///   columnCount: 3,
  /// );
  ///
  /// final value = matrix(2, 1);
  /// ```
  ///
  /// In the above example, you're accessing the [double] at position `(3, 2)`.
  /// This method is an alias of [itemAt].
  double call(int row, int col) {
    if ((row >= rowCount) || (col >= columnCount)) {
      throw const MatrixException("The given indices are out of the bounds.");
    }

    // Data are stored sequentially so there's the need to work with the indices
    return _data[columnCount * row + col];
  }

  /// Use this method to retrieve the element at a given position in the matrix.
  /// For example:
  ///
  /// ```dart
  /// final matrix = Matrix(
  ///   rowCount: 3,
  ///   columnCount: 3,
  /// );
  ///
  /// final value = matrix.itemAt(2, 1);
  /// ```
  ///
  /// In the above example, you're accessing the [double] at position `(3, 2)`.
  double itemAt(int row, int col) => this(row, col);

  /// Returns the sum of two matrices in `O(n)` complexity.
  Matrix operator +(Matrix other) {
    final matrix = Matrix(rows: rowCount, columns: columnCount);

    // Performing the sum
    for (var i = 0; i < _data.length; ++i) {
      matrix._data[i] = _data[i] + other._data[i];
    }

    return matrix;
  }

  /// Returns the difference of two matrices in `O(n)` complexity.
  Matrix operator -(Matrix other) {
    final matrix = Matrix(rows: rowCount, columns: columnCount);

    // Performing the difference
    for (var i = 0; i < _data.length; ++i) {
      matrix._data[i] = _data[i] - other._data[i];
    }

    return matrix;
  }

  /// Returns the sum of two matrices in `O(n^3)` complexity.
  Matrix operator *(Matrix other) {
    if (columnCount != other.rowCount) {
      throw const MatrixException("Matrices shapes mismatch! The column count "
          "of the source matrix must match the row count of the other.");
    }

    final result = Matrix(rows: rowCount, columns: other.columnCount);

    // Performing the multiplication
    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < other.columnCount; j++) {
        var sum = 0.0;
        for (var k = 0; k < rowCount; k++) {
          sum += (this(i, k) * other(k, j));
        }
        result._data[columnCount * i + j] = sum;
      }
    }

    return result;
  }

  /// Returns the division of two matrices in `O(n)` complexity.
  Matrix operator /(Matrix other) {
    final matrix = Matrix(rows: rowCount, columns: columnCount);

    // Performing the division
    for (var i = 0; i < _data.length; ++i) {
      matrix._data[i] = _data[i] / other._data[i];
    }

    return matrix;
  }

  /// The determinant can only be computed if the matrix is **square**, meaning
  /// that it must have the same number of columns and rows.
  ///
  /// The determinant of a 1*1, 2*2, 3*3 or 4*4 matrix is efficiently computed.
  /// Note that for all the other dimensions, the algorithm is exponentially
  /// slower.
  double determinant() => _computeDeterminant(this);

  /// Computes the determinant of a 2x2 matrix
  double _compute2x2Determinant(Matrix source) {
    return source._data[0] * source._data[3] -
        source._data[1] * source._data[2];
  }

  /// Computes the determinant of a 3x3 matrix
  double _compute3x3Determinant(Matrix source) {
    final x = source._data[0] *
        ((source._data[4] * source._data[8]) -
            (source._data[5] * source._data[7]));
    final y = source._data[1] *
        ((source._data[3] * source._data[8]) -
            (source._data[5] * source._data[6]));
    final z = source._data[2] *
        ((source._data[3] * source._data[7]) -
            (source._data[4] * source._data[6]));

    return x - y + z;
  }

  /// Computes the determinant of a 4x4 matrix
  double _compute4x4Determinant(Matrix source) {
    final det2_01_01 =
        source._data[0] * source._data[5] - source._data[1] * source._data[4];
    final det2_01_02 =
        source._data[0] * source._data[6] - source._data[2] * source._data[4];
    final det2_01_03 =
        source._data[0] * source._data[7] - source._data[3] * source._data[4];
    final det2_01_12 =
        source._data[1] * source._data[6] - source._data[2] * source._data[5];
    final det2_01_13 =
        source._data[1] * source._data[7] - source._data[3] * source._data[5];
    final det2_01_23 =
        source._data[2] * source._data[7] - source._data[3] * source._data[6];

    final det3_201_012 = source._data[8] * det2_01_12 -
        source._data[9] * det2_01_02 +
        source._data[10] * det2_01_01;
    final det3_201_013 = source._data[8] * det2_01_13 -
        source._data[9] * det2_01_03 +
        source._data[11] * det2_01_01;
    final det3_201_023 = source._data[8] * det2_01_23 -
        source._data[10] * det2_01_03 +
        source._data[11] * det2_01_02;
    final det3_201_123 = source._data[9] * det2_01_23 -
        source._data[10] * det2_01_13 +
        source._data[11] * det2_01_12;

    return -det3_201_123 * source._data[12] +
        det3_201_023 * source._data[13] -
        det3_201_013 * source._data[14] +
        det3_201_012 * source._data[15];
  }

  /// Recursively computes the determinant of a matrix. In case of 1x1, 2x2,
  /// 3x3 and 4x4 matrices, the calculations are "manually" done.
  double _computeDeterminant(Matrix source) {
    // Computing the determinant only if the matrix is square
    if (source.rowCount != source.columnCount) {
      throw const MatrixException("Can't compute the determinant of this "
          "matrix because it's not square.");
    }

    // In case there were an 1x1 matrix, just return the value
    if (source.rowCount * source.columnCount == 1) {
      return source._data[0];
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
    final tempMatrix =
        Matrix(rows: source.rowCount - 1, columns: source.columnCount - 1);
    var det = 0.0;

    for (var x = 0; x < source.rowCount; ++x) {
      var subI = 0;
      for (var i = 1; i < source.rowCount; ++i) {
        var subJ = 0;
        for (var j = 0; j < source.rowCount; ++j) {
          if (j == x) {
            continue;
          }
          tempMatrix._data[(source.columnCount - 1) * subI + subJ] = this(i, j);
          subJ++;
        }
        subI++;
      }

      det = det + (pow(-1, x) * source(0, x) * _computeDeterminant(tempMatrix));
    }

    return det;
  }
}
