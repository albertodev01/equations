import 'dart:math';
import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/eigenvalue_decomposition/eigen_real_decomposition.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_real_decomposition.dart';
import 'package:equations/src/system/utils/matrix/decompositions/singular_value_decomposition/real_svd.dart';
import 'package:equations/src/utils/math_utils.dart';

/// A simple Dart implementation of an `m x n` matrix whose data type is [double].
///
/// ```dart
/// final matrix = RealMatrix(
///   rowCount: 3,
///   columnCount: 4,
/// );
/// ```
///
/// By default, the cells of a matrix are initialized with all zeroes. You can
/// access elements of the matrix very conveniently with the following syntax:
///
/// ```dart
/// final matrix = RealMatrix(
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
class RealMatrix extends Matrix<double> with MathUtils {
  /// Creates a new `N x M` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with zeroes.
  ///
  /// If [identity] is set to `true` (by default it's `false`) then the matrix
  /// is initialized with all zeroes **and** the diagonal is filled with ones.
  RealMatrix({
    required int rows,
    required int columns,
    bool identity = false,
  }) : super(
          rows: rows,
          columns: columns,
          identity: identity,
          defaultValue: 0,
          identityOneValue: 1,
        );

  /// Creates a new `N x M` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with values from [data].
  RealMatrix.fromData({
    required int rows,
    required int columns,
    required List<List<double>> data,
  }) : super.fromData(
          rows: rows,
          columns: columns,
          data: data,
        );

  /// Creates a new `N x M` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with values from [data].
  ///
  /// The source matrix is expressed as an array whose size must **exactly** be
  /// `N` * `M`.
  RealMatrix.fromFlattenedData({
    required int rows,
    required int columns,
    required List<double> data,
  }) : super.fromFlattenedData(
          rows: rows,
          columns: columns,
          data: data,
        );

  /// Creates a new `N x M` matrix where [rows] is `N` and [columns] is `M`. The
  /// matrix is filled with [diagonalValue] in the main diagonal and zeroes
  /// otherwise.
  RealMatrix.diagonal({
    required int rows,
    required int columns,
    required double diagonalValue,
  }) : super.diagonal(
          rows: rows,
          columns: columns,
          diagonalValue: diagonalValue,
          defaultValue: 0,
        );

  void _setDataAt(List<double> flatMatrix, int row, int col, double value) =>
      flatMatrix[columnCount * row + col] = value;

  double _getDataAt(List<double> source, int row, int col) =>
      source[columnCount * row + col];

  @override
  Matrix<double> operator +(Matrix<double> other) {
    if ((rowCount != other.rowCount) || (columnCount != other.columnCount)) {
      throw const MatrixException('Matrices shapes mismatch! The column count '
          'of the source matrix must match the row count of the other.');
    }

    // Performing the sum
    final flatMatrix = List<double>.generate(
      rowCount * columnCount,
      (_) => 0.0,
      growable: false,
    );

    for (var i = 0; i < rowCount; ++i) {
      for (var j = 0; j < columnCount; ++j) {
        _setDataAt(flatMatrix, i, j, this(i, j) + other(i, j));
      }
    }

    // Building the new matrix
    return RealMatrix.fromFlattenedData(
      rows: rowCount,
      columns: columnCount,
      data: flatMatrix,
    );
  }

  @override
  Matrix<double> operator -(Matrix<double> other) {
    if ((rowCount != other.rowCount) || (columnCount != other.columnCount)) {
      throw const MatrixException('Matrices shapes mismatch! The column count '
          'of the source matrix must match the row count of the other.');
    }

    // Performing the difference
    final flatMatrix = List.generate(
      rowCount * columnCount,
      (_) => 0.0,
      growable: false,
    );

    for (var i = 0; i < rowCount; ++i) {
      for (var j = 0; j < columnCount; ++j) {
        _setDataAt(flatMatrix, i, j, this(i, j) - other(i, j));
      }
    }

    // Building the new matrix
    return RealMatrix.fromFlattenedData(
      rows: rowCount,
      columns: columnCount,
      data: flatMatrix,
    );
  }

