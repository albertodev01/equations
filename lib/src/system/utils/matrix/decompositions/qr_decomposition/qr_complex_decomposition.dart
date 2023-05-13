import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_decomposition.dart';

/// {@macro qr_decomposition_class_header}
///
/// This class performs the QR decomposition on [ComplexMatrix] types.
final class QRDecompositionComplex
    extends QRDecomposition<Complex, ComplexMatrix> {
  static const _zero = Complex.zero();

  /// Requires the [matrix] matrix to be decomposed.
  const QRDecompositionComplex({
    required super.matrix,
  });

  @override
  List<ComplexMatrix> decompose() {
    final matrixQR = matrix.toListOfList();
    final rows = matrix.rowCount;
    final columns = matrix.columnCount;
    final diagonal = List<Complex>.generate(columns, (index) => _zero);

    for (var k = 0; k < columns; k++) {
      // Compute 2-norm of k-th column.
      var nrm = _zero;
      for (var i = k; i < rows; i++) {
        nrm = _complexSideLen(nrm, matrixQR[i][k]);
      }

      if (nrm != _zero) {
        // Form k-th Householder vector.
        for (var i = k; i < rows; i++) {
          matrixQR[i][k] /= nrm;
        }

        matrixQR[k][k] += const Complex.fromReal(1);

        // Apply transformation to remaining columns.
        for (var j = k + 1; j < columns; j++) {
          var s = _zero;

          for (var i = k; i < rows; i++) {
            s += matrixQR[i][k] * matrixQR[i][j];
          }

          if (matrixQR[k][k] != const Complex.zero()) {
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
    final R = List<List<Complex>>.generate(
      columns,
      (index) => List<Complex>.generate(
        columns,
        (index) => _zero,
      ),
    );

    for (var i = 0; i < columns; i++) {
      for (var j = 0; j < columns; j++) {
        if (i < j) {
          R[i][j] = matrixQR[i][j];
        } else {
          if (i == j) {
            R[i][j] = diagonal[i];
          } else {
            R[i][j] = _zero;
          }
        }
      }
    }

    // Get Q
    final Q = List<List<Complex>>.generate(
      rows,
      (index) => List<Complex>.generate(
        columns,
        (index) => _zero,
      ),
    );

    for (var k = columns - 1; k >= 0; k--) {
      for (var i = 0; i < rows; i++) {
        Q[i][k] = _zero;
      }

      Q[k][k] = const Complex.fromReal(1);

      for (var j = k; j < columns; j++) {
        if (matrixQR[k][k] != _zero) {
          var s = _zero;

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
      ComplexMatrix.fromData(rows: rows, columns: columns, data: Q),
      ComplexMatrix.fromData(rows: columns, columns: columns, data: R),
    ];
  }

  Complex _complexSideLen(Complex a, Complex b) => (a.pow(2) + b.pow(2)).sqrt();
}
