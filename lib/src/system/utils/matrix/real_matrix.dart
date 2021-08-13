import 'dart:math';
import 'package:equations/equations.dart';
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
    if (columnCount != other.rowCount) {
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
    if (columnCount != other.rowCount) {
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

    // In case of a 2x2 matrix, we can directly compute it and save computational
    // time. Note that, from here, we're sure that this matrix is square so no
    // need to check both the row count and the col count.
    if (rowCount == 2) {
      final multiplier =
          1 / (this(0, 0) * this(1, 1) - this(0, 1) * this(1, 0));

      return RealMatrix.fromFlattenedData(
        rows: 2,
        columns: 2,
        data: [
          multiplier * this(1, 1),
          -multiplier * this(0, 1),
          -multiplier * this(1, 0),
          multiplier * this(0, 0),
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
    final lower = luDecomposition()[0];

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

  @override
  double determinant() => _computeDeterminant(this);

  @override
  List<Complex> eigenValues() {
    // Making sure that the matrix is squared
    if (!isSquareMatrix) {
      throw const MatrixException(
        'Eigenvalues can be computed on square matrices only!',
      );
    }

    // From now on, we're sure that the matrix is square. If it's 1x1, then the
    // only eigenvalue is the only value in the matrix.
    if (rowCount == 1) {
      return [
        Complex.fromReal(this(0, 0)),
      ];
    }

    // In case of a 2x2 matrix, there is a direct formula we can use to avoid
    // The iterations of the QR algorithm.
    if (rowCount == 2) {
      final characteristicPolynomial = Quadratic.realEquation(
        b: -trace(),
        c: determinant(),
      );

      return characteristicPolynomial.solutions();
    }

    // For 3x3 matrices and bigger, we use the QR algorithm.
    var matrix = this;
    final values = <Complex>[];

    // The QR algorithm simply uses the QR factorization and iterates the product
    // of R x Q for 'n' steps
    for (var i = 0; i < 50; ++i) {
      final qr = matrix.qrDecomposition();
      matrix = qr[1] * qr[0] as RealMatrix;
    }

    // The eigenvalues are the elements in the diagonal
    for (var i = 0; i < matrix.columnCount; ++i) {
      values.add(Complex.fromReal(matrix(i, i)));
    }

    return values;
  }

  @override
  List<RealMatrix> luDecomposition() {
    // Making sure that the matrix is squared
    if (!isSquareMatrix) {
      throw const MatrixException(
          'LU decomposition only works with square matrices!');
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
          'LU decomposition only works with square matrices!');
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
      )
    ];
  }

  @override
  List<RealMatrix> qrDecomposition() => QRDecompositionReal(
        realMatrix: this,
      ).decompose();

  @override
  List<RealMatrix> singleValueDecomposition() => SVDReal(
        realMatrix: this,
      ).decompose();

  /// Computes the determinant of a 2x2 matrix.
  double _compute2x2Determinant(RealMatrix source) {
    return source.flattenData[0] * source.flattenData[3] -
        source.flattenData[1] * source.flattenData[2];
  }

  /// Computes the determinant of a 3x3 matrix.
  double _compute3x3Determinant(RealMatrix source) {
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

  /// Computes the determinant of a 4x4 matrix.
  double _compute4x4Determinant(RealMatrix source) {
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
  double _computeDeterminant(RealMatrix source) {
    // Computing the determinant only if the matrix is square
    if (!isSquareMatrix) {
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
      prodL *= lu[0](i, i);
      prodU *= lu[1](i, i);
    }

    return prodL * prodU;
  }
}
