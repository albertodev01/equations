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
  final List<T> _data;

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
        columnCount = columns,
        _data = List<T>.filled(rows * columns, defaultValue) {
    // Making sure the user entered valid dimensions for the matrix
    if ((rows == 0) || (columns == 0)) {
      throw const MatrixException('The rows or column count cannot be zero.');
    }

    // The identity matrix has 1 in the diagonal
    if (identity) {
      if (rows != columns) {
        throw const MatrixException('The identity matrix must be square.');
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
  })  : rowCount = rows,
        columnCount = columns,
        _data = data.expand((e) => e).toList() {
    // Making sure the size is correct
    if (_data.length != (rows * columns)) {
      throw const MatrixException(
        "The given sizes don't match the size of the data to be inserted.",
      );
    }
  }

  /// Creates a new `N x M` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with values from [data].
  ///
  /// The source matrix is expressed as an array whose size must **exactly** be
  /// `N` * `M`.
  Matrix.fromFlattenedData({
    required int rows,
    required int columns,
    required List<T> data,
  })  : rowCount = rows,
        columnCount = columns,
        _data = List<T>.from(data) {
    // Making sure the size is correct
    if (data.length != (rows * columns)) {
      throw const MatrixException("The given sizes don't match the size of the "
          'data to be inserted.');
    }
  }

  /// Creates a new `N x M` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with [diagonalValue] in the main diagonal and zeroes
  /// otherwise.
  Matrix.diagonal({
    required int rows,
    required int columns,
    required T defaultValue,
    required T diagonalValue,
  })  : rowCount = rows,
        columnCount = columns,
        _data = List<T>.filled(rows * columns, defaultValue) {
    // Making sure the user entered valid dimensions for the matrix
    if ((rows == 0) || (columns == 0)) {
      throw const MatrixException('The rows or column count cannot be zero.');
    }

    // Putting the given value in the diagonal
    for (var i = 0; i < rowCount; ++i) {
      final pos = columnCount * i + i;

      if (pos < _data.length && i < columnCount) {
        _data[pos] = diagonalValue;
      }
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

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
      result = result * 37 + _data[i].hashCode;
    }

    result = result * 37 + rowCount.hashCode;
    result = result * 37 + columnCount.hashCode;

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
      buffer.write('[');

      for (var j = 0; j < columnCount; ++j) {
        buffer.write(this(i, j));

        // Adding a comma only between two values
        if (j < columnCount - 1) {
          buffer.write(', ');
        }
      }

      // Ending closing ]
      if (i < rowCount - 1) {
        buffer.writeln(']');
      } else {
        buffer.write(']');
      }
    }

    return buffer.toString();
  }

  /// Returns a modifiable view of the matrix as a `List<List<T>>` object.
  List<List<T>> toListOfList() {
    return List<List<T>>.generate(
      rowCount,
      (row) {
        return List<T>.generate(columnCount, (col) => this(row, col));
      },
      growable: false,
    );
  }

  /// A flattened representation of the matrix data.
  List<T> get flattenData => UnmodifiableListView<T>(_data);

  /// Returns a modifiable "flattened" view of the matrix as a `List<T>` object.
  List<T> toList() => List<T>.from(_data);

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
      throw const MatrixException('The given indices are out of the bounds.');
    }

    // Data are stored sequentially so there's the need to work with the indices
    return _data[columnCount * row + col];
  }

  /// A symmetric matrix is a square matrix that is equal to its transpose.
  /// Because equal matrices have equal dimensions, only square matrices can be
  /// symmetric.
  bool isSymmetric() {
    if (isSquareMatrix) {
      return this == transpose();
    }

    return false;
  }

  /// Returns the value at ([row], [col]) position as if this matrix were
  /// transposed. For example, let's say we have this matrix object:
  ///
  /// A = | 1 2 |
  ///     | 3 4 |
  ///
  /// calling `itemAt(0, 1)` returns `2` because that's the value stored at row
  /// 0 and column 1. Calling `transposedValue(0, 1)` returns `3` because in the
  /// transposed matrix of A...
  ///
  /// At = | 1 3 |
  ///      | 2 4 |
  ///
  /// ... the number `3` is at row 0 an column 1. In other words, this method
  /// returns the value of the transposed matrix of this matrix.
  T transposedValue(int row, int col) => this(col, row);

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

  /// Returns the transpose of this matrix.
  ///
  /// This is an operation that simply flips a matrix over its diagonal (so it
  /// switches the row and column indices of the matrix to create a new one).
  Matrix<T> transpose();

  /// A minor of a matrix `A` is the determinant of some smaller square matrix,
  /// cut down from `A` by removing one or more of its rows and columns.
  ///
  /// This function only computes the **first minor**, which is the minor obtained
  /// by only removing 1 row and 1 column from the source matrix. This is often
  /// useful to calculate cofactors.
  Matrix<T> minor(int row, int col);

  /// The matrix formed by all of the cofactors of a square matrix is called the
  /// "cofactor matrix" (also called "the matrix of cofactors").
  ///
  /// In practice, this matrix is obtained by calling [minor(i, j)] for all the
  /// rows and columns combinations of the matrix.
  Matrix<T> cofactorMatrix();

  /// Returns the inverse of this matrix.
  ///
  /// The inverse of a square matrix `A`, sometimes called a reciprocal matrix,
  /// is a matrix A<sup>-1</sup> such that "A A<sup>-1</sup> = I" where `I` is
  /// the identity matrix.
  ///
  /// A square matrix has an inverse if and only if the determinant **isn't** 0.
  Matrix<T> inverse();

  /// The trace of a square matrix `A`, denoted `tr(A)`, is defined to be the
  /// sum of elements on the main diagonal (from the upper left to the lower
  /// right).
  T trace();

  /// A diagonal matrix is a matrix in which the entries outside the main
  /// diagonal are all zero.
  bool isDiagonal();

  /// The identity matrix is a square matrix with ones on the main diagonal
  /// and zeros elsewhere. It is denoted by In, or simply by I i
  ///
  /// This method throws if the matrix is **not** square.
  bool isIdentity();

  /// The **rank** of a matrix `A` is the dimension of the vector space generated
  /// by its columns. This corresponds to the maximal number of linearly
  /// independent columns of `A`.
  ///
  /// The rank is generally denoted by rank(A) or rk(A).
  int rank();

  /// The determinant can only be computed if the matrix is **square**, meaning
  /// that it must have the same number of columns and rows.
  ///
  /// The determinant of a 1*1, 2*2, 3*3 or 4*4 matrix is efficiently computed.
  /// Note that for all the other dimensions, the algorithm is exponentially
  /// slower.
  T determinant();

  /// The characteristic polynomial can only be computed if the matrix is
  /// **square**, meaning that it must have the same number of columns and rows.
  ///
  /// The roots of the characteristic polynomial are the eigenvalues of the
  /// matrix.
  ///
  /// If you want to find the eigenvalues of a matrix, you can compute the
  /// characteristic polynomial and solve the polynomial equation. However, for
  /// 5x5 or bigger matrices, consider using the [eigenValues()] method which is
  /// faster and more accurate.
  Algebraic characteristicPolynomial();

  /// Returns the eigenvalues associated to this matrix.
  ///
  /// Eigenvalues can only be computed if the matrix is **square**, meaning
  /// that it must have the same number of columns and rows.
  List<Complex> eigenvalues();

  /// Factors the matrix as the product of a lower triangular matrix `L` and
  /// an upper triangular matrix `U`. The matrix **must** be square.
  ///
  /// The returned list contains `L` at index 0 and `U` at index 1.
  List<Matrix<T>> luDecomposition();

  /// Uses the the Cholesky decomposition algorithm to factor the matrix into
  /// the product of a lower triangular matrix and its conjugate transpose. In
  /// particular, this method returns the `L` and `L`<sup>T</sup> matrices of the
  ///
  ///  - A = L x L<sup>T</sup>
  ///
  /// relation. The algorithm might fail in case the square root of a negative
  /// number were encountered.
  ///
  /// The returned list contains `L` at index 0 and `L`<sup>T</sup> at index 1.
  List<Matrix<T>> choleskyDecomposition();

  /// Computes the `Q` and `R` matrices of the QR decomposition algorithm. In
  /// particular, this method returns the `Q` and `R` matrices of the
  ///
  ///  - A = Q x R
  ///
  /// relation. The returned list contains `Q` at index 0 and `R` at index 1.
  List<Matrix<T>> qrDecomposition();

  /// Computes the `E`, `U` and `V` matrices of the SVD (Single Value
  /// Decomposition) algorithm. In particular, this method returns the following
  /// matrices:
  ///
  ///  - `E`: rectangular diagonal matrix with positive values on the diagonal;
  ///  - `U`: a square matrix of size [rowCount]x[rowCount];
  ///  - `V`: a square matrix of size [columnCount]x[columnCount].
  ///
  /// The returned list contains `E` at index 0, `U` at index 1 and `V` at index
  /// 2.
  List<Matrix<T>> singleValueDecomposition();

  /// Computes the `V`, `D` and `V'` matrices of the eigendecomposition
  /// algorithm. In particular, this method returns the following matrices:
  ///
  ///  - `V`: square matrix whose i<sup>th</sup> column is the eigenvector of
  ///         the source matrix;
  ///  - `U`: the diagonal matrix whose diagonal elements are the corresponding
  ///         eigenvalues of A;
  ///  - `V`: the inverse of V.
  ///
  /// The returned list contains `V` at index 0, `D` at index 1 and `V'` at index
  /// 2.
  List<Matrix<T>> eigenDecomposition();
}
