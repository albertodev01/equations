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
  /// {@macro matrix_class_header}
  ///
  /// {@template matrix_constructor_intro}
  /// Creates a new `NxM` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with zeros.
  ///
  /// If [identity] is set to `true` (by default it's `false`), the matrix is
  /// initialized with zeros **and** the diagonal is filled with ones.
  ///
  /// A [MatrixException] is thrown if:
  ///
  ///  - [rows] or [columns] is zero or negative;
  ///  - [identity] is `true` but [rows] is not equal to [columns].
  /// {@endtemplate}
  new({
    required int rows,
    required int columns,
    required T defaultValue,
    required T identityOneValue,
    bool identity = false,
  }) : rowCount = rows,
       columnCount = columns,
       _data = List<T>.filled(_validatedSize(rows, columns), defaultValue) {
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
  /// matrix is filled with values from [data], where each inner list is a row.
  ///
  /// A [MatrixException] is thrown if:
  ///
  ///  - [rows] or [columns] is zero or negative;
  ///  - [data] does not contain exactly [rows] rows;
  ///  - any row of [data] does not contain exactly [columns] values.
  /// {@endtemplate}
  new fromData({
    required int rows,
    required int columns,
    required List<List<T>> data,
  }) : rowCount = rows,
       columnCount = columns,
       _data = _flattenRows(rows, columns, data);

  /// {@template matrix_fromFlattenedData_constructor}
  /// Creates a new `NxM` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with values from [data], in row-major order.
  ///
  /// A [MatrixException] is thrown if:
  ///
  ///  - [rows] or [columns] is zero or negative;
  ///  - the length of [data] is not **exactly** `N * M`.
  /// {@endtemplate}
  new fromFlattenedData({
    required int rows,
    required int columns,
    required List<T> data,
  }) : rowCount = rows,
       columnCount = columns,
       _data = List<T>.of(data, growable: false) {
    if (data.length != _validatedSize(rows, columns)) {
      throw const MatrixException(
        "The given sizes don't match the size of the "
        'data to be inserted.',
      );
    }
  }

  /// {@template matrix_diagonal_constructor}
  /// Creates a new `NxM` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with [diagonalValue] in the main diagonal and zeros
  /// elsewhere. The matrix doesn't need to be square: in that case, the main
  /// diagonal has `min(N, M)` elements.
  ///
  /// A [MatrixException] is thrown if [rows] or [columns] is zero or negative.
  /// {@endtemplate}
  new diagonal({
    required int rows,
    required int columns,
    required T defaultValue,
    required T diagonalValue,
  }) : rowCount = rows,
       columnCount = columns,
       _data = List<T>.filled(_validatedSize(rows, columns), defaultValue) {
    final diagonalLength = rows < columns ? rows : columns;
    for (var i = 0; i < diagonalLength; ++i) {
      _data[columnCount * i + i] = diagonalValue;
    }
  }

  /// Returns `rows * columns` after making sure that both [rows] and
  /// [columns] are strictly positive.
  ///
  /// This is called in the initializer lists of the constructors so that
  /// invalid dimensions are rejected before any memory is allocated.
  ///
  /// Throws a [MatrixException] if [rows] or [columns] is zero or negative.
  static int _validatedSize(int rows, int columns) {
    if (rows <= 0 || columns <= 0) {
      throw const MatrixException(
        'The rows and column count must be greater than zero.',
      );
    }
    return rows * columns;
  }

  /// Flattens [data] in row-major order after making sure that it contains
  /// exactly [rows] rows, each with exactly [columns] values.
  ///
  /// Throws a [MatrixException] if the dimensions are not valid or if [data]
  /// does not match them.
  static List<E> _flattenRows<E>(int rows, int columns, List<List<E>> data) {
    _validatedSize(rows, columns);
    if (data.length != rows || data.any((row) => row.length != columns)) {
      throw const MatrixException(
        "The given sizes don't match the size of the data to be inserted.",
      );
    }
    return data.expand((row) => row).toList(growable: false);
  }

  /// The number of rows in the matrix.
  final int rowCount;

  /// The number of columns in the matrix.
  final int columnCount;

  /// The internal representation of the matrix.
  final List<T> _data;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! Matrix ||
        runtimeType != other.runtimeType ||
        rowCount != other.rowCount ||
        columnCount != other.columnCount) {
      return false;
    }

    for (var i = 0; i < _data.length; ++i) {
      if (_data[i] != other._data[i]) {
        return false;
      }
    }

    return true;
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
      buffer.write('[');
      for (var j = 0; j < columnCount; ++j) {
        buffer.write(this(i, j));
        if (j < columnCount - 1) {
          buffer.write(', ');
        }
      }
      if (i < rowCount - 1) {
        buffer.writeln(']');
      } else {
        buffer.write(']');
      }
    }

    return buffer.toString();
  }

  /// Returns a copy of the matrix as a `List<List<T>>` object.
  ///
  /// Each inner list represents a row of the matrix. The outer list has a
  /// fixed length while the rows can be freely modified. Since this is a copy,
  /// changes to it will not affect the original matrix.
  List<List<T>> toListOfList() => List<List<T>>.generate(
    rowCount,
    (row) => List<T>.generate(columnCount, (col) => this(row, col)),
    growable: false,
  );

  /// An unmodifiable, flattened representation of the matrix data.
  ///
  /// The data is stored in row-major order (elements are arranged row by row).
  /// For example, a 2x3 matrix `[[a, b, c], [d, e, f]]` would be flattened
  /// as `[a, b, c, d, e, f]`.
  List<T> get flattenData => UnmodifiableListView<T>(_data);

  /// Returns a modifiable, flattened copy of the matrix as a `List<T>` object.
  ///
  /// The data is stored in row-major order (elements are arranged row by row).
  /// The returned list is a copy of the internal data, so modifications to
  /// it will not affect the original matrix.
  List<T> toList() => List<T>.of(_data);

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
  T call(int row, int col) => itemAt(row, col);

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
  ///
  /// A [MatrixException] is thrown if [row] and/or [col] is not within the
  /// size range of the matrix.
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

  /// Returns the element-wise (Hadamard) division of two matrices.
  ///
  /// Each element in the result is the element of this matrix divided by the
  /// corresponding element of [other]. This is **not** the same as
  /// `A * B.inverse()`: use [inverse] and `*` explicitly for that.
  ///
  /// A division by a zero element follows the semantics of the `/` operator
  /// of [T] (for example, it produces infinity or `NaN` with [double]).
  ///
  /// A [MatrixException] is thrown if the two matrices don't have the same
  /// number of rows and columns.
  Matrix<T> operator /(Matrix<T> other);

  /// Returns the transpose of this matrix.
  ///
  /// This is an operation that flips a matrix over its diagonal (switching the
  /// row and column indices of the matrix to create a new one). The transpose
  /// of an `NxM` matrix is an `MxN` matrix where the element at position (i, j)
  /// in the original matrix becomes the element at position (j, i) in the
  /// transposed matrix.
  Matrix<T> transpose();

  /// Returns the submatrix obtained by removing [row] and [col] from this
  /// matrix.
  ///
  /// A minor of a matrix `A` is the determinant of some smaller square matrix,
  /// cut down from `A` by removing one or more of its rows and columns. This
  /// method does **not** compute that determinant: it returns the submatrix
  /// itself, whose [determinant] is the `(row, col)` **first minor** of `A`.
  /// This is often useful for calculating cofactors.
  ///
  /// A [MatrixException] is thrown if [row] or [col] is out of bounds, or if
  /// the matrix has a single row or a single column.
  Matrix<T> minor(int row, int col);

  /// The matrix formed by all of the cofactors of a square matrix is called the
  /// "cofactor matrix".
  ///
  /// In practice, this matrix is obtained by calling `minor(i, j)` for all
  /// combinations of rows and columns of the matrix, then multiplying each
  /// minor's determinant by (-1)<sup>i+j</sup> to get the cofactor.
  ///
  /// {@macro matrix_not_square_error}
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
  ///
  /// The inverse of a 3x3 or larger matrix is computed via LU decomposition
  /// with partial pivoting, which is `O(n^3)`.
  ///
  /// A [MatrixException] is thrown if the matrix is singular. A matrix is
  /// considered singular when a pivot of its LU decomposition (or the
  /// determinant, for 2x2 matrices) is negligible compared to the magnitude
  /// of its elements.
  ///
  /// {@macro matrix_not_square_error}
  Matrix<T> inverse();

  /// The trace of a square matrix `A`, denoted `tr(A)`, is defined as the
  /// sum of elements on the main diagonal (from the upper left to the lower
  /// right).
  ///
  /// The trace has several important properties:
  ///  - tr(A + B) = tr(A) + tr(B)
  ///  - tr(cA) = c * tr(A) for any scalar c
  ///  - tr(AB) = tr(BA)
  ///  - The trace equals the sum of the eigenvalues
  ///
  /// {@macro matrix_not_square_error}
  T trace();

  /// A diagonal matrix is a matrix in which all entries outside the main
  /// diagonal are zero.
  ///
  /// Returns `true` if all the elements at position `(i, j)` with `i != j`
  /// are zero, `false` otherwise. Rectangular (non-square) matrices are
  /// accepted as well: their main diagonal has `min(rowCount, columnCount)`
  /// elements.
  bool isDiagonal();

  /// The identity matrix is a square matrix with ones on the main diagonal
  /// and zeros elsewhere. It is denoted by I<sub>n</sub>, or simply by I.
  ///
  /// The identity matrix has the property that for any matrix A of compatible
  /// size, A x I = I x A = A.
  ///
  /// Returns `true` if this matrix is the identity matrix, `false` otherwise.
  /// Non-square matrices always return `false`.
  bool isIdentity();

  /// The **rank** of a matrix `A` is the dimension of the vector space
  /// generated by its columns. This corresponds to the maximal number of
  /// linearly independent columns of `A`.
  ///
  /// The rank is generally denoted by rank(A) or rk(A). The rank of a matrix
  /// is equal to the rank of its transpose, and it cannot exceed the minimum
  /// of the number of rows and columns.
  ///
  /// The rank is computed with Gaussian elimination and partial pivoting.
  /// Pivots that are negligible compared to the magnitude of the matrix
  /// elements are treated as zeros, so that rounding errors don't increase
  /// the rank.
  int rank();

  /// The determinant can only be computed if the matrix is **square**, meaning
  /// that it must have the same number of columns and rows.
  ///
  /// The determinant of a 1x1, 2x2, 3x3, or 4x4 matrix is computed with a
  /// closed-form formula. For all other dimensions, the determinant is
  /// computed via LU decomposition with partial pivoting, which is `O(n^3)`.
  ///
  /// {@macro matrix_not_square_error}
  T determinant();

  /// The characteristic polynomial can only be computed if the matrix is
  /// **square**, meaning that it must have the same number of columns and rows.
  ///
  /// The roots of the characteristic polynomial are the eigenvalues of the
  /// matrix.
  ///
  /// If you want to find the eigenvalues of a matrix, you can compute the
  /// characteristic polynomial and solve the polynomial equation. However, for
  /// 3x3 or larger matrices, consider using the [eigenvalues] method which is
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

  /// Factors the matrix using the LU decomposition with partial pivoting. In
  /// particular, this method returns the `L`, `U` and `P` matrices of the
  ///
  ///  - P x A = L x U
  ///
  /// relation, where `L` is a lower triangular matrix with ones on the
  /// diagonal, `U` is an upper triangular matrix and `P` is the permutation
  /// matrix of the row swaps. The matrix **must** be square.
  ///
  /// The returned list contains `L` at index 0, `U` at index 1, and `P` at
  /// index 2.
  ///
  /// The decomposition always exists, singular matrices included: in that
  /// case, at least one element on the diagonal of `U` is zero (or
  /// negligible).
  ///
  /// {@macro matrix_not_square_error}
  List<Matrix<T>> luDecomposition();

  /// Uses the Cholesky decomposition algorithm to factor the matrix into
  /// the product of a lower triangular matrix and its conjugate transpose. In
  /// particular, this method returns the `L` and `L`<sup>H</sup> matrices of
  /// the
  ///
  ///  - A = L x L<sup>H</sup>
  ///
  /// relation. For real matrices, the conjugate transpose `L`<sup>H</sup> is
  /// simply the transpose `L`<sup>T</sup>.
  ///
  /// The matrix must be Hermitian (symmetric, if real) and positive-definite.
  /// This is **not** checked: only the lower triangular part of the matrix is
  /// read.
  ///
  /// The returned list contains `L` at index 0 and `L`<sup>H</sup> at index 1.
  ///
  /// A [SystemSolverException] is thrown if the matrix is not
  /// positive-definite.
  ///
  /// {@macro matrix_not_square_error}
  List<Matrix<T>> choleskyDecomposition();

  /// Computes the `Q` and `R` matrices of the QR decomposition algorithm. In
  /// particular, this method returns the `Q` and `R` matrices of the
  ///
  ///  - A = Q x R
  ///
  /// relation, where `Q` has orthonormal columns and `R` is upper triangular.
  /// With `k = min(rowCount, columnCount)`, `Q` is a [rowCount]x`k` matrix and
  /// `R` is a `k`x[columnCount] matrix (the reduced QR decomposition).
  ///
  /// The returned list contains `Q` at index 0 and `R` at index 1.
  List<Matrix<T>> qrDecomposition();

  /// Computes the `E`, `U`, and `V` matrices of the SVD (Singular Value
  /// Decomposition) algorithm, such that `A = U x E x V^H` (where `V^H` is the
  /// conjugate transpose of `V`, which is the transpose for real matrices). In
  /// particular, this method returns the following matrices:
  ///
  ///  - `E`: rectangular diagonal matrix with non-negative values (the
  ///         singular values, from the largest to the smallest) on the
  ///         diagonal;
  ///  - `U`: a unitary matrix of size [rowCount]x[rowCount];
  ///  - `V`: a unitary matrix of size [columnCount]x[columnCount].
  ///
  /// The returned list contains `E` at index 0, `U` at index 1, and `V` at
  /// index 2.
  ///
  /// A [MatrixException] is thrown if the matrix contains NaN or infinite
  /// values.
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
  /// For a [RealMatrix], complex eigenvalues can't be stored in `D` as they
  /// are: a pair of complex conjugate eigenvalues `a +/- bi` is stored as the
  /// 2x2 block `[[a, b], [-b, a]]`, so `D` is block diagonal. Use
  /// [eigenvalues] to get the eigenvalues directly.
  ///
  /// A [MatrixException] is thrown if the matrix contains NaN or infinite
  /// values, or if it is not diagonalizable (because `V` is singular).
  ///
  /// {@macro matrix_not_square_error}
  List<Matrix<T>> eigenDecomposition();
}
