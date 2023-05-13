import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_decomposition.dart';
import 'package:equations/src/utils/math_utils.dart';

/// {@macro qr_decomposition_class_header}
///
/// This class performs the QR decomposition on [RealMatrix] types.
final class QRDecompositionReal extends QRDecomposition<double, RealMatrix>
    with MathUtils {
  /// Requires the [matrix] matrix to be decomposed.
  const QRDecompositionReal({
    required super.matrix,
  });

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

          if (matrixQR[k][k] != 0) {
            s = -s / matrixQR[k][k];
          }

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
}
