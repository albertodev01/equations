import 'package:equations/equations.dart';

/// A simple Dart implementation of a matrix whose size is `m x n`. Thanks to
/// its generic nature, you can decide to work with `int`, `double` or any other
/// subtype of `num`.
///
/// ```dart
/// final matrix = Matrix<int>(
///   rowCount: 3,
///   columnCount: 4,
/// );
/// ```
///
/// By default, the cells of a matrix are initialized with all zeroes. You can
/// access elements of the matrix very conveniently with the following syntax:
///
/// ```dart
/// final matrix = Matrix<double>(
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
class Matrix<T extends num> {
  /// The number of rows of the matrix.
  final int rowCount;

  /// The number of columns of the matrix.
  final int columnCount;

  /// The internal representation of the matrix.
  late final List<T> _data;

  /// Creates a new `N x M` matrix where [rows] is `N` and [columns] is `M`.
  Matrix({
    required int rows,
    required int columns,
  })   : rowCount = rows,
        columnCount = columns {
    // Making sure the user entered valid dimensions for the matrix
    if ((rows == 0) || (columns == 0)) {
      throw const MatrixException("The rows or column count cannot be zero.");
    }

    // Creating a new FIXED length list
    _data = List<T>.filled(rows * columns, 0 as T);
  }

  /// Use this method to retrieve the element at a given position in the matrix.
  /// For example:
  ///
  /// ```dart
  /// final matrix = Matrix<double>(
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
  /// final matrix = Matrix<double>(
  ///   rowCount: 3,
  ///   columnCount: 3,
  /// );
  ///
  /// final value = matrix.itemAt(2, 1);
  /// ```
  ///
  /// In the above example, you're accessing the [double] at position `(3, 2)`.
  T itemAt(int row, int col) => this(row, col);

  /// TODO
  Matrix<T> operator+(Matrix<T> other) {
    final matrix = Matrix<T>(
      rows: rowCount,
      columns: columnCount
    );

    // Performing sum
    for(var i = 0; i < _data.length; ++i) {
      matrix._data[i] = _data[i] + other._data[i] as T;
    }

    return matrix;
  }

  /// TODO
  Matrix<T> operator-(Matrix<T> other) {
    final matrix = Matrix<T>(
        rows: rowCount,
        columns: columnCount
    );

    // Performing sum
    for(var i = 0; i < _data.length; ++i) {
      matrix._data[i] = _data[i] - other._data[i] as T;
    }

    return matrix;
  }
}