  @override
  Matrix<double> operator *(Matrix<double> other) {
    if (columnCount != other.rowCount) {
      throw const MatrixException('Matrices shapes mismatch! The column count '
          'of the source matrix must match the row count of the other.');
    }

    // Performing the product
    final flatMatrix = List<double>.generate(
      rowCount * other.columnCount,
      (_) => 0.0,
      growable: false,
    );

    // Performing the multiplication
    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < other.columnCount; j++) {
        var sum = 0.0;
        for (var k = 0; k < other.rowCount; k++) {
          sum += this(i, k) * other(k, j);
        }
        flatMatrix[other.columnCount * i + j] = sum;
      }
    }

    // Building the new matrix
    return RealMatrix.fromFlattenedData(
      rows: rowCount,
      columns: other.columnCount,
      data: flatMatrix,
    );
  }

  @override
  Matrix<double> operator /(Matrix<double> other) {
    if ((rowCount != other.rowCount) || (columnCount != other.columnCount)) {
      throw const MatrixException('Matrices shapes mismatch! The column count '
          'of the source matrix must match the row count of the other.');
    }

    // Performing the division
    final flatMatrix = List.generate(
      rowCount * columnCount,
      (_) => 0.0,
      growable: false,
    );

    // Performing the division
    for (var i = 0; i < rowCount; ++i) {
      for (var j = 0; j < columnCount; ++j) {
        _setDataAt(flatMatrix, i, j, this(i, j) / other(i, j));
      }
    }

    // Building the new matrix
    return RealMatrix.fromFlattenedData(
      rows: rowCount,
      columns: columnCount,
      data: flatMatrix,
    );
  }

  @override
  RealMatrix transpose() {
    final source = List<double>.generate(rowCount * columnCount, (_) => 0);

    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < columnCount; j++) {
        source[rowCount * j + i] = this(i, j);
      }
    }

    return RealMatrix.fromFlattenedData(
      rows: columnCount,
      columns: rowCount,
      data: source,
    );
  }

  @override
  RealMatrix minor(int row, int col) {
    if (row < 0 || col < 0) {
      throw const MatrixException('The arguments must be positive!');
    }

    if (row > rowCount || col > columnCount) {
      throw const MatrixException('The given (row; col) pair is invalid.');
    }

    if (rowCount == 1 || columnCount == 1) {
      throw const MatrixException(
        'Cannot compute minors when "rowCount" or "columnCount" is 1.',
      );
    }

    final source = List<List<double>>.generate(rowCount - 1, (_) {
      return List<double>.generate(columnCount - 1, (_) => 0.0);
    });

    for (var i = 0; i < rowCount; ++i) {
      for (var j = 0; i != row && j < columnCount; ++j) {
        if (j != col) {
          final minorRow = i < row ? i : i - 1;
          final minorCol = j < col ? j : j - 1;

          source[minorRow][minorCol] = this(i, j);
        }
      }
    }

    return RealMatrix.fromData(
      rows: rowCount - 1,
      columns: columnCount - 1,
      data: source,
    );
  }

  @override
  RealMatrix cofactorMatrix() {
    if (!isSquareMatrix) {
      throw const MatrixException('The matrix must be square!');
    }

    // The cofactor matrix of an 1x1 matrix is always 1
    if (rowCount == 1) {
      return RealMatrix.fromFlattenedData(
        rows: 1,
        columns: 1,
        data: [1],
      );
    }

    final source = List<List<double>>.generate(rowCount, (_) {
      return List<double>.generate(columnCount, (_) => 0.0);
    });

    // Computing cofactors
    for (var i = 0; i < rowCount; ++i) {
      for (var j = 0; j < columnCount; ++j) {
        source[i][j] = pow(-1, i + j) * minor(i, j).determinant();
      }
    }

    return RealMatrix.fromData(
      rows: rowCount,
      columns: columnCount,
      data: source,
    );
  }

  @override
  RealMatrix inverse() {
    if (!isSquareMatrix) {
      throw const MatrixException('The matrix must be square!');
    }

    // The inverse of an 1x1 matrix "A" is simply "1/A(0,0)"
    if (rowCount == 1) {
      return RealMatrix.fromFlattenedData(
        rows: 1,
        columns: 1,
        data: [1 / this(0, 0)],
      );
    }

    // In case of a 2x2 matrix, we can directly compute it and save computational
    // time. Note that, from here, we're sure that this matrix is square so no
    // need to check both the row count and the col count.
    if (rowCount == 2) {
      final mult = 1 / (this(0, 0) * this(1, 1) - this(0, 1) * this(1, 0));

      return RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: [
          mult * this(1, 1),
          -mult * this(0, 1),
          -mult * this(1, 0),
          mult * this(0, 0),
        ],
      );
    }

    // If the matrix to be inverted is 3x3 or greater, let's use the cofactor
    // method to compute the inverse. The inverse of a matrix can be computed
    // like so:
    //
    //   A^(-1) = 1 / det(A) * cof(A)^(T)
    //
    // where 'det(A)' is the determinant of A and 'cof(A)^T' is the transposed
    // matrix of the cofactor matrix.
    final transpose = cofactorMatrix().transpose();

    // Multiplying each number by 1/det(A)
    final multiplier = 1 / determinant();
    final inverse = transpose.flattenData.map((value) {
      return multiplier * value;
    }).toList(growable: false);

    return RealMatrix.fromFlattenedData(
      rows: rowCount,
      columns: columnCount,
      data: inverse,
    );
  }

  @override
  double trace() {
    // Making sure that the matrix is squared
    if (!isSquareMatrix) {
      throw const MatrixException('The matrix is not square!');
    }

    // The trace value
    var trace = 0.0;

    // Computing the trace
    for (var i = 0; i < columnCount; ++i) {
      trace += this(i, i);
    }

    return trace;
  }

  @override
  bool isDiagonal() {
    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < columnCount; j++) {
        if ((i != j) && (this(i, j) != 0)) {
          return false;
        }
      }
    }

    return true;
  }

  @override
  bool isIdentity() {
    if (!isSquareMatrix) {
      throw const MatrixException('The matrix is not square!');
    }

    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < columnCount; j++) {
        if ((i != j) && (this(i, j) != 0)) {
          return false;
        }

        if ((i == j) && (this(i, j) != 1)) {
          return false;
        }
      }
    }

    return true;
  }

  @override
  int rank() {
    if (isSquareMatrix && rowCount == 1) {
      return this(0, 0) == 0 ? 0 : 1;
    }

    // If it's a square matrix, we can use the LU decomposition which is faster
    if (isSquareMatrix) {
      final lower = luDecomposition().first;

      // Linearly independent columns
      var independentCols = 0;

      for (var i = 0; i < lower.rowCount; ++i) {
        for (var j = 0; j < lower.columnCount; ++j) {
          if ((i == j) && (lower(i, j) != 0)) {
            ++independentCols;
          }
        }
      }

      return independentCols;
    }

    // If the matrix is rectangular and it's not 1x1, then use the "traditional"
    // algorithm
    var rank = 0;
    final matrix = toListOfList();

    const precision = 1.0e-12;
    final selectedRow = List<bool>.generate(rowCount, (_) => false);

    for (var i = 0; i < columnCount; ++i) {
      var j = 0;
      for (j = 0; j < rowCount; ++j) {
        if (!selectedRow[j] && matrix[j][i].abs() > precision) {
          break;
        }
      }

      if (j != rowCount) {
        ++rank;
        selectedRow[j] = true;

        for (var p = i + 1; p < columnCount; ++p) {
          matrix[j][p] /= matrix[j][i];
        }

        for (var k = 0; k < rowCount; ++k) {
          if (k != j && matrix[k][i].abs() > precision) {
            for (var p = i + 1; p < columnCount; ++p) {
              matrix[k][p] -= matrix[j][p] * matrix[k][i];
            }
          }
        }
      }
    }

    return rank;
  }

  @override
  double determinant() => _computeDeterminant(this);

  @override
  Algebraic characteristicPolynomial() {
    // Making sure that the matrix is squared
    if (!isSquareMatrix) {
      throw const MatrixException(
        'Eigenvalues can be computed on square matrices only!',
      );
    }

    // For 1x1 matrices, directly compute it
    if (rowCount == 1) {
      return Linear.realEquation(
        b: -this(0, 0),
      );
    }

    // For 2x2 matries, use a direct formula which is faster
    if (rowCount == 2) {
      return Quadratic.realEquation(
        b: -trace(),
        c: determinant(),
      );
    }

    // For 3x3 matrices and bigger, use the Faddeev–LeVerrier algorithm
    var supportMatrix = this;
    var oldTrace = supportMatrix.trace();

    // The coefficients of the characteristic polynomial. The coefficient of the
    // highest degree is always 1.
    final coefficients = <double>[1, -trace()];

    for (var i = 1; i < rowCount; ++i) {
      final diagonal = RealMatrix.diagonal(
        rows: rowCount,
        columns: columnCount,
        diagonalValue: (1 / i) * oldTrace,
      );

      supportMatrix = this * (supportMatrix - diagonal) as RealMatrix;
      oldTrace = supportMatrix.trace();

      coefficients.add((-1 / (i + 1)) * oldTrace);
    }

    return Algebraic.fromReal(coefficients);
  }

  @override
  List<Complex> eigenvalues() {
    // Making sure that the matrix is squared
    if (!isSquareMatrix) {
      throw const MatrixException(
        'Eigenvalues can be computed on square matrices only!',
      );
    }

    // From now on, we're sure that the matrix is square. If it's 1x1 or 2x2,
    // computing the roots of the characteristic polynomial is faster and more
    // precise.
    if (rowCount == 1 || rowCount == 2) {
      return characteristicPolynomial().solutions();
    }

    // For 3x3 matrices and bigger, use the "eigendecomposition" algorithm.
    final eigenDecomposition = EigendecompositionReal(
      matrix: this,
    );

    // The 'D' matrix contains real and complex coefficients of the eigenvalues
    // so we can ignore the other 2.
    final decomposition = eigenDecomposition.decompose()[1];
    final eigenvalues = <Complex>[];

    for (var i = 0; i < decomposition.rowCount; ++i) {
      // The real value is ALWAYS in the diagonal.
      final real = decomposition(i, i);

      // The imaginary part can be either on the right or the left of the main
      // diagonal, depending on the sign.
      if (i > 0 && i < (decomposition.rowCount - 1)) {
        // Values on the left and right of the diagonal.
        final pre = decomposition(i, i - 1);
        final post = decomposition(i, i + 1);

        if (pre == 0 && post == 0) {
          eigenvalues.add(Complex.fromReal(real));
        } else {
          eigenvalues.add(Complex(real, pre == 0 ? post : pre));
        }
      } else {
        // Here the loop is either at (0,0) or at the bottom of the diagonal so
        // we need to check only one side.
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
    // Making sure that the matrix is squared
    if (!isSquareMatrix) {
      throw const MatrixException(
        'LU decomposition only works with square matrices!',
      );
    }

    // Creating L and U matrices
    final L = List<double>.generate(
      rowCount * columnCount,
      (_) => 0.0,
      growable: false,
    );
    final U = List<double>.generate(
      rowCount * columnCount,
      (_) => 0.0,
      growable: false,
    );

    // Computing L and U
    for (var i = 0; i < rowCount; ++i) {
      for (var k = i; k < rowCount; k++) {
        // Summation of L(i, j) * U(j, k)
        var sum = 0.0;
        for (var j = 0; j < i; j++) {
          sum += _getDataAt(L, i, j) * _getDataAt(U, j, k);
        }

        // Evaluating U(i, k)
        _setDataAt(U, i, k, this(i, k) - sum);
      }

      // Lower Triangular
      for (var k = i; k < rowCount; k++) {
        if (i == k) {
          _setDataAt(L, i, i, 1);
        } else {
          // Summation of L(k, j) * U(j, i)
          var sum = 0.0;
          for (var j = 0; j < i; j++) {
            sum += _getDataAt(L, k, j) * _getDataAt(U, j, i);
          }

          // Evaluating L(k, i)
          _setDataAt(L, k, i, (this(k, i) - sum) / _getDataAt(U, i, i));
        }
      }
    }

    return [
      RealMatrix.fromFlattenedData(
        rows: rowCount,
        columns: rowCount,
        data: L,
      ),
      RealMatrix.fromFlattenedData(
        rows: rowCount,
        columns: rowCount,
        data: U,
      ),
    ];
  }

  @override
  List<RealMatrix> choleskyDecomposition() {
    // Making sure that the matrix is squared
    if (!isSquareMatrix) {
      throw const MatrixException(
        'LU decomposition only works with square matrices!',
      );
    }

    // Exit immediately because if [0,0] is a negative number, the algorithm
    // cannot even start since the square root of a negative number in R is not
    // allowed.
    if (this(0, 0) <= 0) {
      throw const SystemSolverException('The matrix is not positive-definite.');
    }

    // Creating L and Lt matrices
    final L = List.generate(
      rowCount * columnCount,
      (_) => 0.0,
      growable: false,
    );
    final transpL = List.generate(
      rowCount * columnCount,
      (_) => 0.0,
      growable: false,
    );

    // Computing the L matrix so that A = L * Lt (where 'Lt' is L transposed)
    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j <= i; j++) {
        var sum = 0.0;
        if (j == i) {
          for (var k = 0; k < j; k++) {
            sum += _getDataAt(L, j, k) * _getDataAt(L, j, k);
          }
          _setDataAt(L, j, j, sqrt(this(i, j) - sum));
        } else {
          for (var k = 0; k < j; k++) {
            sum += _getDataAt(L, i, k) * _getDataAt(L, j, k);
          }
          _setDataAt(L, i, j, (this(i, j) - sum) / _getDataAt(L, j, j));
        }
      }
    }

    // Computing Lt, the transposed version of L
    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < rowCount; j++) {
        _setDataAt(transpL, i, j, _getDataAt(L, j, i));
      }
    }

    return [
      RealMatrix.fromFlattenedData(
        rows: rowCount,
        columns: columnCount,
        data: L,
      ),
      RealMatrix.fromFlattenedData(
        rows: rowCount,
        columns: columnCount,
        data: transpL,
      ),
    ];
  }

  @override
  List<RealMatrix> qrDecomposition() {
    return QRDecompositionReal(
      realMatrix: this,
    ).decompose();
  }

  @override
  List<RealMatrix> singleValueDecomposition() {
    return SVDReal(
      realMatrix: this,
    ).decompose();
  }

  @override
  List<RealMatrix> eigenDecomposition() {
    return EigendecompositionReal(
      matrix: this,
    ).decompose();
  }

  /// Computes the determinant of a 2x2 matrix.
  double _compute2x2Determinant(RealMatrix source) {
    return source.flattenData.first * source.flattenData[3] -
        source.flattenData[1] * source.flattenData[2];
  }

  /// Computes the determinant of a 3x3 matrix.
  double _compute3x3Determinant(RealMatrix source) {
    final x = source.flattenData.first *
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

  /// Computes the determinant of a 4x4 matrix.
  double _compute4x4Determinant(RealMatrix source) {
    final det2_01_01 = source.flattenData.first * source.flattenData[5] -
        source.flattenData[1] * source.flattenData[4];
    final det2_01_02 = source.flattenData.first * source.flattenData[6] -
        source.flattenData[2] * source.flattenData[4];
    final det2_01_03 = source.flattenData.first * source.flattenData[7] -
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

  /// Computes the determinant of a matrix. In case of 1x1, 2x2, 3x3 and 4x4
  /// matrices, a direct formula is used for a more efficient computation.
  double _computeDeterminant(RealMatrix source) {
    // Computing the determinant only if the matrix is square
    if (!isSquareMatrix) {
      throw const MatrixException("Can't compute the determinant of this "
          "matrix because it's not square.");
    }

    // In case there were an 1x1 matrix, just return the value
    if (source.rowCount * source.columnCount == 1) {
      return source.flattenData.first;
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

    // In all the other cases, so when a matrix is 5x5 or bigger, the default
    // determinant computation happens via LU decomposition. Look at this well
    // known relation:
    //
    //  det(A) = det(L x U) = det(L) x det(U)
    //
    // In particular, the determinant of a lower triangular and an upper triangular
    // matrix is the product of the items in the diagonal.
    //
    // For this reason, the computation of the determinant is O(n^3) which is way
    // better than O(n!) from the Leibniz formula or the Laplace transformation!
    final lu = luDecomposition();

    var prodL = 1.0;
    var prodU = 1.0;

    // The determinant of L and U is the product of the elements on the diagonal
    for (var i = 0; i < rowCount; ++i) {
      prodL *= lu.first(i, i);
      prodU *= lu[1](i, i);
    }

    return prodL * prodU;
  }
}
