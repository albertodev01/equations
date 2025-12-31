import 'dart:collection';
import 'package:equations/equations.dart';

/// {@template matrix_class_header}
/// A matrix with [rowCount] rows and [columnCount] columns. This abstract type
/// allows the implementation of different types of matrices, each with their
/// own specific methods and types. This library implements:
///
///  - [RealMatrix], which works with [double];
///  - [ComplexMatrix], which works with [Complex].
///
/// By default, the cells of a matrix are initialized with zeros. You can
/// access elements of the matrix either by calling [itemAt] or by using the
/// [call] method (which makes the object 'callable').
///
/// This is a base abstract class.
/// {@endtemplate}
abstract base class Matrix<T> {
  /// The number of rows in the matrix.
  final int rowCount;

  /// The number of columns in the matrix.
  final int columnCount;

  /// The internal representation of the matrix.
  final List<T> _data;

  /// {@macro matrix_class_header}
  ///
  /// {@template matrix_constructor_intro}
  /// Creates a new `NxM` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with zeros.
  ///
  /// If [identity] is set to `true` (by default it's `false`), the matrix is
  /// initialized with zeros **and** the diagonal is filled with ones.
  ///
  /// A [MatrixException] is thrown if [rows] or [columns] is set to 0.
  /// {@endtemplate}
  Matrix({
    required int rows,
    required int columns,
    required T defaultValue,
    required T identityOneValue,
    bool identity = false,
  }) : rowCount = rows,
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

  /// {@template matrix_fromData_constructor}
  /// Creates a new `NxM` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with values from [data].
  ///
  /// A [MatrixException] is thrown if [rows] * [columns] is **not** equal
  /// to the length of [data].
  /// {@endtemplate}
  Matrix.fromData({
    required int rows,
    required int columns,
    required List<List<T>> data,
  }) : rowCount = rows,
       columnCount = columns,
       _data = data.expand((e) => e).toList(growable: false) {
    // Making sure the size is correct
    if (_data.length != (rows * columns)) {
      throw const MatrixException(
        "The given sizes don't match the size of the data to be inserted.",
      );
    }
  }

  /// {@template matrix_fromFlattenedData_constructor}
  /// Creates a new `NxM` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with values from [data].
  ///
  /// The source matrix is expressed as an array whose size must **exactly** be
  /// `N` * `M`, otherwise a [MatrixException] is thrown.
  /// {@endtemplate}
  Matrix.fromFlattenedData({
    required int rows,
    required int columns,
    required List<T> data,
  }) : rowCount = rows,
       columnCount = columns,
       _data = List<T>.from(data) {
    // Making sure the size is correct
    if (data.length != (rows * columns)) {
      throw const MatrixException(
        "The given sizes don't match the size of the "
        'data to be inserted.',
      );
    }
  }

  /// {@template matrix_diagonal_constructor}
  /// Creates a new `NxM` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with [diagonalValue] in the main diagonal and zeros
  /// elsewhere.
  ///
  /// A [MatrixException] is thrown if [rows] or [columns] is set to 0.
  /// {@endtemplate}
  Matrix.diagonal({
    required int rows,
    required int columns,
    required T defaultValue,
    required T diagonalValue,
  }) : rowCount = rows,
       columnCount = columns,
       _data = List<T>.filled(rows * columns, defaultValue) {
    // Making sure the user entered valid dimensions for the matrix.
    if ((rows == 0) || (columns == 0)) {
      throw const MatrixException('The rows or column count cannot be zero.');
    }

    // Putting the given value in the diagonal.
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
      if (rowCount != other.rowCount ||
          columnCount != other.columnCount ||
          _data.length != other._data.length) {
        return false;
      }

      for (var i = 0; i < _data.length; ++i) {
        if (_data[i] != other._data[i]) {
          return false;
        }
      }

      return runtimeType == other.runtimeType;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(rowCount, columnCount, Object.hashAll(_data));

  /// Validates that the given row and column indices are within bounds.
  ///
  /// Throws a [MatrixException] if either index is negative or out of bounds.
  void _validateIndices(int row, int col) {
    if (row < 0 || row >= rowCount) {
      throw MatrixException(
        'Row index $row is out of bounds. Matrix has $rowCount rows.',
      );
    }
    if (col < 0 || col >= columnCount) {
      throw MatrixException(
        'Column index $col is out of bounds. Matrix has $columnCount columns.',
      );
    }
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
  ///
  /// Each inner list represents a row of the matrix. The returned list is
  /// modifiable, but changes to it will not affect the original matrix.
  List<List<T>> toListOfList() => List<List<T>>.generate(
    rowCount,
    (row) => List<T>.generate(columnCount, (col) => this(row, col)),
    growable: false,
  );

  /// An unmodifiable, flattened representation of the matrix data.
  ///
  /// The data is stored in row-major order (elements are arranged row by row).
  /// For example, a 2×3 matrix `[[a, b, c], [d, e, f]]` would be flattened
  /// as `[a, b, c, d, e, f]`.
  List<T> get flattenData => UnmodifiableListView<T>(_data);

  /// Returns a modifiable "flattened" view of the matrix as a `List<T>` object.
  ///
  /// The data is stored in row-major order (elements are arranged row by row).
  /// The returned list is a copy of the internal data, so modifications to
  /// it will not affect the original matrix.
  List<T> toList() => List<T>.from(_data);

  /// Determines whether the matrix is square or not.
  ///
  /// A square matrix has the same number of rows and columns. Many matrix
  /// operations (such as determinant, inverse, eigenvalues) require the
  /// matrix to be square.
  bool get isSquareMatrix => rowCount == columnCount;

  /// Use this method to retrieve the element at a given position in the matrix.
  /// For example:
  ///
  /// ```dart
  /// final value = myMatrix(2, 1);
  /// ```
  ///
  /// In the above example, you're accessing the value at position `(2, 1)`.
  /// This method is an alias of [itemAt].
  ///
  /// A [MatrixException] is thrown if [row] and/or [col] is not within the
  /// size range of the matrix.
  T call(int row, int col) {
    _validateIndices(row, col);
    return _data[columnCount * row + col];
  }

  /// A symmetric matrix is a square matrix that is equal to its transpose.
  /// Because equal matrices have equal dimensions, only square matrices can be
  /// symmetric.
  bool isSymmetric() {
    if (!isSquareMatrix) {
      return false;
    }

    final n = rowCount;
    for (var i = 0; i < n; i++) {
      for (var j = i + 1; j < n; j++) {
        if (this(i, j) != this(j, i)) {
          return false;
        }
      }
    }
    return true;
  }

  /// Checks if the matrix contains only zero elements.
  ///
  /// Returns `true` if all elements in the matrix are zero, `false` otherwise.
  /// This is useful for checking if a matrix is the zero matrix.
  bool isZero();

  /// Returns the value at ([row], [col]) position as if this matrix were
  /// transposed. For example, let's say we have this matrix:
  ///
  /// ```txt
  /// A = | 1 2 |
  ///     | 3 4 |
  /// ```
  ///
  /// Calling `itemAt(0, 1)` returns `2` because that's the value stored at row
  /// 0 and column 1. Calling `transposedValue(0, 1)` returns `3` because in the
  /// transposed matrix of A...
  ///
  /// ```txt
  /// At = | 1 3 |
  ///      | 2 4 |
  /// ```
  ///
  /// ... the number `3` is at row 0 and column 1. In other words, this method
  /// returns the value of the transposed matrix of this matrix.
  T transposedValue(int row, int col) => this(col, row);

  /// Use this method to retrieve the element at a given position in the matrix.
  /// For example:
  ///
  /// ```dart
  /// final value = myMatrix.itemAt(2, 1);
  /// ```
  ///
  /// In the above example, you're accessing the value at position `(2, 1)`.
  T itemAt(int row, int col) {
    _validateIndices(row, col);
    return _data[columnCount * row + col];
  }

  /// Returns the sum of two matrices.
  ///
  /// Matrix addition is performed element-wise. Each element in the result
  /// is the sum of the corresponding elements in the two matrices.
  Matrix<T> operator +(Matrix<T> other);

  /// Returns the difference of two matrices.
  ///
  /// Matrix subtraction is performed element-wise. Each element in the result
  /// is the difference of the corresponding elements in the two matrices.
  Matrix<T> operator -(Matrix<T> other);

  /// Returns the product of two matrices.
  ///
  /// Matrix multiplication is performed using the standard matrix
  /// multiplication algorithm. The element at position (i, j) in the result
  /// is the dot product of row i of this matrix and column j of [other].
  Matrix<T> operator *(Matrix<T> other);

  /// Returns the division of two matrices.
  ///
  /// Matrix division is equivalent to multiplying this matrix by the inverse
  /// of [other]. That is, `A / B` is equivalent to `A * B.inverse()`.
  Matrix<T> operator /(Matrix<T> other);

  /// Returns the transpose of this matrix.
  ///
  /// This is an operation that flips a matrix over its diagonal (switching the
  /// row and column indices of the matrix to create a new one). The transpose
  /// of an `N×M` matrix is an `M×N` matrix where the element at position (i, j)
  /// in the original matrix becomes the element at position (j, i) in the
  /// transposed matrix.
  Matrix<T> transpose();

  /// A minor of a matrix `A` is the determinant of some smaller square matrix,
  /// cut down from `A` by removing one or more of its rows and columns.
  ///
  /// This function only computes the **first minor**, which is the minor
  /// obtained by removing 1 row and 1 column from the source matrix. This
  /// is often useful for calculating cofactors.
  Matrix<T> minor(int row, int col);

  /// The matrix formed by all of the cofactors of a square matrix is called the
  /// "cofactor matrix".
  ///
  /// In practice, this matrix is obtained by calling `minor(i, j)` for all
  /// combinations of rows and columns of the matrix, then multiplying each
  /// minor's determinant by (-1)<sup>i+j</sup> to get the cofactor.
  Matrix<T> cofactorMatrix();

  /// Returns the inverse of this matrix.
  ///
  /// The inverse of a square matrix `A`, sometimes called a reciprocal matrix,
  /// is a matrix A<sup>-1</sup> such that "A A<sup>-1</sup> = I" where `I` is
  /// the identity matrix.
  ///
  /// A square matrix has an inverse if and only if its determinant is *not* 0.
  /// A matrix that has an inverse is called **invertible** or **non-singular**.
  ///
  /// A matrix without an inverse is called **singular**.
  Matrix<T> inverse();

  /// The trace of a square matrix `A`, denoted `tr(A)`, is defined as the
  /// sum of elements on the main diagonal (from the upper left to the lower
  /// right).
  ///
  /// The trace has several important properties:
  ///  - tr(A + B) = tr(A) + tr(B)
  ///  - tr(cA) = c × tr(A) for any scalar c
  ///  - tr(AB) = tr(BA)
  ///  - The trace equals the sum of the eigenvalues
  T trace();

  /// A diagonal matrix is a matrix in which all entries outside the main
  /// diagonal are zero.
  ///
  /// Returns `true` if the matrix is diagonal (all non-diagonal elements are
  /// zero), `false` otherwise. Note that a diagonal matrix must be square.
  bool isDiagonal();

  /// The identity matrix is a square matrix with ones on the main diagonal
  /// and zeros elsewhere. It is denoted by I<sub>n</sub>, or simply by I.
  ///
  /// The identity matrix has the property that for any matrix A of compatible
  /// size, A x I = I x A = A.
  bool isIdentity();

  /// The **rank** of a matrix `A` is the dimension of the vector space
  /// generated by its columns. This corresponds to the maximal number of
  /// linearly independent columns of `A`.
  ///
  /// The rank is generally denoted by rank(A) or rk(A). The rank of a matrix
  /// is equal to the rank of its transpose, and it cannot exceed the minimum
  /// of the number of rows and columns.
  int rank();

  /// The determinant can only be computed if the matrix is **square**, meaning
  /// that it must have the same number of columns and rows.
  ///
  /// The determinant of a 1×1, 2×2, 3×3, or 4×4 matrix is efficiently computed.
  /// Note that for all other dimensions, the algorithm is exponentially
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
  /// 5×5 or larger matrices, consider using the [eigenvalues] method which is
  /// faster and more accurate.
  ///
  /// {@template matrix_not_square_error}
  /// A [MatrixException] is thrown if the matrix is not square (i.e., if
  /// [rowCount] != [columnCount]).
  /// {@endtemplate}
  Algebraic characteristicPolynomial();

  /// Returns the eigenvalues associated with this matrix.
  ///
  /// Eigenvalues can only be computed if the matrix is **square**, meaning
  /// that it must have the same number of columns and rows.
  ///
  /// {@macro matrix_not_square_error}
  List<Complex> eigenvalues();

  /// Factors the matrix as the product of a lower triangular matrix `L` and
  /// an upper triangular matrix `U`. The matrix **must** be square.
  ///
  /// The returned list contains `L` at index 0 and `U` at index 1.
  ///
  /// {@macro matrix_not_square_error}
  List<Matrix<T>> luDecomposition();

  /// Uses the Cholesky decomposition algorithm to factor the matrix into
  /// the product of a lower triangular matrix and its conjugate transpose. In
  /// particular, this method returns the `L` and `L`<sup>T</sup> matrices of the
  ///
  ///  - A = L × L<sup>T</sup>
  ///
  /// relation. The algorithm might fail if the square root of a negative
  /// number is encountered.
  ///
  /// The returned list contains `L` at index 0 and `L`<sup>T</sup> at index 1.
  ///
  /// {@macro matrix_not_square_error}
  List<Matrix<T>> choleskyDecomposition();

  /// Computes the `Q` and `R` matrices of the QR decomposition algorithm. In
  /// particular, this method returns the `Q` and `R` matrices of the
  ///
  ///  - A = Q × R
  ///
  /// relation. The returned list contains `Q` at index 0 and `R` at index 1.
  List<Matrix<T>> qrDecomposition();

  /// Computes the `E`, `U`, and `V` matrices of the SVD (Singular Value
  /// Decomposition) algorithm. In particular, this method returns the following
  /// matrices:
  ///
  ///  - `E`: rectangular diagonal matrix with positive values on the diagonal;
  ///  - `U`: a square matrix of size [rowCount]×[rowCount];
  ///  - `V`: a square matrix of size [columnCount]×[columnCount].
  ///
  /// The returned list contains `E` at index 0, `U` at index 1, and `V` at
  /// index 2.
  List<Matrix<T>> singleValueDecomposition();

  /// Computes the `V`, `D`, and `V'` matrices of the eigendecomposition
  /// algorithm. In particular, this method returns the following matrices:
  ///
  ///  - `V`: a square matrix whose i<sup>th</sup> column is the eigenvector of
  ///         the source matrix;
  ///  - `D`: a diagonal matrix whose diagonal elements are the corresponding
  ///         eigenvalues of A;
  ///  - `V'`: the inverse of V.
  ///
  /// The returned list contains `V` at index 0, `D` at index 1, and `V'` at
  /// index 2.
  ///
  /// {@macro matrix_not_square_error}
  List<Matrix<T>> eigenDecomposition();
}
