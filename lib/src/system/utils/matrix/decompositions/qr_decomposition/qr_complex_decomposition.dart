import 'dart:math' as math;
import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/qr_decomposition/qr_decomposition.dart';

/// {@macro qr_decomposition_class_header}
///
/// This class performs the QR decomposition on [ComplexMatrix] types.
///
/// The implementation uses Householder reflections with special handling for
/// complex numbers to ensure numerical stability. The algorithm computes the
/// 2-norm of columns using a numerically stable method to avoid overflow and
/// underflow issues.
///
/// Example:
/// ```dart
/// final matrix = ComplexMatrix.fromData(
///   rows: 3,
///   columns: 2,
///   data: [
///     [Complex(1, 0), Complex(2, 1)],
///     [Complex(3, -1), Complex(4, 0)],
///     [Complex(5, 2), Complex(6, -1)],
///   ],
/// );
/// final decomposition = QRDecompositionComplex(matrix: matrix);
/// final [Q, R] = decomposition.decompose();
/// ```
final class QRDecompositionComplex
    extends QRDecomposition<Complex, ComplexMatrix> {
  /// Zero complex number constant.
  static const _zero = Complex.zero();

  /// Small value for numerical stability checks.
  static const _epsilon = 1e-10;

  /// {@macro qr_decomposition_class_header}
  const QRDecompositionComplex({required super.matrix});

  @override
  List<ComplexMatrix> decompose() {
    final matrixQR = matrix.toListOfList();
    final rows = matrix.rowCount;
    final columns = matrix.columnCount;
    final diagonal = List<Complex>.generate(columns, (index) => _zero);

    for (var k = 0; k < columns; k++) {
      // Compute 2-norm of k-th column using a more stable method
      var nrm = _zero;
      for (var i = k; i < rows; i++) {
        nrm = _complexNorm(nrm, matrixQR[i][k]);
      }

      // Check for numerical stability
      if (nrm.abs() < _epsilon) {
        throw const MatrixException('Matrix is numerically singular');
      }

      // Form k-th Householder vector
      for (var i = k; i < rows; i++) {
        matrixQR[i][k] /= nrm;
      }

      matrixQR[k][k] += const Complex.fromReal(1);

      // Apply transformation to remaining columns
      for (var j = k + 1; j < columns; j++) {
        var s = _zero;

        for (var i = k; i < rows; i++) {
          s += matrixQR[i][k] * matrixQR[i][j];
        }

        if (matrixQR[k][k].abs() > _epsilon) {
          s = -s / matrixQR[k][k];
        }

        for (var i = k; i < rows; i++) {
          matrixQR[i][j] += s * matrixQR[i][k];
        }
      }

      diagonal[k] = -nrm;
    }

    // Computing the 'R' matrix
    final R = List<List<Complex>>.generate(
      columns,
      (index) => List<Complex>.generate(columns, (index) => _zero),
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
      (index) => List<Complex>.generate(columns, (index) => _zero),
    );

    for (var k = columns - 1; k >= 0; k--) {
      for (var i = 0; i < rows; i++) {
        Q[i][k] = _zero;
      }

      Q[k][k] = const Complex.fromReal(1);

      for (var j = k; j < columns; j++) {
        if (matrixQR[k][k].abs() > _epsilon) {
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

  /// Computes the norm of a complex number in a numerically stable way.
  ///
  /// This method computes sqrt(|a|² + |b|²) using a scaling approach to
  /// prevent overflow and underflow when dealing with very large or very small
  /// complex numbers.
  ///
  /// Returns the norm as a [Complex] number.
  Complex _complexNorm(Complex a, Complex b) {
    final aAbs = a.abs();
    final bAbs = b.abs();
    if (aAbs > bAbs) {
      return a * Complex.fromReal(math.sqrt(1 + math.pow(bAbs / aAbs, 2)));
    } else if (bAbs > 0) {
      return b * Complex.fromReal(math.sqrt(math.pow(aAbs / bAbs, 2) + 1));
    } else {
      return _zero;
    }
  }
}
