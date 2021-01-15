import 'dart:math';
import 'package:equations/equations.dart';

/// TODO
class QRRealDecomposition extends QRDecomposition<double, RealMatrix> {
  /// TODO
  double _hypot(double a, double b) {
    if (a.abs() > b.abs()) {
      var r = b / a;
      r = a.abs() * sqrt(1 + r * r);
      return r;
    } else if (b != 0) {
      var r = a / b;
      r = b.abs() * sqrt(1 + r * r);
      return r;
    } else {
      return 0.0;
    }
  }

  /// TODO
  const QRRealDecomposition({required Matrix<double> source}) : super(source);

  @override
  List<double> getDiagonal(List<double> flattenedSource) {
    final QR = flattenedSource;
    final m = source.rowCount;
    final n = source.columnCount;
    final rDiag = List<double>.generate(n, (_) => 0.0);

    for (var k = 0; k < n; k++) {
      // Compute 2-norm of k-th column without under/overflow.
      var nrm = 0.0;
      for (var i = k; i < m; i++) {
        nrm = _hypot(nrm, getDataAt(QR, i, k));
      }

      if (nrm != 0.0) {
        // Form k-th Householder vector.
        if (getDataAt(QR, k, k) < 0) {
          nrm = -nrm;
        }
        for (var i = k; i < m; i++) {
          final value = getDataAt(QR, i, k);
          setDataAt(QR, i, k, value / nrm);
        }

        setDataAt(QR, k, k, getDataAt(QR, k, k) + 1.0);

        // Apply transformation to remaining columns.
        for (var j = k + 1; j < n; j++) {
          var s = 0.0;
          for (var i = k; i < m; i++) {
            s += getDataAt(QR, i, k) * getDataAt(QR, i, j);
          }
          s = -s / getDataAt(QR, k, k);
          for (var i = k; i < m; i++) {
            final source = getDataAt(QR, i, j) + s * getDataAt(QR, i, k);
            setDataAt(QR, i, j, source);
          }
        }
      }

      rDiag[k] = -nrm;
    }

    return rDiag;
  }

  @override
  RealMatrix getQ(List<double> flattenedSource, List<double> diagonal) {
    final size = source.columnCount * source.rowCount;
    final matrixQ = List<double>.filled(size, 0.0, growable: false);

    final n = source.columnCount;
    final m = source.rowCount;

    for (var k = n - 1; k >= 0; k--) {
      for (var i = 0; i < m; i++) {
        setDataAt(matrixQ, i, k, 0.0);
      }
      setDataAt(matrixQ, k, k, 1.0);
      for (var j = k; j < n; j++) {
        if (getDataAt(flattenedSource, k, k) != 0) {
          var s = 0.0;
          for (var i = k; i < m; i++) {
            s += getDataAt(flattenedSource, i, k) * getDataAt(matrixQ, i, j);
          }
          s = -s / getDataAt(flattenedSource, k, k);
          for (var i = k; i < m; i++) {
            final source = s * getDataAt(flattenedSource, i, k);
            setDataAt(matrixQ, i, j, getDataAt(matrixQ, i, j) + source);
          }
        }
      }
    }

    return RealMatrix.fromFlattenedData(
      rows: source.rowCount,
      columns: source.columnCount,
      data: matrixQ,
    );
  }

  @override
  RealMatrix getR(List<double> flattenedSource, List<double> diagonal) {
    final size = source.columnCount * source.columnCount;
    final matrixR = List<double>.generate(size, (_) => 0.0, growable: false);

    for (var i = 0; i < source.columnCount; i++) {
      for (var j = 0; j < source.columnCount; j++) {
        if (i < j) {
          setDataAt(matrixR, i, j, getDataAt(flattenedSource, i, j) * -1);
        } else if (i == j) {
          setDataAt(matrixR, i, j, diagonal[i] * -1);
        } else {
          setDataAt(matrixR, i, j, 0.0);
        }
      }
    }

    return RealMatrix.fromFlattenedData(
      rows: source.columnCount,
      columns: source.columnCount,
      data: matrixR,
    );
  }
}
