/// A simple Dart implementation of a matrix whose size is `m x n`. In particular,
/// `m` is the number of rows and `n` the number of columns.
///
/// Thanks to its generic nature, you can decide to work with `int`, `double` or
/// any other subtype of `num`.
///
/// ```dart
/// final matrix = Matrix<int>(
///   rowCount: 3,
///   columnCount: 4,
/// );
/// ```
///
/// You can access elements of the matrix very conveniently with the following
/// syntax:
///
/// ```dart
/// final matrix = Matrix<int>(
///   rowCount: 3,
///   columnCount: 4,
/// );
///
/// final value = matrix(1, 3);
/// final value = matrix.itemAt(1, 3);
/// ```
///
/// Both versions return the same value but the first one is of course less
/// verbose and you should prefer it. In the example, we're retrieving the value
/// of the element at position [1, 3] in the matrix.
class Matrix<T extends num> {
  /// The number of rows of the matrix.
  final int rowCount;

  /// The number of columns of the matrix.
  final int columnCount;

  /// TODO
  late final List<T> _data;

  /// TODO
  Matrix({
    required int rows,
    required int columns,
  })   : rowCount = rows,
        columnCount = columns {
    // Making sure the user entered valid dimensions for the matrix
    if ((rows == 0) || (columns == 0)) {
      throw const FormatException("Matrix constructor has 0 size");
    }

    // Creating a new FIXED length list
    _data = List<T>.filled(rows * columns, 0 as T);
  }

  /// TODO
  T call(int row, int col) {
    if ((row >= rowCount) || (col >= columnCount)) {
      throw const FormatException("Matrix subscript out of bounds");
    }

    return _data[columnCount * row + col];
  }

  /// TODO
  T itemAt(int row, int col) => this(row, col);
}
