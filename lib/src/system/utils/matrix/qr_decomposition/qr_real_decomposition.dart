import 'dart:math';
import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/qr_decomposition/qr_decomposition.dart';

/// QR decomposition, also known as a QR factorization or QU factorization, is
/// a decomposition of a matrix A into a product `A = QR` of:
///
///   - an orthogonal matrix Q
///   - an upper triangular matrix R
///
/// This class performs the QR decomposition on [RealMatrix] types.
class QRDecompositionReal extends QRDecomposition<double, RealMatrix> {
  /// Requires the [realMatrix] matrix to be decomposed.
  const QRDecompositionReal({
    required RealMatrix realMatrix,
  }) : super(matrix: realMatrix);

  @override
  List<RealMatrix> decompose() {
    final matrixQR = matrix.toListOfList();
    final rows = matrix.rowCount;
    final columns = matrix.columnCount;
    final diagonal = List<double>.generate(columns, (index) => 0.0);

    for (var k = 0; k < columns; k++) {
      // Compute 2-norm of k-th column.
      var nrm = 0.0;
      for (var i = k; i < rows; i++) {
        nrm = hypot(nrm, matrixQR[i][k]);
      }

      if (nrm != 0.0) {
        // Form k-th Householder vector.
        if (matrixQR[k][k] < 0) {
          nrm = -nrm;
        }

        for (var i = k; i < rows; i++) {
          matrixQR[i][k] /= nrm;
        }

        matrixQR[k][k] += 1.0;

        // Apply transformation to remaining columns.
        for (var j = k + 1; j < columns; j++) {
          var s = 0.0;

          for (var i = k; i < rows; i++) {
            s += matrixQR[i][k] * matrixQR[i][j];
          }

          s = -s / matrixQR[k][k];

          for (var i = k; i < rows; i++) {
            matrixQR[i][j] += s * matrixQR[i][k];
          }
        }
      }

      diagonal[k] = -nrm;
    }

    // Computing the 'R' matrix
    final R = List<List<double>>.generate(
      columns,
      (index) => List<double>.generate(columns, (index) => 0.0),
    );

    for (var i = 0; i < columns; i++) {
      for (var j = 0; j < columns; j++) {
        if (i < j) {
          R[i][j] = matrixQR[i][j];
        } else {
          if (i == j) {
            R[i][j] = diagonal[i];
          } else {
            R[i][j] = 0.0;
          }
        }
      }
    }

    // Get Q
    final Q = List<List<double>>.generate(
      rows,
      (index) => List<double>.generate(columns, (index) => 0.0),
    );

    for (var k = columns - 1; k >= 0; k--) {
      for (var i = 0; i < rows; i++) {
        Q[i][k] = 0.0;
      }

      Q[k][k] = 1.0;

      for (var j = k; j < columns; j++) {
        if (matrixQR[k][k] != 0) {
          var s = 0.0;

          for (var i = k; i < rows; i++) {
            s += matrixQR[i][k] * Q[i][j];
          }

          s = -s / matrixQR[k][k];

          for (var i = k; i < rows; i++) {
            Q[i][j] += s * matrixQR[i][k];
          }
        }
      }
    }

    // Returning Q and R
    return [
      RealMatrix.fromData(rows: rows, columns: columns, data: Q),
      RealMatrix.fromData(rows: columns, columns: columns, data: R),
    ];
  }

  @override
  double hypot(double a, double b) {
    if (a.abs() > b.abs()) {
      final r = b / a;
      return a.abs() * sqrt(1 + r * r);
    } else if (b != 0) {
      final r = a / b;
      return b.abs() * sqrt(1 + r * r);
    } else {
      return 0;
    }
  }
}
