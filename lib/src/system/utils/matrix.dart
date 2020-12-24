import 'package:collection/collection.dart';
import 'package:equations/equations.dart';

/// A simple Dart implementation of a matrix whose size is `m x n`. Thanks to
/// its generic nature, you can decide to work with [int], [double], [Complex]
/// or any other kind of numerical type.
///
/// By default, the cells of a matrix are initialized with all zeroes. You can
/// access elements of the matrix either by calling [itemAt] or by using the
/// [call] method (which makes the instance 'callable').
abstract class Matrix<T> {
  /// The number of rows of the matrix.
  final int rowCount;

  /// The number of columns of the matrix.
  final int columnCount;

  /// The internal representation of the matrix.
  late final List<T> _data;

  /// A flattened representation of the data of the matrix
  late final List<T> flattenData;

  /// Creates a new `N x M` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with zeroes.
  ///
  /// If [identity] is set to `true` (by default it's `false`) then the matrix
  /// is initialized with all zeroes **and** the diagonal is filled with ones.
  Matrix({
    required int rows,
    required int columns,
    required T defaultValue,
    required T identityOneValue,
    bool identity = false,
  })  : rowCount = rows,
        columnCount = columns {
    // Making sure the user entered valid dimensions for the matrix
    if ((rows == 0) || (columns == 0)) {
      throw const MatrixException("The rows or column count cannot be zero.");
    }

    // Creating a new FIXED length list
    _data = List<T>.filled(rows * columns, defaultValue);

    // Exposing data to the outside in read-only mode
    flattenData = UnmodifiableListView<T>(_data);

    // The identity matrix has 1 in the diagonal
    if (identity) {
      if (rows != columns) {
        throw const MatrixException("The identity matrix must be square.");
      }

      for (var i = 0; i < rowCount; ++i) {
        _data[columnCount * i + i] = identityOneValue;
      }
    }
  }

  /// Creates a new `N x M` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with values from [data].
  Matrix.fromData({
    required int rows,
    required int columns,
    required List<List<T>> data,
  })   : rowCount = rows,
        columnCount = columns {
    // "Flattening" the source into a single list
    _data = data.expand((e) => e).toList();

    // Exposing data to the outside in read-only mode
    flattenData = UnmodifiableListView<T>(_data);

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

  @override
  String toString() {
    final buffer = StringBuffer();

    // Printing the matrix in the following format:
    // [1, 2, 3]
    // [4, 5, 6]
    for (var i = 0; i < rowCount; ++i) {
      // Leading opening [
      buffer.write("[");

      for (var j = 0; j < columnCount; ++j) {
        buffer.write(this(i, j));

        // Adding a comma only between two values
        if (j < columnCount - 1) {
          buffer.write(", ");
        }
      }

      // Ending closing ]
      if (i < rowCount - 1) {
        buffer.writeln("]");
      } else {
        buffer.write("]");
      }
    }

    return buffer.toString();
  }

  /// Returns a modifiable view of the matrix as a `List<List<T>>` object.
  List<List<T>> toListOfList() {
    return List<List<T>>.generate(rowCount, (row) {
      return List<T>.generate(columnCount, (col) => this(row, col));
    }, growable: false);
  }

  /// Determines whether the matrix is square
  bool get isSquareMatrix => rowCount == columnCount;

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
  T call(int row, int col) {
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
  T itemAt(int row, int col) => this(row, col);

  /// Returns the sum of two matrices.
  Matrix<T> operator +(Matrix<T> other);

  /// Returns the difference of two matrices.
  Matrix<T> operator -(Matrix<T> other);

  /// Returns the sum of two matrices.
  Matrix<T> operator *(Matrix<T> other);

  /// Returns the division of two matrices.
  Matrix<T> operator /(Matrix<T> other);

  /// The determinant can only be computed if the matrix is **square**, meaning
  /// that it must have the same number of columns and rows.
  ///
  /// The determinant of a 1*1, 2*2, 3*3 or 4*4 matrix is efficiently computed.
  /// Note that for all the other dimensions, the algorithm is exponentially
  /// slower.
  T determinant();

  /// Factors the matrix as the product of a lower triangular matrix `L` and
  /// an upper triangular matrix `U`.
  List<Matrix<T>> luDecomposition();

  /// Uses the the Cholesky decomposition algorithm to factor the matrix into
  /// the product of a lower triangular matrix and its conjugate transpose.
  List<Matrix<T>> choleskyDecomposition();
}
